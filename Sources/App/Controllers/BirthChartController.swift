import Vapor

/// GET /v1/birth-chart
///
/// Required query params:
///   date       — YYYY-MM-DD (birth date)
///   time       — HH:MM      (birth time, 24h)
///   latitude   — decimal degrees (positive = N)
///   longitude  — decimal degrees (positive = E)
///   timezone   — UTC offset in hours, e.g. -5 (optional, defaults 0)
///
/// Returns a complete birth chart with planetary positions, houses, and aspects.
struct BirthChartController {
    func index(req: Request) async throws -> BirthChartResponse {
        // MARK: Parse & validate query params
        guard let dateStr = req.query[String.self, at: "date"],
              let parsed = dateStr.parseDate() else {
            throw Abort(.badRequest, reason: APIError.missingParam("date").reason)
        }
        let (year, month, day) = parsed

        guard let timeStr = req.query[String.self, at: "time"],
              let parsedTime = timeStr.parseTime() else {
            throw Abort(.badRequest, reason: APIError.missingParam("time (HH:MM)").reason)
        }
        let hour = Double(parsedTime.hour) + Double(parsedTime.minute) / 60.0

        guard let latStr = req.query[String.self, at: "latitude"],
              let latitude = Double(latStr) else {
            throw Abort(.badRequest, reason: APIError.missingParam("latitude").reason)
        }
        guard let lonStr = req.query[String.self, at: "longitude"],
              let longitude = Double(lonStr) else {
            throw Abort(.badRequest, reason: APIError.missingParam("longitude").reason)
        }
        let tzOffset = Double(req.query[String.self, at: "timezone"] ?? "0") ?? 0.0

        // MARK: Calculate
        // TODO: Replace with SwissEphemerisCalculator.calculateCompleteBirthChart() from Star Witness.
        // The iOS app's SwissEphemerisCalculator.swift is the reference implementation.

        let positions = AstrologyCalculationService.planetaryPositions(
            year: year, month: month, day: day,
            hour: hour,
            latitude: latitude, longitude: longitude,
            timezoneOffset: tzOffset
        )

        let sunSign   = AstrologyCalculationService.sunSign(year: year, month: month, day: day)
        let moonPos   = positions.first { $0.planet == Planet.moon.rawValue }
        let moonSign  = ZodiacSign(rawValue: moonPos?.sign ?? "") ?? .aries
        let risingSign = AstrologyCalculationService.risingSign(
            year: year, month: month, day: day,
            hour: hour, latitude: latitude, longitude: longitude,
            timezoneOffset: tzOffset
        )

        let cusps = AstrologyCalculationService.houseCusps(
            year: year, month: month, day: day,
            hour: hour, latitude: latitude, longitude: longitude,
            timezoneOffset: tzOffset
        )

        let aspects = AstrologyCalculationService.aspects(from: positions)

        return BirthChartResponse(
            date: dateStr,
            time: timeStr,
            latitude: latitude,
            longitude: longitude,
            sunSign: BirthChartResponse.SignDetail(
                name: sunSign.rawValue,
                symbol: sunSign.symbol,
                element: sunSign.element,
                modality: sunSign.modality,
                rulingPlanet: sunSign.rulingPlanet
            ),
            moonSign: BirthChartResponse.SignDetail(
                name: moonSign.rawValue,
                symbol: moonSign.symbol,
                element: moonSign.element,
                modality: moonSign.modality,
                rulingPlanet: moonSign.rulingPlanet
            ),
            risingSign: BirthChartResponse.SignDetail(
                name: risingSign.rawValue,
                symbol: risingSign.symbol,
                element: risingSign.element,
                modality: risingSign.modality,
                rulingPlanet: risingSign.rulingPlanet
            ),
            planets: positions,
            houses: cusps,
            aspects: aspects,
            calculationNote: "Planetary positions calculated using mean longitude approximations. " +
                             "Integrate SwissEphemeris for sub-degree accuracy."
        )
    }
}

// MARK: - Response Shape

struct BirthChartResponse: Content {
    struct SignDetail: Content {
        let name: String
        let symbol: String
        let element: String
        let modality: String
        let rulingPlanet: String
    }

    let date: String
    let time: String
    let latitude: Double
    let longitude: Double
    let sunSign: SignDetail
    let moonSign: SignDetail
    let risingSign: SignDetail
    let planets: [PlanetaryPosition]
    let houses: [HouseCusp]
    let aspects: [PlanetaryAspect]
    let calculationNote: String
}
