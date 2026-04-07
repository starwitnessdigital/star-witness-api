import Vapor

/// Siri / App Intents-optimized endpoints
///
/// All responses are concise and voice-friendly — designed to be read aloud
/// by Siri without modification. No arrays of deep objects, no field overload.
///
/// Routes (all under /v1/siri/):
///   GET /v1/siri/horoscope?sign=aries
///   GET /v1/siri/retrograde
///   GET /v1/siri/moon
///   GET /v1/siri/compatibility?sign1=aries&sign2=leo
///   GET /v1/siri/lucky?sign=aries
struct SiriController {

    // MARK: - Horoscope

    /// GET /v1/siri/horoscope?sign=aries
    ///
    /// Returns a 2-3 sentence conversational horoscope, voice-optimized.
    func horoscope(req: Request) async throws -> SiriHoroscopeResponse {
        let sign = try parseSign(req, param: "sign")

        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        let now = Date()
        let year  = cal.component(.year,  from: now)
        let month = cal.component(.month, from: now)
        let day   = cal.component(.day,   from: now)

        let full = AstrologyCalculationService.dailyHoroscope(sign: sign, year: year, month: month, day: day)

        // Trim to the first two sentences for voice brevity
        let sentences = full.horoscope.components(separatedBy: ". ")
        let voiceText: String
        if sentences.count >= 2 {
            voiceText = sentences.prefix(2).joined(separator: ". ") + "."
        } else {
            voiceText = full.horoscope
        }

        return SiriHoroscopeResponse(
            sign: sign.rawValue,
            horoscope: voiceText,
            mood: full.mood
        )
    }

    // MARK: - Retrograde

    /// GET /v1/siri/retrograde
    ///
    /// Answers the classic question: "Is Mercury retrograde?"
    func retrograde(req: Request) async throws -> SiriRetrogradeResponse {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        let now = Date()
        let year  = cal.component(.year,  from: now)
        let month = cal.component(.month, from: now)
        let day   = cal.component(.day,   from: now)

        let isRetro = AstrologyCalculationService.isCurrentlyRetrograde(
            planet: .mercury, year: year, month: month, day: day
        )

        let periods = AstrologyCalculationService.retrogradePeriods(planet: .mercury, year: year)

        // Find the next retrograde start that is in the future
        let todayStr = String(format: "%04d-%02d-%02d", year, month, day)
        let nextPeriod = periods.first { $0.startDate > todayStr }
        let nextDate = nextPeriod?.startDate

        let daysUntil: Int?
        if let next = nextDate, let d = daysBetween(from: todayStr, to: next) {
            daysUntil = d
        } else {
            daysUntil = nil
        }

        let summary: String
        if isRetro {
            let endDate = periods.first { $0.startDate <= todayStr && $0.endDate >= todayStr }?.endDate ?? "soon"
            summary = "Mercury is retrograde until \(endDate). Back up your data, reread messages before sending, and avoid signing contracts."
        } else if let days = daysUntil, let next = nextDate {
            if days == 0 {
                summary = "Mercury goes retrograde today. Start preparing — back up devices and finish contracts before tonight."
            } else if days <= 7 {
                summary = "Mercury is direct but goes retrograde in \(days) days on \(next). Wrap up contracts and important decisions now."
            } else {
                summary = "Mercury is direct. You're clear to sign contracts and start new projects."
            }
        } else {
            summary = "Mercury is direct. You're clear to sign contracts and start new projects."
        }

        return SiriRetrogradeResponse(
            is_retrograde: isRetro,
            next_retrograde: nextDate,
            days_until: daysUntil,
            summary: summary
        )
    }

    // MARK: - Moon Phase

    /// GET /v1/siri/moon
    ///
    /// Current moon phase with a single voice-ready sentence.
    func moon(req: Request) async throws -> SiriMoonResponse {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        let now = Date()
        let year  = cal.component(.year,  from: now)
        let month = cal.component(.month, from: now)
        let day   = cal.component(.day,   from: now)

        let result = AstrologyCalculationService.moonPhase(year: year, month: month, day: day)
        let pct = Int(result.illuminationPercent.rounded())

        let summary = moonSummary(phase: result.phase, illumination: pct)

        return SiriMoonResponse(
            phase: result.phase,
            illumination: pct,
            summary: summary
        )
    }

    // MARK: - Compatibility

    /// GET /v1/siri/compatibility?sign1=aries&sign2=leo
    ///
    /// Quick sign-to-sign voice summary.
    func compatibility(req: Request) async throws -> SiriCompatibilityResponse {
        let sign1 = try parseSign(req, param: "sign1")
        let sign2 = try parseSign(req, param: "sign2")

        let score = AstrologyCalculationService.compatibilityScore(sign1: sign1, sign2: sign2)
        let summary = compatibilitySummary(sign1: sign1, sign2: sign2, score: score)

        return SiriCompatibilityResponse(
            score: score,
            summary: summary
        )
    }

    // MARK: - Lucky

    /// GET /v1/siri/lucky?sign=aries
    ///
    /// Daily lucky snapshot — number, color, energy level, one-word vibe.
    func lucky(req: Request) async throws -> SiriLuckyResponse {
        let sign = try parseSign(req, param: "sign")

        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        let now = Date()
        let year  = cal.component(.year,  from: now)
        let month = cal.component(.month, from: now)
        let day   = cal.component(.day,   from: now)

        let full = AstrologyCalculationService.dailyHoroscope(sign: sign, year: year, month: month, day: day)

        let luckyNumber = full.luckyNumbers.first ?? 7
        let energy = energyLevel(mood: full.mood)
        let oneWord = oneWordVibe(sign: sign, mood: full.mood, seed: year * 10000 + month * 100 + day)

        return SiriLuckyResponse(
            lucky_number: luckyNumber,
            lucky_color: full.luckyColor,
            energy: energy,
            one_word: oneWord
        )
    }

    // MARK: - Private Helpers

    private func parseSign(_ req: Request, param: String) throws -> ZodiacSign {
        guard let raw = req.query[String.self, at: param] else {
            throw Abort(.badRequest, reason: "Missing required query parameter: \(param)")
        }
        let capitalized = raw.prefix(1).uppercased() + raw.dropFirst().lowercased()
        guard let sign = ZodiacSign(rawValue: capitalized) else {
            let valid = ZodiacSign.allCases.map { $0.rawValue.lowercased() }.joined(separator: ", ")
            throw Abort(.badRequest, reason: "Invalid sign '\(raw)'. Valid values: \(valid)")
        }
        return sign
    }

    private func daysBetween(from: String, to: String) -> Int? {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        fmt.timeZone = TimeZone(secondsFromGMT: 0)
        guard let d1 = fmt.date(from: from), let d2 = fmt.date(from: to) else { return nil }
        return Calendar(identifier: .gregorian).dateComponents([.day], from: d1, to: d2).day
    }

    private func moonSummary(phase: String, illumination: Int) -> String {
        switch phase {
        case "New Moon":
            return "The moon is dark and new — a perfect moment for setting fresh intentions."
        case "Waxing Crescent":
            return "The moon is \(illumination)% illuminated and just beginning to grow. Plant seeds and take early action."
        case "First Quarter":
            return "The moon is half lit at \(illumination)%. Push through obstacles and make key decisions."
        case "Waxing Gibbous":
            return "The moon is \(illumination)% illuminated and growing. Good energy for pushing forward on goals."
        case "Full Moon":
            return "The moon is fully illuminated. Emotions run high — a powerful night for clarity and release."
        case "Waning Gibbous":
            return "The moon is \(illumination)% illuminated and beginning to fade. A great time to share what you've learned."
        case "Last Quarter":
            return "The moon is half lit at \(illumination)% and waning. Let go of what isn't working."
        case "Waning Crescent":
            return "The moon is \(illumination)% illuminated and almost gone. Rest, reflect, and prepare for the new cycle."
        default:
            return "The moon is \(illumination)% illuminated."
        }
    }

    private func compatibilitySummary(sign1: ZodiacSign, sign2: ZodiacSign, score: Int) -> String {
        let sameElement = sign1.element == sign2.element
        let complements: [String: String] = ["Fire": "Air", "Earth": "Water", "Air": "Fire", "Water": "Earth"]
        let complementary = complements[sign1.element] == sign2.element

        let opener: String
        switch score {
        case 90...:
            opener = "\(sign1.rawValue) and \(sign2.rawValue) are an exceptional match."
        case 80..<90:
            opener = "\(sign1.rawValue) and \(sign2.rawValue) are a strong match."
        case 65..<80:
            opener = "\(sign1.rawValue) and \(sign2.rawValue) have real potential together."
        case 50..<65:
            opener = "\(sign1.rawValue) and \(sign2.rawValue) can make it work with some effort."
        default:
            opener = "\(sign1.rawValue) and \(sign2.rawValue) are a challenging but growth-filled pairing."
        }

        let closer: String
        if sameElement {
            closer = "Both \(sign1.element) signs, you share the same fundamental energy and rarely have to explain yourselves."
        } else if complementary {
            closer = "\(sign1.element) and \(sign2.element) are complementary — you naturally energize each other."
        } else if score >= 75 {
            closer = "Your differences create a fascinating tension that keeps things interesting."
        } else {
            closer = "Growth comes from learning each other's very different emotional languages."
        }

        return "\(opener) \(closer)"
    }

    private func energyLevel(mood: String) -> String {
        switch mood.lowercased() {
        case let m where m.contains("excit") || m.contains("bold") || m.contains("passion") || m.contains("fire"):
            return "high"
        case let m where m.contains("calm") || m.contains("peace") || m.contains("reflect") || m.contains("rest"):
            return "low"
        default:
            return "moderate"
        }
    }

    private func oneWordVibe(sign: ZodiacSign, mood: String, seed: Int) -> String {
        let vibesBySign: [ZodiacSign: [String]] = [
            .aries:       ["Bold", "Fierce", "Driven", "Electric", "Unstoppable"],
            .taurus:      ["Grounded", "Luxe", "Steady", "Lush", "Patient"],
            .gemini:      ["Curious", "Witty", "Alive", "Quick", "Mercurial"],
            .cancer:      ["Intuitive", "Nurturing", "Deep", "Tender", "Flowing"],
            .leo:         ["Radiant", "Magnetic", "Regal", "Warm", "Luminous"],
            .virgo:       ["Precise", "Clear", "Discerning", "Sharp", "Practical"],
            .libra:       ["Balanced", "Graceful", "Charming", "Harmonious", "Fair"],
            .scorpio:     ["Intense", "Perceptive", "Magnetic", "Transforming", "Powerful"],
            .sagittarius: ["Free", "Optimistic", "Expansive", "Adventurous", "Open"],
            .capricorn:   ["Ambitious", "Disciplined", "Focused", "Resolute", "Strategic"],
            .aquarius:    ["Visionary", "Innovative", "Independent", "Electric", "Ahead"],
            .pisces:      ["Dreamy", "Fluid", "Empathic", "Mystical", "Flowing"],
        ]
        let options = vibesBySign[sign] ?? ["Aligned"]
        return options[seed % options.count]
    }
}

// MARK: - Response Shapes

struct SiriHoroscopeResponse: Content {
    let sign: String
    let horoscope: String
    let mood: String
}

struct SiriRetrogradeResponse: Content {
    let is_retrograde: Bool
    let next_retrograde: String?
    let days_until: Int?
    let summary: String
}

struct SiriMoonResponse: Content {
    let phase: String
    let illumination: Int
    let summary: String
}

struct SiriCompatibilityResponse: Content {
    let score: Int
    let summary: String
}

struct SiriLuckyResponse: Content {
    let lucky_number: Int
    let lucky_color: String
    let energy: String
    let one_word: String
}
