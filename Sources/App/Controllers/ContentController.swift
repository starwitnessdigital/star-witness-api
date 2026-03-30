import Vapor

/// Content Generation API — /v1/content/*
///
/// GET /v1/content/horoscope?sign=aries&date=2026-03-30
///   sign  — required; any zodiac sign name (case-insensitive)
///   date  — optional; YYYY-MM-DD (defaults to today UTC)
///
/// GET /v1/content/affirmations?category=abundance&count=5
///   category — required; one of the valid category slugs
///   count    — optional; 1–50 (default 5)
///
/// GET /v1/content/journal-prompts?theme=reflection&count=3
///   theme — required; one of the valid theme slugs
///   count — optional; 1–18 (default 3)
///
/// GET /v1/content/daily-card?date=2026-03-30
///   date — optional; YYYY-MM-DD (defaults to today UTC)
///
/// GET /v1/content/meditation?theme=calm&duration=5
///   theme    — optional; one of the valid theme slugs (default "calm")
///   duration — optional; 3, 5, 10, or 15 minutes (default 5)
struct ContentController {

    // MARK: - Daily Horoscope

    func horoscope(req: Request) async throws -> DailyHoroscopeResponse {
        guard let signStr = req.query[String.self, at: "sign"] else {
            throw Abort(.badRequest, reason: "Missing required query parameter: sign. Valid values: \(ZodiacSign.allCases.map { $0.rawValue.lowercased() }.joined(separator: ", "))")
        }

        let signInput = signStr.prefix(1).uppercased() + signStr.dropFirst().lowercased()
        guard let sign = ZodiacSign(rawValue: signInput) else {
            let valid = ZodiacSign.allCases.map { $0.rawValue.lowercased() }.joined(separator: ", ")
            throw Abort(.badRequest, reason: "Invalid sign '\(signStr)'. Valid values: \(valid)")
        }

        let (year, month, day) = parseDateParam(req: req)
        return ContentService.horoscope(sign: sign, year: year, month: month, day: day)
    }

    // MARK: - Affirmations

    func affirmations(req: Request) async throws -> AffirmationsResponse {
        guard let category = req.query[String.self, at: "category"] else {
            throw Abort(.badRequest, reason: "Missing required query parameter: category. Valid values: \(ContentService.validAffirmationCategories.joined(separator: ", "))")
        }

        let normalised = category.lowercased()
        guard ContentService.validAffirmationCategories.contains(normalised) else {
            throw Abort(.badRequest, reason: "Invalid category '\(category)'. Valid values: \(ContentService.validAffirmationCategories.joined(separator: ", "))")
        }

        let rawCount = req.query[Int.self, at: "count"] ?? 5
        let count = max(1, min(rawCount, 50))
        let items = ContentService.affirmations(category: normalised, count: count)

        return AffirmationsResponse(category: normalised, count: items.count, affirmations: items)
    }

    // MARK: - Journal Prompts

    func journalPrompts(req: Request) async throws -> JournalPromptsResponse {
        guard let theme = req.query[String.self, at: "theme"] else {
            throw Abort(.badRequest, reason: "Missing required query parameter: theme. Valid values: \(ContentService.validJournalThemes.joined(separator: ", "))")
        }

        let normalised = theme.lowercased()
        guard ContentService.validJournalThemes.contains(normalised) else {
            throw Abort(.badRequest, reason: "Invalid theme '\(theme)'. Valid values: \(ContentService.validJournalThemes.joined(separator: ", "))")
        }

        let rawCount = req.query[Int.self, at: "count"] ?? 3
        let count = max(1, min(rawCount, 18))
        let items = ContentService.journalPrompts(theme: normalised, count: count)

        return JournalPromptsResponse(theme: normalised, count: items.count, prompts: items)
    }

    // MARK: - Daily Card

    func dailyCard(req: Request) async throws -> DailyCardResponse {
        let (year, month, day) = parseDateParam(req: req)
        return ContentService.dailyCard(year: year, month: month, day: day)
    }

    // MARK: - Meditation

    func meditation(req: Request) async throws -> MeditationResponse {
        let themeParam = (req.query[String.self, at: "theme"] ?? "calm").lowercased()
        guard ContentService.validMeditationThemes.contains(themeParam) else {
            throw Abort(.badRequest, reason: "Invalid theme '\(themeParam)'. Valid values: \(ContentService.validMeditationThemes.joined(separator: ", "))")
        }

        let durationParam = req.query[Int.self, at: "duration"] ?? 5
        guard ContentService.validMeditationDurations.contains(durationParam) else {
            let valid = ContentService.validMeditationDurations.map { String($0) }.joined(separator: ", ")
            throw Abort(.badRequest, reason: "Invalid duration '\(durationParam)'. Valid values: \(valid) (minutes)")
        }

        return ContentService.meditation(theme: themeParam, durationMinutes: durationParam)
    }

    // MARK: - Helpers

    private func parseDateParam(req: Request) -> (year: Int, month: Int, day: Int) {
        if let dateStr = req.query[String.self, at: "date"],
           let parsed = dateStr.parseDate() {
            return parsed
        }
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        let now = Date()
        return (
            cal.component(.year, from: now),
            cal.component(.month, from: now),
            cal.component(.day, from: now)
        )
    }
}
