import Vapor

/// GET /v1/retrograde
///
/// Optional query params:
///   planet  — mercury, venus, mars, jupiter, saturn, uranus, neptune, pluto
///             (default: mercury)
///   year    — 4-digit year (default: current year)
///
/// Returns retrograde periods for the requested planet in the given year,
/// plus current retrograde status.
struct RetrogradeController {
    func index(req: Request) async throws -> RetrogradeResponse {
        // Parse planet (default: mercury)
        let planetStr = (req.query[String.self, at: "planet"] ?? "mercury")
            .lowercased()
        let planetInput = planetStr.prefix(1).uppercased() + planetStr.dropFirst()
        let planet = Planet(rawValue: planetInput) ?? .mercury

        guard planet != .sun && planet != .moon else {
            throw Abort(.badRequest, reason: "Sun and Moon do not go retrograde. " +
                        "Valid planets: mercury, venus, mars, jupiter, saturn, uranus, neptune, pluto")
        }

        // Parse year (default: current)
        let year: Int
        if let yearStr = req.query[String.self, at: "year"],
           let y = Int(yearStr), y > 1900, y < 2200 {
            year = y
        } else {
            var cal = Calendar(identifier: .gregorian)
            cal.timeZone = TimeZone(secondsFromGMT: 0)!
            year = cal.component(.year, from: Date())
        }

        // Current date for "is currently retrograde"
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        let now = Date()
        let currentYear  = cal.component(.year,  from: now)
        let currentMonth = cal.component(.month, from: now)
        let currentDay   = cal.component(.day,   from: now)

        let periods = AstrologyCalculationService.retrogradePeriods(planet: planet, year: year)

        let isCurrentlyRetro = year == currentYear
            ? AstrologyCalculationService.isCurrentlyRetrograde(
                planet: planet,
                year: currentYear, month: currentMonth, day: currentDay
              )
            : false

        let nextRetroStart = periods.first.map { $0.startDate }

        return RetrogradeResponse(
            planet: planet.rawValue,
            symbol: planet.symbol,
            meaning: planet.meaning,
            year: year,
            isCurrentlyRetrograde: isCurrentlyRetro,
            nextRetrogradeStart: nextRetroStart,
            periods: periods,
            whatItMeans: retrogradeMeaning(for: planet),
            calculationNote: "Retrograde dates based on historical patterns for 2025-2026 " +
                             "with orbital offsets for other years. " +
                             "Integrate SwissEphemeris velocity scanning for precise dates."
        )
    }

    private func retrogradeMeaning(for planet: Planet) -> String {
        switch planet {
        case .mercury:
            return "Mercury rules communication, technology, and travel. " +
                   "When retrograde: misunderstandings multiply, tech glitches spike, " +
                   "travel plans go sideways. Back up data, reread before sending, avoid signing contracts."
        case .venus:
            return "Venus rules love, beauty, money, and values. " +
                   "When retrograde: old flames resurface, financial decisions need revisiting, " +
                   "relationships get restructured. Not the time for major cosmetic changes or big purchases."
        case .mars:
            return "Mars rules action, drive, and desire. " +
                   "When retrograde: motivation stalls, anger turns inward, projects stall. " +
                   "Revisit existing goals rather than launching new ones."
        case .jupiter:
            return "Jupiter rules expansion, luck, and philosophy. " +
                   "When retrograde: growth slows, review beliefs and long-term goals. " +
                   "Internal wisdom expands even as external luck pauses."
        case .saturn:
            return "Saturn rules structure, karma, and responsibility. " +
                   "When retrograde: old lessons resurface, commitments get tested, " +
                   "boundaries need reassessing. Karmic review season."
        case .uranus:
            return "Uranus rules innovation, rebellion, and sudden change. " +
                   "When retrograde: inner revolution brews, disruptions become internalized, " +
                   "radical ideas need further development before action."
        case .neptune:
            return "Neptune rules dreams, intuition, and illusion. " +
                   "When retrograde: veils lift, delusions dissolve, spiritual clarity increases. " +
                   "The fog clears temporarily — use this window for honest self-examination."
        case .pluto:
            return "Pluto rules transformation, power, and rebirth. " +
                   "When retrograde: power struggles move underground, shadow work intensifies, " +
                   "collective transformation turns inward. Deep psychological excavation."
        case .sun, .moon:
            return ""
        }
    }
}

// MARK: - Response Shape

struct RetrogradeResponse: Content {
    let planet: String
    let symbol: String
    let meaning: String
    let year: Int
    let isCurrentlyRetrograde: Bool
    let nextRetrogradeStart: String?
    let periods: [RetrogradePeriod]
    let whatItMeans: String
    let calculationNote: String
}
