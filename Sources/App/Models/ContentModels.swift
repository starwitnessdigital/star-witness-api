import Vapor

// MARK: - Daily Horoscope

struct DailyHoroscopeResponse: Content {
    let sign: String
    let symbol: String
    let date: String
    let generalForecast: String
    let love: String
    let career: String
    let health: String
    let luckyNumber: Int
    let luckyColor: String
    let mood: String
    let compatibilityTip: String
}

// MARK: - Affirmations

struct AffirmationsResponse: Content {
    let category: String
    let count: Int
    let affirmations: [String]
}

// MARK: - Journal Prompts

struct JournalPromptsResponse: Content {
    let theme: String
    let count: Int
    let prompts: [String]
}

// MARK: - Daily Card

struct DailyCardResponse: Content {
    let date: String
    let card: TarotCard
    let isReversed: Bool
    let affirmation: String
    let journalPrompt: String
    let guidance: String
}

// MARK: - Meditation

struct MeditationSection: Content {
    let title: String
    let durationSeconds: Int
    let script: String
}

struct MeditationResponse: Content {
    let theme: String
    let durationMinutes: Int
    let sections: [MeditationSection]
    let fullScript: String
}
