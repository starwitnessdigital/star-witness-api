import Vapor

/// GET /v1/transits
///
/// Optional query params:
///   date       — YYYY-MM-DD (defaults to today)
///   latitude   — decimal degrees (required for house transits)
///   longitude  — decimal degrees (required for house transits)
///   timezone   — UTC offset hours (default 0)
///
/// Returns current sky: planetary positions, active aspects, retrograde status.
struct TransitsController {
    func index(req: Request) async throws -> TransitsResponse {
        // Parse optional date (default today UTC)
        let (year, month, day): (Int, Int, Int)
        if let dateStr = req.query[String.self, at: "date"],
           let parsed = dateStr.parseDate() {
            (year, month, day) = parsed
        } else {
            var cal = Calendar(identifier: .gregorian)
            cal.timeZone = TimeZone(secondsFromGMT: 0)!
            let now = Date()
            year  = cal.component(.year,  from: now)
            month = cal.component(.month, from: now)
            day   = cal.component(.day,   from: now)
        }

        let latitude  = Double(req.query[String.self, at: "latitude"]  ?? "")
        let longitude = Double(req.query[String.self, at: "longitude"] ?? "")
        let tzOffset  = Double(req.query[String.self, at: "timezone"]  ?? "0") ?? 0.0

        // Current sky positions (use noon UTC as reference)
        let positions = AstrologyCalculationService.planetaryPositions(
            year: year, month: month, day: day,
            hour: 12.0,
            latitude: latitude, longitude: longitude,
            timezoneOffset: tzOffset
        )

        let aspects = AstrologyCalculationService.aspects(from: positions)

        // Retrograde status for all planets
        let retrogradeStatus = Planet.allCases.compactMap { planet -> RetrogradeStatus? in
            guard planet != .sun && planet != .moon else { return nil }
            let isRetro = AstrologyCalculationService.isCurrentlyRetrograde(
                planet: planet,
                year: year, month: month, day: day
            )
            return RetrogradeStatus(planet: planet.rawValue, symbol: planet.symbol, isRetrograde: isRetro)
        }

        // Moon phase
        let moonPhase = AstrologyCalculationService.moonPhase(year: year, month: month, day: day)

        return TransitsResponse(
            date: String(format: "%04d-%02d-%02d", year, month, day),
            planets: positions,
            aspects: aspects,
            retrogradeStatus: retrogradeStatus,
            moonPhase: moonPhase.phase,
            moonPhaseEmoji: moonPhase.phaseEmoji,
            moonSign: moonPhase.moonSign,
            calculationNote: "Transit positions calculated for noon UTC. " +
                             "Integrate SwissEphemeris for hour-precise positions."
        )
    }
}

// MARK: - Response Shapes

struct RetrogradeStatus: Content {
    let planet: String
    let symbol: String
    let isRetrograde: Bool
}

struct TransitsResponse: Content {
    let date: String
    let planets: [PlanetaryPosition]
    let aspects: [PlanetaryAspect]
    let retrogradeStatus: [RetrogradeStatus]
    let moonPhase: String
    let moonPhaseEmoji: String
    let moonSign: String
    let calculationNote: String
}
