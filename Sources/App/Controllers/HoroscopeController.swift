import Vapor

/// GET /v1/daily-horoscope
///
/// Required query params:
///   sign  — aries, taurus, gemini, cancer, leo, virgo, libra,
///           scorpio, sagittarius, capricorn, aquarius, pisces
///
/// Optional query params:
///   date  — YYYY-MM-DD (defaults to today UTC)
struct HoroscopeController {
    func index(req: Request) async throws -> DailyHoroscopeResult {
        guard let signStr = req.query[String.self, at: "sign"] else {
            throw Abort(.badRequest, reason: "Missing required query parameter: sign")
        }

        // Accept both lowercase and capitalized
        let signInput = signStr.prefix(1).uppercased() + signStr.dropFirst().lowercased()
        guard let sign = ZodiacSign(rawValue: signInput) else {
            let valid = ZodiacSign.allCases.map { $0.rawValue.lowercased() }.joined(separator: ", ")
            throw Abort(.badRequest, reason: "Invalid sign '\(signStr)'. Valid values: \(valid)")
        }

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

        // TODO: Replace with AI-generated horoscope using Claude API:
        //   let client = Anthropic.Client(apiKey: Environment.get("ANTHROPIC_API_KEY")!)
        //   let prompt = "Write a 3-sentence daily horoscope for \(sign.rawValue)..."
        //   let message = try await client.messages.create(model: "claude-opus-4-6", ...)
        //   return parseHoroscopeResponse(message)
        return AstrologyCalculationService.dailyHoroscope(
            sign: sign,
            year: year, month: month, day: day
        )
    }
}
