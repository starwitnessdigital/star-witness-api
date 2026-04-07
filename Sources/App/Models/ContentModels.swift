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

// MARK: - Compatibility Report

struct CompatibilityReportResponse: Content {
    let sign1: String
    let sign2: String
    let overallScore: Int
    let overview: String
    let love: String
    let friendship: String
    let communication: String
    let trust: String
    let values: String
    let challenges: String
    let advice: String
}

// MARK: - Zodiac Profile

struct ZodiacProfileResponse: Content {
    let sign: String
    let symbol: String
    let element: String
    let modality: String
    let rulingPlanet: String
    let dates: String
    let overview: String
    let personalityTraits: [String]
    let strengths: [String]
    let weaknesses: [String]
    let loveStyle: String
    let careerStrengths: String
    let bestMatches: [String]
    let worstMatches: [String]
}

// MARK: - Transit Forecast

struct TransitForecastResponse: Content {
    let sign: String
    let period: String
    let overview: String
    let love: String
    let career: String
    let health: String
    let luckyNumber: Int
    let luckyColor: String
    let mood: String
    let energyLevel: Int
    let advice: String
}
