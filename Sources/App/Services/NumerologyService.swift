import Foundation

enum NumerologyService {

    // MARK: - Pythagorean Letter Values

    private static let letterValues: [Character: Int] = [
        "A": 1, "B": 2, "C": 3, "D": 4, "E": 5, "F": 6, "G": 7, "H": 8, "I": 9,
        "J": 1, "K": 2, "L": 3, "M": 4, "N": 5, "O": 6, "P": 7, "Q": 8, "R": 9,
        "S": 1, "T": 2, "U": 3, "V": 4, "W": 5, "X": 6, "Y": 7, "Z": 8
    ]

    private static let vowels: Set<Character> = ["A", "E", "I", "O", "U"]

    // MARK: - Core Reduction

    static func reduce(_ n: Int, allowMaster: Bool = true) -> Int {
        var num = n
        while num > 9 {
            if allowMaster && (num == 11 || num == 22 || num == 33) {
                return num
            }
            num = num.digits.reduce(0, +)
        }
        return num
    }

    // MARK: - Life Path Number

    /// Reduces month, day, and year components separately before summing.
    static func lifePath(birthdate: String) -> Int? {
        guard let (year, month, day) = birthdate.parseDate() else { return nil }
        let m = reduce(month)
        let d = reduce(day)
        let y = reduce(year.digits.reduce(0, +))
        return reduce(m + d + y)
    }

    // MARK: - Expression Number (full name)

    static func expression(name: String) -> Int {
        let sum = name.uppercased().filter { $0.isLetter }.compactMap { letterValues[$0] }.reduce(0, +)
        return reduce(sum)
    }

    // MARK: - Soul Urge Number (vowels only)

    static func soulUrge(name: String) -> Int {
        let sum = name.uppercased().filter { vowels.contains($0) }.compactMap { letterValues[$0] }.reduce(0, +)
        return reduce(sum)
    }

    // MARK: - Personality Number (consonants only)

    static func personality(name: String) -> Int {
        let sum = name.uppercased().filter { $0.isLetter && !vowels.contains($0) }.compactMap { letterValues[$0] }.reduce(0, +)
        return reduce(sum)
    }

    // MARK: - Number Interpretations

    static func interpretation(for number: Int, type: String) -> NumerologyResult {
        let data = numberData[number] ?? numberData[9]!
        return NumerologyResult(
            type: type,
            number: number,
            name: data.name,
            meaning: data.meaning,
            traits: data.traits,
            strengths: data.strengths,
            challenges: data.challenges,
            lifeTheme: data.lifeTheme
        )
    }

    // MARK: - Number Data

    private struct NumberInfo {
        let name: String
        let meaning: String
        let traits: [String]
        let strengths: [String]
        let challenges: [String]
        let lifeTheme: String
    }

    private static let numberData: [Int: NumberInfo] = [
        1: NumberInfo(
            name: "The Leader",
            meaning: "The number of new beginnings, independence, and leadership. You are here to forge your own path and lead others by example.",
            traits: ["Independent", "Pioneering", "Ambitious", "Self-reliant", "Innovative"],
            strengths: ["Natural leadership ability", "Strong willpower", "Original thinking", "Courage and determination"],
            challenges: ["Stubbornness and inflexibility", "Difficulty working in teams", "Tendency toward selfishness", "Impatience with others"],
            lifeTheme: "Independence and leadership"
        ),
        2: NumberInfo(
            name: "The Peacemaker",
            meaning: "The number of balance, harmony, and cooperation. You are here to bring people together and create peace through diplomacy.",
            traits: ["Diplomatic", "Sensitive", "Cooperative", "Patient", "Intuitive"],
            strengths: ["Exceptional listening skills", "Natural mediator", "Deep empathy", "Attention to detail"],
            challenges: ["Over-sensitivity and hurt feelings", "Indecisiveness", "Difficulty with confrontation", "Self-doubt"],
            lifeTheme: "Harmony and partnership"
        ),
        3: NumberInfo(
            name: "The Communicator",
            meaning: "The number of creativity, self-expression, and joy. You are here to inspire others through your creative gifts and optimistic spirit.",
            traits: ["Creative", "Expressive", "Social", "Optimistic", "Artistic"],
            strengths: ["Strong communication skills", "Creative talent", "Charisma and charm", "Ability to inspire others"],
            challenges: ["Scattered energy and lack of focus", "Tendency to be superficial", "Emotional sensitivity", "Procrastination"],
            lifeTheme: "Creative self-expression"
        ),
        4: NumberInfo(
            name: "The Builder",
            meaning: "The number of stability, discipline, and hard work. You are here to build lasting foundations and create order through perseverance.",
            traits: ["Disciplined", "Hardworking", "Practical", "Reliable", "Systematic"],
            strengths: ["Excellent organizational skills", "Strong work ethic", "Reliability and dependability", "Ability to manifest goals"],
            challenges: ["Rigidity and resistance to change", "Tendency toward drudgery", "Stubbornness", "Difficulty with spontaneity"],
            lifeTheme: "Structure and foundations"
        ),
        5: NumberInfo(
            name: "The Explorer",
            meaning: "The number of freedom, adventure, and change. You are here to experience life fully and inspire others with your love of freedom.",
            traits: ["Adventurous", "Versatile", "Freedom-loving", "Curious", "Progressive"],
            strengths: ["Adaptability and flexibility", "Quick thinking", "Enthusiasm for life", "Ability to inspire change"],
            challenges: ["Restlessness and inconsistency", "Difficulty with commitment", "Tendency toward excess", "Lack of follow-through"],
            lifeTheme: "Freedom and transformation"
        ),
        6: NumberInfo(
            name: "The Nurturer",
            meaning: "The number of love, responsibility, and service. You are here to nurture and care for others and to create harmony in relationships.",
            traits: ["Nurturing", "Responsible", "Loving", "Protective", "Compassionate"],
            strengths: ["Natural caregiver and healer", "Strong sense of duty", "Ability to create harmony", "Deep love for family and community"],
            challenges: ["Tendency to be self-sacrificing", "Perfectionism and judgment", "Difficulty accepting help", "Meddling in others' affairs"],
            lifeTheme: "Love and responsibility"
        ),
        7: NumberInfo(
            name: "The Seeker",
            meaning: "The number of spirituality, wisdom, and introspection. You are here to seek truth, develop wisdom, and understand life's deeper mysteries.",
            traits: ["Introspective", "Analytical", "Spiritual", "Mysterious", "Intellectual"],
            strengths: ["Deep analytical mind", "Strong intuition", "Ability to see beneath the surface", "Philosophical wisdom"],
            challenges: ["Tendency to isolate", "Difficulty with emotional intimacy", "Perfectionism and criticism", "Skepticism and distrust"],
            lifeTheme: "Wisdom and spiritual growth"
        ),
        8: NumberInfo(
            name: "The Achiever",
            meaning: "The number of abundance, power, and achievement. You are here to learn to use power wisely and to manifest material and spiritual success.",
            traits: ["Ambitious", "Powerful", "Successful", "Authoritative", "Materialistic"],
            strengths: ["Strong business acumen", "Executive ability", "Determination to succeed", "Ability to attract abundance"],
            challenges: ["Materialism and greed", "Authoritarian tendencies", "Workaholism", "Difficulty with vulnerability"],
            lifeTheme: "Power and abundance"
        ),
        9: NumberInfo(
            name: "The Humanitarian",
            meaning: "The number of compassion, completion, and universal love. You are here to serve humanity and to bring your wisdom to the world.",
            traits: ["Compassionate", "Generous", "Artistic", "Idealistic", "Spiritual"],
            strengths: ["Deep compassion for all beings", "Creative and artistic talent", "Broad-minded perspective", "Selfless service to others"],
            challenges: ["Difficulty letting go and completing cycles", "Emotional sensitivity", "Self-sacrifice to a fault", "Idealism vs reality"],
            lifeTheme: "Compassion and completion"
        ),
        11: NumberInfo(
            name: "The Illuminator",
            meaning: "Master Number 11: The number of spiritual illumination and intuition. You are here to inspire, illuminate, and uplift humanity through your heightened sensitivity.",
            traits: ["Highly intuitive", "Inspirational", "Idealistic", "Spiritually aware", "Sensitive"],
            strengths: ["Powerful intuition and psychic awareness", "Ability to inspire and uplift", "Creative vision", "Spiritual insight"],
            challenges: ["Hypersensitivity and anxiety", "Self-doubt and fear", "Difficulty grounding ideals", "Feeling overwhelmed by sensory input"],
            lifeTheme: "Spiritual illumination and inspiration"
        ),
        22: NumberInfo(
            name: "The Master Builder",
            meaning: "Master Number 22: The most powerful of all numbers, combining the intuition of 11 with the practicality of 4 to build lasting legacies.",
            traits: ["Visionary", "Disciplined", "Practical idealist", "Powerful", "Builder"],
            strengths: ["Ability to manifest grand visions", "Combines spiritual insight with practical action", "Extraordinary organizational ability", "Leadership at scale"],
            challenges: ["Enormous pressure and responsibility", "Tendency toward perfectionism", "Difficulty delegating", "Fear of failing to meet potential"],
            lifeTheme: "Manifesting visions into reality"
        ),
        33: NumberInfo(
            name: "The Master Teacher",
            meaning: "Master Number 33: The most spiritual and compassionate of the master numbers. You are here to uplift humanity through unconditional love and spiritual teaching.",
            traits: ["Selflessly loving", "Nurturing", "Spiritual teacher", "Compassionate", "Courageous"],
            strengths: ["Extraordinary compassion and love", "Ability to heal and transform others", "Deep spiritual wisdom", "Courage of convictions"],
            challenges: ["Martyrdom and self-sacrifice", "Overwhelming responsibility", "Difficulty with personal needs", "The burden of the teacher"],
            lifeTheme: "Unconditional love and spiritual mastery"
        )
    ]
}

// MARK: - Int extension

private extension Int {
    var digits: [Int] {
        String(self).compactMap { $0.wholeNumberValue }
    }
}
