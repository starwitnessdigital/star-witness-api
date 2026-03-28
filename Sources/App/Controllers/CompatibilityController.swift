import Vapor

/// GET /v1/compatibility
///
/// Required query params:
///   person1_date   — YYYY-MM-DD
///   person1_time   — HH:MM
///   person1_lat    — decimal degrees
///   person1_lon    — decimal degrees
///   person2_date   — YYYY-MM-DD
///   person2_time   — HH:MM
///   person2_lat    — decimal degrees
///   person2_lon    — decimal degrees
///   timezone       — UTC offset hours (optional, applies to both, default 0)
///
/// Returns compatibility score, element harmony, Venus/Mars aspects, synastry highlights.
struct CompatibilityController {
    func index(req: Request) async throws -> CompatibilityResponse {

        // MARK: Parse Person 1
        guard let d1 = req.query[String.self, at: "person1_date"],
              let p1 = d1.parseDate() else {
            throw Abort(.badRequest, reason: "Missing person1_date (YYYY-MM-DD)")
        }
        guard let t1 = req.query[String.self, at: "person1_time"],
              let pt1 = t1.parseTime() else {
            throw Abort(.badRequest, reason: "Missing person1_time (HH:MM)")
        }
        guard let lat1Str = req.query[String.self, at: "person1_lat"],
              let lat1 = Double(lat1Str) else {
            throw Abort(.badRequest, reason: "Missing person1_lat")
        }
        guard let lon1Str = req.query[String.self, at: "person1_lon"],
              let lon1 = Double(lon1Str) else {
            throw Abort(.badRequest, reason: "Missing person1_lon")
        }

        // MARK: Parse Person 2
        guard let d2 = req.query[String.self, at: "person2_date"],
              let p2 = d2.parseDate() else {
            throw Abort(.badRequest, reason: "Missing person2_date (YYYY-MM-DD)")
        }
        guard let t2 = req.query[String.self, at: "person2_time"],
              let pt2 = t2.parseTime() else {
            throw Abort(.badRequest, reason: "Missing person2_time (HH:MM)")
        }
        guard let lat2Str = req.query[String.self, at: "person2_lat"],
              let lat2 = Double(lat2Str) else {
            throw Abort(.badRequest, reason: "Missing person2_lat")
        }
        guard let lon2Str = req.query[String.self, at: "person2_lon"],
              let lon2 = Double(lon2Str) else {
            throw Abort(.badRequest, reason: "Missing person2_lon")
        }

        let tz = Double(req.query[String.self, at: "timezone"] ?? "0") ?? 0.0

        // MARK: Calculate both charts
        let h1 = Double(pt1.hour) + Double(pt1.minute) / 60.0
        let h2 = Double(pt2.hour) + Double(pt2.minute) / 60.0

        let pos1 = AstrologyCalculationService.planetaryPositions(
            year: p1.year, month: p1.month, day: p1.day, hour: h1,
            latitude: lat1, longitude: lon1, timezoneOffset: tz
        )
        let pos2 = AstrologyCalculationService.planetaryPositions(
            year: p2.year, month: p2.month, day: p2.day, hour: h2,
            latitude: lat2, longitude: lon2, timezoneOffset: tz
        )

        let sun1  = ZodiacSign(rawValue: pos1.first { $0.planet == "Sun"  }?.sign ?? "") ?? AstrologyCalculationService.sunSign(year: p1.year, month: p1.month, day: p1.day)
        let sun2  = ZodiacSign(rawValue: pos2.first { $0.planet == "Sun"  }?.sign ?? "") ?? AstrologyCalculationService.sunSign(year: p2.year, month: p2.month, day: p2.day)
        let moon1 = ZodiacSign(rawValue: pos1.first { $0.planet == "Moon" }?.sign ?? "") ?? .aries
        let moon2 = ZodiacSign(rawValue: pos2.first { $0.planet == "Moon" }?.sign ?? "") ?? .aries
        let venus1 = ZodiacSign(rawValue: pos1.first { $0.planet == "Venus" }?.sign ?? "") ?? .aries
        let venus2 = ZodiacSign(rawValue: pos2.first { $0.planet == "Venus" }?.sign ?? "") ?? .aries
        let mars1  = ZodiacSign(rawValue: pos1.first { $0.planet == "Mars"  }?.sign ?? "") ?? .aries
        let mars2  = ZodiacSign(rawValue: pos2.first { $0.planet == "Mars"  }?.sign ?? "") ?? .aries

        // MARK: Scores
        let sunScore   = AstrologyCalculationService.compatibilityScore(sign1: sun1,   sign2: sun2)
        let moonScore  = AstrologyCalculationService.compatibilityScore(sign1: moon1,  sign2: moon2)
        let venusScore = AstrologyCalculationService.compatibilityScore(sign1: venus1, sign2: venus2)
        let marsScore  = AstrologyCalculationService.compatibilityScore(sign1: mars1,  sign2: mars2)
        let overallScore = (sunScore * 30 + moonScore * 30 + venusScore * 25 + marsScore * 15) / 100

        // MARK: Element harmony
        let elementHarmony = elementHarmonyDescription(e1: sun1.element, e2: sun2.element)

        // MARK: Synastry cross-aspects
        // TODO: For full synastry, compute aspects between ALL of person1's planets
        //       and ALL of person2's planets using the same AspectCalculator logic.
        //       Current implementation highlights the Venus/Mars interplay only.
        let venusMarsCross = AstrologyCalculationService.compatibilityScore(sign1: venus1, sign2: mars2)
        let marsVenusCross = AstrologyCalculationService.compatibilityScore(sign1: mars1,  sign2: venus2)
        let avgAttractionScore = (venusMarsCross + marsVenusCross) / 2

        let highlights = synastryHighlights(
            sun1: sun1, sun2: sun2,
            moon1: moon1, moon2: moon2,
            venus1: venus1, venus2: venus2,
            mars1: mars1, mars2: mars2,
            overallScore: overallScore
        )

        return CompatibilityResponse(
            overallScore: overallScore,
            overallRating: scoreRating(overallScore),
            breakdown: CompatibilityResponse.Breakdown(
                sunCompatibility: sunScore,
                moonCompatibility: moonScore,
                venusCompatibility: venusScore,
                marsCompatibility: marsScore,
                attractionScore: avgAttractionScore
            ),
            person1: CompatibilityResponse.PersonSummary(
                sunSign: sun1.rawValue,
                moonSign: moon1.rawValue,
                venusSign: venus1.rawValue,
                marsSign: mars1.rawValue,
                element: sun1.element
            ),
            person2: CompatibilityResponse.PersonSummary(
                sunSign: sun2.rawValue,
                moonSign: moon2.rawValue,
                venusSign: venus2.rawValue,
                marsSign: mars2.rawValue,
                element: sun2.element
            ),
            elementHarmony: elementHarmony,
            synastryHighlights: highlights,
            calculationNote: "Compatibility scored on Sun/Moon/Venus/Mars sign angles. " +
                             "Full synastry cross-aspects require SwissEphemeris integration."
        )
    }

    private func scoreRating(_ score: Int) -> String {
        switch score {
        case 85...: return "Cosmic Match ✨"
        case 70..<85: return "Strong Connection 💫"
        case 55..<70: return "Promising Potential 🌙"
        case 40..<55: return "Growth Opportunity 🌱"
        default:      return "Opposites Attract ⚡"
        }
    }

    private func elementHarmonyDescription(e1: String, e2: String) -> String {
        if e1 == e2 {
            return "Same element (\(e1)) — deep intuitive understanding, though you may amplify each other's extremes."
        }
        let complements = ["Fire": "Air", "Earth": "Water", "Air": "Fire", "Water": "Earth"]
        if complements[e1] == e2 {
            return "\(e1) and \(e2) — complementary elements that naturally energize each other."
        }
        let neutral = ["Fire": "Earth", "Earth": "Fire", "Air": "Water", "Water": "Air"]
        if neutral[e1] == e2 {
            return "\(e1) and \(e2) — some friction to navigate, but growth potential is high."
        }
        return "\(e1) and \(e2) — contrasting energies that can create fascinating tension."
    }

    private func synastryHighlights(
        sun1: ZodiacSign, sun2: ZodiacSign,
        moon1: ZodiacSign, moon2: ZodiacSign,
        venus1: ZodiacSign, venus2: ZodiacSign,
        mars1: ZodiacSign, mars2: ZodiacSign,
        overallScore: Int
    ) -> [String] {
        var highlights: [String] = []

        // Sun-Moon connection
        let sunMoon = AstrologyCalculationService.compatibilityScore(sign1: sun1, sign2: moon2)
        let moonSun = AstrologyCalculationService.compatibilityScore(sign1: moon1, sign2: sun2)
        if sunMoon >= 80 || moonSun >= 80 {
            highlights.append("Strong Sun-Moon connection — one person's core identity resonates deeply with the other's emotional needs.")
        }

        // Same element suns
        if sun1.element == sun2.element {
            highlights.append("Shared \(sun1.element) element — you move through the world with a similar fundamental energy and can communicate without explaining yourself.")
        }

        // Venus-Venus match
        let vv = AstrologyCalculationService.compatibilityScore(sign1: venus1, sign2: venus2)
        if vv >= 80 {
            highlights.append("Venus harmony — shared values around love, beauty, and what makes life worth living. Date nights are likely excellent.")
        }

        // Mars-Mars match
        let mm = AstrologyCalculationService.compatibilityScore(sign1: mars1, sign2: mars2)
        if mm >= 75 {
            highlights.append("Mars alignment — physical energy and ambition styles are compatible. You push each other forward rather than sideways.")
        }

        // Moon-Moon match
        let moonMoon = AstrologyCalculationService.compatibilityScore(sign1: moon1, sign2: moon2)
        if moonMoon >= 80 {
            highlights.append("Moon resonance — emotional needs and instincts are closely aligned. Fewer misunderstandings at the feeling level.")
        }

        if highlights.isEmpty {
            highlights.append("Every chart pairing has unique gifts — this one's growth potential lies in learning each other's radically different emotional languages.")
        }

        return highlights
    }
}

// MARK: - Response Shape

struct CompatibilityResponse: Content {
    struct Breakdown: Content {
        let sunCompatibility: Int
        let moonCompatibility: Int
        let venusCompatibility: Int
        let marsCompatibility: Int
        let attractionScore: Int
    }

    struct PersonSummary: Content {
        let sunSign: String
        let moonSign: String
        let venusSign: String
        let marsSign: String
        let element: String
    }

    let overallScore: Int
    let overallRating: String
    let breakdown: Breakdown
    let person1: PersonSummary
    let person2: PersonSummary
    let elementHarmony: String
    let synastryHighlights: [String]
    let calculationNote: String
}
