import Vapor

// MARK: - Tarot Models

struct TarotCard: Content {
    let name: String
    let arcana: String
    let suit: String?
    let number: Int
    let uprightMeaning: String
    let reversedMeaning: String
    let keywords: [String]
    let element: String
    let zodiacAssociation: String
    let yesNo: String
}

struct TarotSpread: Content {
    let name: String
    let slug: String
    let cardCount: Int
    let description: String
    let positions: [String]
}

struct TarotCardPosition: Content {
    let position: String
    let positionDescription: String
    let card: TarotCard
    let isReversed: Bool
    let interpretation: String
}

struct TarotReadingResponse: Content {
    let spread: TarotSpread
    let cards: [TarotCardPosition]
    let overallInterpretation: String
}

// MARK: - Numerology Models

struct NumerologyResult: Content {
    let type: String
    let number: Int
    let name: String
    let meaning: String
    let traits: [String]
    let strengths: [String]
    let challenges: [String]
    let lifeTheme: String
}

struct FullNumerologyReading: Content {
    let inputName: String?
    let inputBirthdate: String?
    let lifePath: NumerologyResult?
    let expression: NumerologyResult?
    let soulUrge: NumerologyResult?
    let personality: NumerologyResult?
    let summary: String
}

// MARK: - Crystal Models

struct CrystalProperties: Content {
    let healing: [String]
    let emotional: [String]
    let spiritual: [String]
}

struct Crystal: Content {
    let name: String
    let description: String
    let properties: CrystalProperties
    let chakraAssociations: [String]
    let zodiacAssociations: [String]
    let element: String
    let hardness: String
    let color: String
    let cleansingMethods: [String]
}

// MARK: - Chakra Models

struct Chakra: Content {
    let name: String
    let sanskritName: String
    let number: Int
    let location: String
    let color: String
    let element: String
    let purpose: String
    let balancedTraits: [String]
    let imbalancedTraits: [String]
    let associatedCrystals: [String]
    let healingPractices: [String]
    let affirmations: [String]
    let foods: [String]
}
