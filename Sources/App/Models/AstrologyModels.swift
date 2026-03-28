import Vapor

// MARK: - ZodiacSign

enum ZodiacSign: String, CaseIterable, Codable, Content {
    case aries = "Aries"
    case taurus = "Taurus"
    case gemini = "Gemini"
    case cancer = "Cancer"
    case leo = "Leo"
    case virgo = "Virgo"
    case libra = "Libra"
    case scorpio = "Scorpio"
    case sagittarius = "Sagittarius"
    case capricorn = "Capricorn"
    case aquarius = "Aquarius"
    case pisces = "Pisces"

    var symbol: String {
        switch self {
        case .aries: "♈"
        case .taurus: "♉"
        case .gemini: "♊"
        case .cancer: "♋"
        case .leo: "♌"
        case .virgo: "♍"
        case .libra: "♎"
        case .scorpio: "♏"
        case .sagittarius: "♐"
        case .capricorn: "♑"
        case .aquarius: "♒"
        case .pisces: "♓"
        }
    }

    var element: String {
        switch self {
        case .aries, .leo, .sagittarius: "Fire"
        case .taurus, .virgo, .capricorn: "Earth"
        case .gemini, .libra, .aquarius: "Air"
        case .cancer, .scorpio, .pisces: "Water"
        }
    }

    var modality: String {
        switch self {
        case .aries, .cancer, .libra, .capricorn: "Cardinal"
        case .taurus, .leo, .scorpio, .aquarius: "Fixed"
        case .gemini, .virgo, .sagittarius, .pisces: "Mutable"
        }
    }

    var rulingPlanet: String {
        switch self {
        case .aries: "Mars"
        case .taurus: "Venus"
        case .gemini: "Mercury"
        case .cancer: "Moon"
        case .leo: "Sun"
        case .virgo: "Mercury"
        case .libra: "Venus"
        case .scorpio: "Pluto"
        case .sagittarius: "Jupiter"
        case .capricorn: "Saturn"
        case .aquarius: "Uranus"
        case .pisces: "Neptune"
        }
    }

    /// Index 0 (Aries) through 11 (Pisces) — used for longitude math
    var index: Int {
        ZodiacSign.allCases.firstIndex(of: self) ?? 0
    }

    /// Derive sun sign from calendar date (same logic as Star Witness ZodiacSign.swift)
    static func sunSign(month: Int, day: Int) -> ZodiacSign {
        switch (month, day) {
        case (3, 21...31), (4, 1...19): .aries
        case (4, 20...30), (5, 1...20): .taurus
        case (5, 21...31), (6, 1...20): .gemini
        case (6, 21...30), (7, 1...22): .cancer
        case (7, 23...31), (8, 1...22): .leo
        case (8, 23...31), (9, 1...22): .virgo
        case (9, 23...30), (10, 1...22): .libra
        case (10, 23...31), (11, 1...21): .scorpio
        case (11, 22...30), (12, 1...21): .sagittarius
        case (12, 22...31), (1, 1...19): .capricorn
        case (1, 20...31), (2, 1...18): .aquarius
        case (2, 19...29), (3, 1...20): .pisces
        default: .aries
        }
    }

    static func from(eclipticLongitude lon: Double) -> ZodiacSign {
        let normalized = ((lon.truncatingRemainder(dividingBy: 360)) + 360).truncatingRemainder(dividingBy: 360)
        let idx = min(Int(normalized / 30.0), 11)
        return ZodiacSign.allCases[idx]
    }
}

// MARK: - Planet

enum Planet: String, CaseIterable, Codable, Content {
    case sun = "Sun"
    case moon = "Moon"
    case mercury = "Mercury"
    case venus = "Venus"
    case mars = "Mars"
    case jupiter = "Jupiter"
    case saturn = "Saturn"
    case uranus = "Uranus"
    case neptune = "Neptune"
    case pluto = "Pluto"

    var symbol: String {
        switch self {
        case .sun: "☉"
        case .moon: "☽"
        case .mercury: "☿"
        case .venus: "♀"
        case .mars: "♂"
        case .jupiter: "♃"
        case .saturn: "♄"
        case .uranus: "♅"
        case .neptune: "♆"
        case .pluto: "♇"
        }
    }

    var meaning: String {
        switch self {
        case .sun: "Core identity, ego, vitality"
        case .moon: "Emotions, instincts, inner self"
        case .mercury: "Communication, thinking, learning"
        case .venus: "Love, beauty, values, relationships"
        case .mars: "Action, energy, desire, courage"
        case .jupiter: "Growth, expansion, luck, wisdom"
        case .saturn: "Discipline, responsibility, limitations"
        case .uranus: "Innovation, rebellion, sudden change"
        case .neptune: "Dreams, intuition, spirituality"
        case .pluto: "Transformation, power, rebirth"
        }
    }

    /// Average orbital period in days (used for mock retrograde checks)
    var orbitalPeriodDays: Double {
        switch self {
        case .sun: 365.25
        case .moon: 27.32
        case .mercury: 87.97
        case .venus: 224.7
        case .mars: 686.97
        case .jupiter: 4332.59
        case .saturn: 10759.22
        case .uranus: 30688.5
        case .neptune: 60182.0
        case .pluto: 90560.0
        }
    }
}

// MARK: - PlanetaryPosition

struct PlanetaryPosition: Content {
    let planet: String
    let symbol: String
    let sign: String
    let signSymbol: String
    let element: String
    let degrees: Double
    let house: Int?
    let isRetrograde: Bool

    init(planet: Planet, sign: ZodiacSign, degrees: Double, house: Int? = nil, isRetrograde: Bool = false) {
        self.planet = planet.rawValue
        self.symbol = planet.symbol
        self.sign = sign.rawValue
        self.signSymbol = sign.symbol
        self.element = sign.element
        self.degrees = (degrees * 100).rounded() / 100
        self.house = house
        self.isRetrograde = isRetrograde
    }

    var formattedDegrees: String {
        let d = Int(degrees)
        let m = Int((degrees - Double(d)) * 60)
        return "\(d)°\(String(format: "%02d", m))'"
    }
}

// MARK: - HouseCusp

struct HouseCusp: Content {
    let house: Int
    let sign: String
    let signSymbol: String
    let degrees: Double
}

// MARK: - Aspect

enum AspectType: String, Codable, Content {
    case conjunction = "Conjunction"
    case sextile = "Sextile"
    case square = "Square"
    case trine = "Trine"
    case opposition = "Opposition"

    var angle: Double {
        switch self {
        case .conjunction: 0
        case .sextile: 60
        case .square: 90
        case .trine: 120
        case .opposition: 180
        }
    }

    var symbol: String {
        switch self {
        case .conjunction: "☌"
        case .sextile: "⚹"
        case .square: "□"
        case .trine: "△"
        case .opposition: "☍"
        }
    }

    var nature: String {
        switch self {
        case .conjunction: "Neutral"
        case .sextile: "Harmonious"
        case .square: "Challenging"
        case .trine: "Harmonious"
        case .opposition: "Challenging"
        }
    }

    var description: String {
        switch self {
        case .conjunction: "Planets merge energies, intensifying each other"
        case .sextile: "Harmonious opportunity for growth and cooperation"
        case .square: "Tension that drives action and transformation"
        case .trine: "Natural flow of energy and effortless harmony"
        case .opposition: "Awareness through polarity, seeking balance"
        }
    }
}

struct PlanetaryAspect: Content {
    let planet1: String
    let planet1Symbol: String
    let planet2: String
    let planet2Symbol: String
    let aspect: String
    let aspectSymbol: String
    let nature: String
    let orb: Double
    let description: String
    let isApplying: Bool
}

// MARK: - API Error

struct APIError: Content, Error {
    let error: Bool
    let reason: String
    let code: String

    static func missingParam(_ name: String) -> APIError {
        APIError(error: true, reason: "Missing required query parameter: \(name)", code: "MISSING_PARAM")
    }

    static func invalidParam(_ name: String, expected: String) -> APIError {
        APIError(error: true, reason: "Invalid value for '\(name)'. Expected: \(expected)", code: "INVALID_PARAM")
    }

    static func unauthorized() -> APIError {
        APIError(error: true, reason: "Missing or invalid X-API-Key header", code: "UNAUTHORIZED")
    }

    static func rateLimited(tier: String) -> APIError {
        APIError(error: true, reason: "Rate limit exceeded for \(tier) tier", code: "RATE_LIMITED")
    }
}

// MARK: - Date Parsing Helpers

extension String {
    /// Parse "YYYY-MM-DD" into year/month/day components
    func parseDate() -> (year: Int, month: Int, day: Int)? {
        let parts = self.split(separator: "-")
        guard parts.count == 3,
              let y = Int(parts[0]),
              let m = Int(parts[1]),
              let d = Int(parts[2]) else { return nil }
        return (y, m, d)
    }

    /// Parse "HH:MM" into hour/minute
    func parseTime() -> (hour: Int, minute: Int)? {
        let parts = self.split(separator: ":")
        guard parts.count >= 2,
              let h = Int(parts[0]),
              let m = Int(parts[1]) else { return nil }
        return (h, m)
    }
}
