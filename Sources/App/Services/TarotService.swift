import Foundation

enum TarotService {

    // MARK: - All 78 Cards

    static let allCards: [TarotCard] = majorArcana + wandsCards + cupsCards + swordsCards + pentaclesCards

    // MARK: - Major Arcana (22 cards)

    static let majorArcana: [TarotCard] = [
        TarotCard(
            name: "The Fool", arcana: "major", suit: nil, number: 0,
            uprightMeaning: "New beginnings, innocence, spontaneity, and a free spirit. A leap of faith into the unknown.",
            reversedMeaning: "Recklessness, risk-taking without consideration, naivety, and poor judgment.",
            keywords: ["beginnings", "innocence", "adventure", "spontaneity", "freedom"],
            element: "Air", zodiacAssociation: "Uranus", yesNo: "yes"
        ),
        TarotCard(
            name: "The Magician", arcana: "major", suit: nil, number: 1,
            uprightMeaning: "Manifestation, resourcefulness, power, and inspired action. You have the tools you need.",
            reversedMeaning: "Manipulation, poor planning, untapped talents, and illusion.",
            keywords: ["manifestation", "willpower", "skill", "concentration", "action"],
            element: "Air", zodiacAssociation: "Mercury", yesNo: "yes"
        ),
        TarotCard(
            name: "The High Priestess", arcana: "major", suit: nil, number: 2,
            uprightMeaning: "Intuition, sacred knowledge, divine feminine, and the subconscious mind.",
            reversedMeaning: "Secrets, disconnection from intuition, withdrawal, and silence.",
            keywords: ["intuition", "mystery", "subconscious", "inner knowing", "wisdom"],
            element: "Water", zodiacAssociation: "Moon", yesNo: "neutral"
        ),
        TarotCard(
            name: "The Empress", arcana: "major", suit: nil, number: 3,
            uprightMeaning: "Femininity, beauty, nature, abundance, and fertility. Creation and nurturing.",
            reversedMeaning: "Creative block, dependence on others, emptiness, and neglect.",
            keywords: ["abundance", "fertility", "nurturing", "beauty", "nature"],
            element: "Earth", zodiacAssociation: "Venus", yesNo: "yes"
        ),
        TarotCard(
            name: "The Emperor", arcana: "major", suit: nil, number: 4,
            uprightMeaning: "Authority, establishment, structure, and a father figure. Stability and control.",
            reversedMeaning: "Domination, excessive control, rigidity, and inflexibility.",
            keywords: ["authority", "structure", "stability", "power", "leadership"],
            element: "Fire", zodiacAssociation: "Aries", yesNo: "yes"
        ),
        TarotCard(
            name: "The Hierophant", arcana: "major", suit: nil, number: 5,
            uprightMeaning: "Spiritual wisdom, religious beliefs, conformity, tradition, and institutions.",
            reversedMeaning: "Personal beliefs, freedom, challenging the status quo, and unconventionality.",
            keywords: ["tradition", "conformity", "guidance", "belief", "institution"],
            element: "Earth", zodiacAssociation: "Taurus", yesNo: "neutral"
        ),
        TarotCard(
            name: "The Lovers", arcana: "major", suit: nil, number: 6,
            uprightMeaning: "Love, harmony, relationships, values alignment, and choices in love.",
            reversedMeaning: "Self-love issues, disharmony, imbalance, and misaligned values.",
            keywords: ["love", "harmony", "relationships", "choices", "alignment"],
            element: "Air", zodiacAssociation: "Gemini", yesNo: "yes"
        ),
        TarotCard(
            name: "The Chariot", arcana: "major", suit: nil, number: 7,
            uprightMeaning: "Control, willpower, success, action, and determination. Victory through effort.",
            reversedMeaning: "Self-discipline lacking, opposition, lack of direction, and aggression.",
            keywords: ["victory", "determination", "control", "willpower", "success"],
            element: "Water", zodiacAssociation: "Cancer", yesNo: "yes"
        ),
        TarotCard(
            name: "Strength", arcana: "major", suit: nil, number: 8,
            uprightMeaning: "Strength, courage, persuasion, influence, and compassion. Inner fortitude.",
            reversedMeaning: "Inner strength depleted, self-doubt, low energy, and raw emotion.",
            keywords: ["courage", "patience", "inner strength", "compassion", "influence"],
            element: "Fire", zodiacAssociation: "Leo", yesNo: "yes"
        ),
        TarotCard(
            name: "The Hermit", arcana: "major", suit: nil, number: 9,
            uprightMeaning: "Soul-searching, introspection, being alone, inner guidance, and contemplation.",
            reversedMeaning: "Isolation, loneliness, withdrawal, and rejection of guidance.",
            keywords: ["introspection", "solitude", "guidance", "wisdom", "contemplation"],
            element: "Earth", zodiacAssociation: "Virgo", yesNo: "neutral"
        ),
        TarotCard(
            name: "Wheel of Fortune", arcana: "major", suit: nil, number: 10,
            uprightMeaning: "Good luck, karma, life cycles, destiny, and a turning point. Change is coming.",
            reversedMeaning: "Bad luck, resistance to change, breaking cycles, and misfortune.",
            keywords: ["luck", "karma", "cycles", "destiny", "change"],
            element: "Fire", zodiacAssociation: "Jupiter", yesNo: "yes"
        ),
        TarotCard(
            name: "Justice", arcana: "major", suit: nil, number: 11,
            uprightMeaning: "Justice, fairness, truth, cause and effect, and law. Balanced outcomes.",
            reversedMeaning: "Unfairness, lack of accountability, dishonesty, and injustice.",
            keywords: ["justice", "fairness", "truth", "law", "cause and effect"],
            element: "Air", zodiacAssociation: "Libra", yesNo: "neutral"
        ),
        TarotCard(
            name: "The Hanged Man", arcana: "major", suit: nil, number: 12,
            uprightMeaning: "Pause, surrender, letting go, new perspectives, and martyrdom.",
            reversedMeaning: "Delays, resistance, stalling, and indecision.",
            keywords: ["surrender", "pause", "sacrifice", "perspective", "letting go"],
            element: "Water", zodiacAssociation: "Neptune", yesNo: "neutral"
        ),
        TarotCard(
            name: "Death", arcana: "major", suit: nil, number: 13,
            uprightMeaning: "Endings, change, transformation, transition, and letting go of the past.",
            reversedMeaning: "Resistance to change, personal transformation delayed, and inability to move on.",
            keywords: ["transformation", "endings", "transition", "change", "release"],
            element: "Water", zodiacAssociation: "Scorpio", yesNo: "neutral"
        ),
        TarotCard(
            name: "Temperance", arcana: "major", suit: nil, number: 14,
            uprightMeaning: "Balance, moderation, patience, purpose, and meaning. A middle way.",
            reversedMeaning: "Imbalance, excess, lack of long-term vision, and re-alignment needed.",
            keywords: ["balance", "moderation", "patience", "purpose", "harmony"],
            element: "Fire", zodiacAssociation: "Sagittarius", yesNo: "yes"
        ),
        TarotCard(
            name: "The Devil", arcana: "major", suit: nil, number: 15,
            uprightMeaning: "Shadow self, attachment, addiction, restriction, and sexuality.",
            reversedMeaning: "Releasing limiting beliefs, exploring dark thoughts, and detachment.",
            keywords: ["bondage", "addiction", "shadow", "materialism", "restriction"],
            element: "Earth", zodiacAssociation: "Capricorn", yesNo: "no"
        ),
        TarotCard(
            name: "The Tower", arcana: "major", suit: nil, number: 16,
            uprightMeaning: "Sudden change, upheaval, chaos, revelation, and awakening. Structures crumbling.",
            reversedMeaning: "Personal transformation, fear of change, and averting disaster.",
            keywords: ["upheaval", "chaos", "revelation", "awakening", "destruction"],
            element: "Fire", zodiacAssociation: "Mars", yesNo: "no"
        ),
        TarotCard(
            name: "The Star", arcana: "major", suit: nil, number: 17,
            uprightMeaning: "Hope, faith, purpose, renewal, and spirituality. Serenity after the storm.",
            reversedMeaning: "Lack of faith, despair, self-trust issues, and disconnection.",
            keywords: ["hope", "inspiration", "serenity", "renewal", "faith"],
            element: "Air", zodiacAssociation: "Aquarius", yesNo: "yes"
        ),
        TarotCard(
            name: "The Moon", arcana: "major", suit: nil, number: 18,
            uprightMeaning: "Illusion, fear, the subconscious, and confusion. Things are not what they seem.",
            reversedMeaning: "Release of fear, repressed emotions, inner confusion cleared.",
            keywords: ["illusion", "fear", "subconscious", "confusion", "mystery"],
            element: "Water", zodiacAssociation: "Pisces", yesNo: "neutral"
        ),
        TarotCard(
            name: "The Sun", arcana: "major", suit: nil, number: 19,
            uprightMeaning: "Positivity, fun, warmth, success, and vitality. Joy and abundance.",
            reversedMeaning: "Inner child blocked, excessive positivity, overly optimistic.",
            keywords: ["joy", "success", "positivity", "vitality", "clarity"],
            element: "Fire", zodiacAssociation: "Sun", yesNo: "yes"
        ),
        TarotCard(
            name: "Judgement", arcana: "major", suit: nil, number: 20,
            uprightMeaning: "Judgement, rebirth, inner calling, and absolution. A moment of reckoning.",
            reversedMeaning: "Self-doubt, inner critic, and failure to learn from the past.",
            keywords: ["awakening", "renewal", "reckoning", "absolution", "calling"],
            element: "Fire", zodiacAssociation: "Pluto", yesNo: "yes"
        ),
        TarotCard(
            name: "The World", arcana: "major", suit: nil, number: 21,
            uprightMeaning: "Completion, integration, accomplishment, travel, and the end of a cycle.",
            reversedMeaning: "Seeking personal closure, short-cuts, and delayed success.",
            keywords: ["completion", "wholeness", "integration", "accomplishment", "cycles"],
            element: "Earth", zodiacAssociation: "Saturn", yesNo: "yes"
        )
    ]

    // MARK: - Minor Arcana: Wands (Fire)

    static let wandsCards: [TarotCard] = [
        TarotCard(
            name: "Ace of Wands", arcana: "minor", suit: "Wands", number: 1,
            uprightMeaning: "Creation, willpower, inspiration, and new energy. A spark of potential.",
            reversedMeaning: "Delays, creative blocks, lack of passion, and wasted potential.",
            keywords: ["inspiration", "new beginnings", "creativity", "spark", "potential"],
            element: "Fire", zodiacAssociation: "Aries, Leo, Sagittarius", yesNo: "yes"
        ),
        TarotCard(
            name: "Two of Wands", arcana: "minor", suit: "Wands", number: 2,
            uprightMeaning: "Future planning, progress, decisions, and discovery. Standing at a crossroads.",
            reversedMeaning: "Fear of the unknown, lack of planning, and playing it too safe.",
            keywords: ["planning", "future", "progress", "decisions", "discovery"],
            element: "Fire", zodiacAssociation: "Aries", yesNo: "yes"
        ),
        TarotCard(
            name: "Three of Wands", arcana: "minor", suit: "Wands", number: 3,
            uprightMeaning: "Expansion, foresight, overseas, and leadership. Plans are coming to fruition.",
            reversedMeaning: "Playing small, lack of foresight, and unexpected delays.",
            keywords: ["expansion", "foresight", "leadership", "progress", "vision"],
            element: "Fire", zodiacAssociation: "Aries", yesNo: "yes"
        ),
        TarotCard(
            name: "Four of Wands", arcana: "minor", suit: "Wands", number: 4,
            uprightMeaning: "Celebration, joy, harmony, relaxation, and homecoming. A milestone reached.",
            reversedMeaning: "Lack of support, transience, and home conflicts.",
            keywords: ["celebration", "harmony", "stability", "home", "joy"],
            element: "Fire", zodiacAssociation: "Aries", yesNo: "yes"
        ),
        TarotCard(
            name: "Five of Wands", arcana: "minor", suit: "Wands", number: 5,
            uprightMeaning: "Conflict, disagreements, competition, tension, and diversity of opinions.",
            reversedMeaning: "Avoiding conflict, respecting differences, and inner conflict resolved.",
            keywords: ["conflict", "competition", "struggle", "tension", "disagreement"],
            element: "Fire", zodiacAssociation: "Leo", yesNo: "no"
        ),
        TarotCard(
            name: "Six of Wands", arcana: "minor", suit: "Wands", number: 6,
            uprightMeaning: "Success, public recognition, progress, and self-confidence. Victory parade.",
            reversedMeaning: "Private achievement, fall from grace, and egotism.",
            keywords: ["victory", "recognition", "success", "confidence", "triumph"],
            element: "Fire", zodiacAssociation: "Leo", yesNo: "yes"
        ),
        TarotCard(
            name: "Seven of Wands", arcana: "minor", suit: "Wands", number: 7,
            uprightMeaning: "Challenge, competition, protection, and perseverance. Standing your ground.",
            reversedMeaning: "Giving up, overwhelmed, and overly protective.",
            keywords: ["perseverance", "defense", "challenge", "competition", "resilience"],
            element: "Fire", zodiacAssociation: "Leo", yesNo: "yes"
        ),
        TarotCard(
            name: "Eight of Wands", arcana: "minor", suit: "Wands", number: 8,
            uprightMeaning: "Speed, action, air travel, movement, and swift change. Things are moving fast.",
            reversedMeaning: "Delays, frustration, resisting change, and internal alignment needed.",
            keywords: ["speed", "action", "movement", "swift change", "progress"],
            element: "Fire", zodiacAssociation: "Sagittarius", yesNo: "yes"
        ),
        TarotCard(
            name: "Nine of Wands", arcana: "minor", suit: "Wands", number: 9,
            uprightMeaning: "Resilience, courage, persistence, test of faith, and boundaries.",
            reversedMeaning: "Exhaustion, giving up, and questioning integrity.",
            keywords: ["resilience", "persistence", "courage", "stamina", "boundaries"],
            element: "Fire", zodiacAssociation: "Sagittarius", yesNo: "neutral"
        ),
        TarotCard(
            name: "Ten of Wands", arcana: "minor", suit: "Wands", number: 10,
            uprightMeaning: "Burden, extra responsibility, hard work, and completion. Almost there.",
            reversedMeaning: "Doing it all, carrying the load alone, and delegation needed.",
            keywords: ["burden", "responsibility", "hard work", "completion", "overwhelm"],
            element: "Fire", zodiacAssociation: "Sagittarius", yesNo: "no"
        ),
        TarotCard(
            name: "Page of Wands", arcana: "minor", suit: "Wands", number: 11,
            uprightMeaning: "Inspiration, ideas, discovery, free spirit, and limitless potential.",
            reversedMeaning: "Newly formed ideas, redirecting energy, and self-limiting beliefs.",
            keywords: ["inspiration", "adventure", "free spirit", "enthusiasm", "discovery"],
            element: "Fire", zodiacAssociation: "Fire signs", yesNo: "yes"
        ),
        TarotCard(
            name: "Knight of Wands", arcana: "minor", suit: "Wands", number: 12,
            uprightMeaning: "Energy, passion, inspired action, adventure, and impulsiveness.",
            reversedMeaning: "Passion lacking, haste, and scattered energy.",
            keywords: ["energy", "passion", "action", "adventure", "impulsiveness"],
            element: "Fire", zodiacAssociation: "Sagittarius", yesNo: "yes"
        ),
        TarotCard(
            name: "Queen of Wands", arcana: "minor", suit: "Wands", number: 13,
            uprightMeaning: "Courage, confidence, independence, social butterfly, and determination.",
            reversedMeaning: "Self-respect, self-confidence, introverted, and re-establishing.",
            keywords: ["courage", "confidence", "independence", "vivacity", "determination"],
            element: "Fire", zodiacAssociation: "Aries", yesNo: "yes"
        ),
        TarotCard(
            name: "King of Wands", arcana: "minor", suit: "Wands", number: 14,
            uprightMeaning: "Natural-born leader, vision, entrepreneur, and honor. Bold and daring.",
            reversedMeaning: "Impulsiveness, haste, ruthless, and high expectations.",
            keywords: ["leadership", "vision", "mastery", "entrepreneur", "honor"],
            element: "Fire", zodiacAssociation: "Leo", yesNo: "yes"
        )
    ]

    // MARK: - Minor Arcana: Cups (Water)

    static let cupsCards: [TarotCard] = [
        TarotCard(
            name: "Ace of Cups", arcana: "minor", suit: "Cups", number: 1,
            uprightMeaning: "New feelings, spirituality, intuition, and overwhelming emotion. Love overflows.",
            reversedMeaning: "Emotional loss, blocked creativity, and emptiness.",
            keywords: ["new love", "emotional beginnings", "intuition", "spirituality", "overflow"],
            element: "Water", zodiacAssociation: "Cancer, Scorpio, Pisces", yesNo: "yes"
        ),
        TarotCard(
            name: "Two of Cups", arcana: "minor", suit: "Cups", number: 2,
            uprightMeaning: "Unified love, partnership, mutual attraction, and connection. A meeting of souls.",
            reversedMeaning: "Self-love, break-ups, disharmony, and distrust.",
            keywords: ["partnership", "union", "connection", "attraction", "love"],
            element: "Water", zodiacAssociation: "Cancer", yesNo: "yes"
        ),
        TarotCard(
            name: "Three of Cups", arcana: "minor", suit: "Cups", number: 3,
            uprightMeaning: "Celebration, friendship, creativity, and collaborations. Community and joy.",
            reversedMeaning: "Independence, alone time, and overindulgence in celebration.",
            keywords: ["celebration", "friendship", "joy", "community", "abundance"],
            element: "Water", zodiacAssociation: "Cancer", yesNo: "yes"
        ),
        TarotCard(
            name: "Four of Cups", arcana: "minor", suit: "Cups", number: 4,
            uprightMeaning: "Meditation, contemplation, apathy, and reevaluation. Withdrawing inward.",
            reversedMeaning: "Retreat, withdrawal, checking in for alignment, and new possibilities seen.",
            keywords: ["contemplation", "apathy", "reevaluation", "withdrawal", "introspection"],
            element: "Water", zodiacAssociation: "Cancer", yesNo: "neutral"
        ),
        TarotCard(
            name: "Five of Cups", arcana: "minor", suit: "Cups", number: 5,
            uprightMeaning: "Regret, failure, disappointment, and pessimism. Focusing on loss.",
            reversedMeaning: "Acceptance, moving on, finding peace, and forgiveness.",
            keywords: ["loss", "grief", "regret", "disappointment", "mourning"],
            element: "Water", zodiacAssociation: "Scorpio", yesNo: "no"
        ),
        TarotCard(
            name: "Six of Cups", arcana: "minor", suit: "Cups", number: 6,
            uprightMeaning: "Revisiting the past, childhood memories, innocence, and joy. Nostalgia.",
            reversedMeaning: "Living in the past, forgiveness, and moving forward.",
            keywords: ["nostalgia", "childhood", "innocence", "joy", "memories"],
            element: "Water", zodiacAssociation: "Scorpio", yesNo: "yes"
        ),
        TarotCard(
            name: "Seven of Cups", arcana: "minor", suit: "Cups", number: 7,
            uprightMeaning: "Opportunities, choices, wishful thinking, and illusion. Fantasy vs reality.",
            reversedMeaning: "Alignment, projection, clarity, and personal values.",
            keywords: ["fantasy", "choices", "illusion", "wishful thinking", "dreams"],
            element: "Water", zodiacAssociation: "Scorpio", yesNo: "neutral"
        ),
        TarotCard(
            name: "Eight of Cups", arcana: "minor", suit: "Cups", number: 8,
            uprightMeaning: "Disappointment, abandonment, withdrawal, and escapism. Leaving behind.",
            reversedMeaning: "Trying one more time, indecision, and aimless drifting.",
            keywords: ["withdrawal", "abandonment", "moving on", "disappointment", "escape"],
            element: "Water", zodiacAssociation: "Pisces", yesNo: "neutral"
        ),
        TarotCard(
            name: "Nine of Cups", arcana: "minor", suit: "Cups", number: 9,
            uprightMeaning: "Contentment, satisfaction, gratitude, and wish fulfillment. The wish card.",
            reversedMeaning: "Inner happiness, materialism, and dissatisfaction.",
            keywords: ["contentment", "satisfaction", "luxury", "wishes", "gratitude"],
            element: "Water", zodiacAssociation: "Pisces", yesNo: "yes"
        ),
        TarotCard(
            name: "Ten of Cups", arcana: "minor", suit: "Cups", number: 10,
            uprightMeaning: "Divine love, blissful relationships, harmony, and alignment. Family joy.",
            reversedMeaning: "Disconnection, misaligned values, and struggling relationships.",
            keywords: ["harmony", "happiness", "fulfillment", "family", "bliss"],
            element: "Water", zodiacAssociation: "Pisces", yesNo: "yes"
        ),
        TarotCard(
            name: "Page of Cups", arcana: "minor", suit: "Cups", number: 11,
            uprightMeaning: "Creative opportunities, intuitive messages, curiosity, and possibility.",
            reversedMeaning: "New ideas, doubting intuition, and creative blocks.",
            keywords: ["creativity", "intuition", "sensitivity", "possibility", "messages"],
            element: "Water", zodiacAssociation: "Water signs", yesNo: "yes"
        ),
        TarotCard(
            name: "Knight of Cups", arcana: "minor", suit: "Cups", number: 12,
            uprightMeaning: "Creativity, romance, charm, imagination, and beauty. The romantic.",
            reversedMeaning: "Overactive imagination, unrealistic, jealousy, and moodiness.",
            keywords: ["romance", "idealism", "imagination", "charm", "creativity"],
            element: "Water", zodiacAssociation: "Cancer", yesNo: "yes"
        ),
        TarotCard(
            name: "Queen of Cups", arcana: "minor", suit: "Cups", number: 13,
            uprightMeaning: "Compassionate, caring, emotionally stable, intuitive, and in flow.",
            reversedMeaning: "Inner feelings, self-care, and co-dependency.",
            keywords: ["compassion", "intuition", "emotional security", "care", "empathy"],
            element: "Water", zodiacAssociation: "Scorpio", yesNo: "yes"
        ),
        TarotCard(
            name: "King of Cups", arcana: "minor", suit: "Cups", number: 14,
            uprightMeaning: "Emotionally balanced, compassionate, diplomatic, and a devout man.",
            reversedMeaning: "Self-compassion, inner feelings, moodiness, and emotionally manipulative.",
            keywords: ["emotional balance", "wisdom", "diplomacy", "compassion", "mastery"],
            element: "Water", zodiacAssociation: "Pisces", yesNo: "yes"
        )
    ]

    // MARK: - Minor Arcana: Swords (Air)

    static let swordsCards: [TarotCard] = [
        TarotCard(
            name: "Ace of Swords", arcana: "minor", suit: "Swords", number: 1,
            uprightMeaning: "Breakthroughs, new ideas, mental clarity, and success. Truth cuts through.",
            reversedMeaning: "Inner clarity, re-thinking an idea, and clouded judgment.",
            keywords: ["clarity", "truth", "breakthrough", "mental power", "new ideas"],
            element: "Air", zodiacAssociation: "Libra, Aquarius, Gemini", yesNo: "yes"
        ),
        TarotCard(
            name: "Two of Swords", arcana: "minor", suit: "Swords", number: 2,
            uprightMeaning: "Difficult decisions, weighing up options, an impasse, and avoidance.",
            reversedMeaning: "Indecision, confusion, information overload, and stalemate.",
            keywords: ["indecision", "stalemate", "choices", "blocked emotions", "avoidance"],
            element: "Air", zodiacAssociation: "Libra", yesNo: "neutral"
        ),
        TarotCard(
            name: "Three of Swords", arcana: "minor", suit: "Swords", number: 3,
            uprightMeaning: "Heartbreak, emotional pain, sorrow, grief, and hurt. A painful truth.",
            reversedMeaning: "Negative self-talk, releasing pain, and optimism returning.",
            keywords: ["heartbreak", "grief", "sorrow", "pain", "loss"],
            element: "Air", zodiacAssociation: "Libra", yesNo: "no"
        ),
        TarotCard(
            name: "Four of Swords", arcana: "minor", suit: "Swords", number: 4,
            uprightMeaning: "Rest, relaxation, meditation, contemplation, and recuperation. Pause.",
            reversedMeaning: "Exhaustion, burn-out, deep contemplation, and re-entering the world.",
            keywords: ["rest", "recovery", "contemplation", "retreat", "peace"],
            element: "Air", zodiacAssociation: "Aquarius", yesNo: "neutral"
        ),
        TarotCard(
            name: "Five of Swords", arcana: "minor", suit: "Swords", number: 5,
            uprightMeaning: "Conflict, disagreements, competition, defeat, and winning at all costs.",
            reversedMeaning: "Reconciliation, making amends, and past wounds reopened.",
            keywords: ["conflict", "defeat", "competition", "hollow victory", "tension"],
            element: "Air", zodiacAssociation: "Aquarius", yesNo: "no"
        ),
        TarotCard(
            name: "Six of Swords", arcana: "minor", suit: "Swords", number: 6,
            uprightMeaning: "Transition, change, rite of passage, releasing baggage, and moving on.",
            reversedMeaning: "Personal transition, resistance to change, and unfinished business.",
            keywords: ["transition", "moving on", "journey", "release", "progress"],
            element: "Air", zodiacAssociation: "Aquarius", yesNo: "yes"
        ),
        TarotCard(
            name: "Seven of Swords", arcana: "minor", suit: "Swords", number: 7,
            uprightMeaning: "Betrayal, deception, getting away with something, acting strategically.",
            reversedMeaning: "Imposter syndrome, self-deceit, and keeping secrets.",
            keywords: ["deception", "strategy", "cunning", "betrayal", "stealth"],
            element: "Air", zodiacAssociation: "Gemini", yesNo: "neutral"
        ),
        TarotCard(
            name: "Eight of Swords", arcana: "minor", suit: "Swords", number: 8,
            uprightMeaning: "Imprisonment, entrapment, self-victimization, and powerlessness.",
            reversedMeaning: "Self-limiting beliefs, inner critic, and releasing negative thoughts.",
            keywords: ["restriction", "isolation", "imprisonment", "powerlessness", "trapped"],
            element: "Air", zodiacAssociation: "Gemini", yesNo: "no"
        ),
        TarotCard(
            name: "Nine of Swords", arcana: "minor", suit: "Swords", number: 9,
            uprightMeaning: "Anxiety, worry, fear, depression, and nightmares. The dark night of the soul.",
            reversedMeaning: "Inner turmoil, deep-seated fears, and secrets coming to light.",
            keywords: ["anxiety", "worry", "nightmares", "fear", "despair"],
            element: "Air", zodiacAssociation: "Gemini", yesNo: "no"
        ),
        TarotCard(
            name: "Ten of Swords", arcana: "minor", suit: "Swords", number: 10,
            uprightMeaning: "Painful endings, deep wounds, betrayal, loss, and crisis. Rock bottom.",
            reversedMeaning: "Recovery, regeneration, resisting an inevitable end.",
            keywords: ["painful endings", "betrayal", "rock bottom", "loss", "crisis"],
            element: "Air", zodiacAssociation: "Gemini", yesNo: "no"
        ),
        TarotCard(
            name: "Page of Swords", arcana: "minor", suit: "Swords", number: 11,
            uprightMeaning: "New ideas, curiosity, thirst for knowledge, and new ways of communicating.",
            reversedMeaning: "Self-expression, all talk and no action, and haste.",
            keywords: ["curiosity", "wit", "communication", "ideas", "intelligence"],
            element: "Air", zodiacAssociation: "Air signs", yesNo: "neutral"
        ),
        TarotCard(
            name: "Knight of Swords", arcana: "minor", suit: "Swords", number: 12,
            uprightMeaning: "Ambitious, action-oriented, driven, and focused. Charge ahead.",
            reversedMeaning: "Restless, unfocused, impulsive, and burn-out.",
            keywords: ["assertive", "direct", "ambitious", "focused", "action"],
            element: "Air", zodiacAssociation: "Aquarius", yesNo: "neutral"
        ),
        TarotCard(
            name: "Queen of Swords", arcana: "minor", suit: "Swords", number: 13,
            uprightMeaning: "Independent, unbiased judgement, clear boundaries, and direct communication.",
            reversedMeaning: "Overly-emotional, bitchy, cold-hearted, and cruel.",
            keywords: ["independence", "clarity", "perceptive", "honest", "boundaries"],
            element: "Air", zodiacAssociation: "Libra", yesNo: "neutral"
        ),
        TarotCard(
            name: "King of Swords", arcana: "minor", suit: "Swords", number: 14,
            uprightMeaning: "Mental clarity, intellectual power, authority, truth, and ethics.",
            reversedMeaning: "Quiet power, inner truth, misuse of power, and manipulation.",
            keywords: ["intellectual", "authority", "truth", "clarity", "ethics"],
            element: "Air", zodiacAssociation: "Gemini", yesNo: "neutral"
        )
    ]

    // MARK: - Minor Arcana: Pentacles (Earth)

    static let pentaclesCards: [TarotCard] = [
        TarotCard(
            name: "Ace of Pentacles", arcana: "minor", suit: "Pentacles", number: 1,
            uprightMeaning: "A new financial or career opportunity, manifestation, and abundance.",
            reversedMeaning: "Lost opportunity, missed chance, and lack of planning and foresight.",
            keywords: ["opportunity", "abundance", "manifestation", "prosperity", "new beginnings"],
            element: "Earth", zodiacAssociation: "Capricorn, Taurus, Virgo", yesNo: "yes"
        ),
        TarotCard(
            name: "Two of Pentacles", arcana: "minor", suit: "Pentacles", number: 2,
            uprightMeaning: "Multiple priorities, time management, prioritization, and adaptability.",
            reversedMeaning: "Over-committed, disorganization, reprioritization needed.",
            keywords: ["balance", "adaptation", "priorities", "flexibility", "juggling"],
            element: "Earth", zodiacAssociation: "Capricorn", yesNo: "neutral"
        ),
        TarotCard(
            name: "Three of Pentacles", arcana: "minor", suit: "Pentacles", number: 3,
            uprightMeaning: "Teamwork, initial fulfilment, collaboration, learning, and implementation.",
            reversedMeaning: "Lack of teamwork, disorganized, and group conflict.",
            keywords: ["teamwork", "collaboration", "growth", "skill", "learning"],
            element: "Earth", zodiacAssociation: "Capricorn", yesNo: "yes"
        ),
        TarotCard(
            name: "Four of Pentacles", arcana: "minor", suit: "Pentacles", number: 4,
            uprightMeaning: "Saving money, security, conservatism, scarcity, and control.",
            reversedMeaning: "Over-spending, greed, self-protection, and generosity.",
            keywords: ["security", "possession", "stability", "conservatism", "holding on"],
            element: "Earth", zodiacAssociation: "Taurus", yesNo: "neutral"
        ),
        TarotCard(
            name: "Five of Pentacles", arcana: "minor", suit: "Pentacles", number: 5,
            uprightMeaning: "Financial loss, poverty, lack mindset, isolation, and worry.",
            reversedMeaning: "Recovery from financial loss, spiritual poverty, and isolation.",
            keywords: ["poverty", "hardship", "isolation", "loss", "insecurity"],
            element: "Earth", zodiacAssociation: "Taurus", yesNo: "no"
        ),
        TarotCard(
            name: "Six of Pentacles", arcana: "minor", suit: "Pentacles", number: 6,
            uprightMeaning: "Giving, receiving, sharing wealth, generosity, and charity.",
            reversedMeaning: "Self-care, unpaid debts, one-sided charity, and strings attached.",
            keywords: ["generosity", "giving", "receiving", "wealth", "sharing"],
            element: "Earth", zodiacAssociation: "Taurus", yesNo: "yes"
        ),
        TarotCard(
            name: "Seven of Pentacles", arcana: "minor", suit: "Pentacles", number: 7,
            uprightMeaning: "Long-term vision, sustainable results, perseverance, and investment.",
            reversedMeaning: "Lack of long-term vision, limited success, and procrastination.",
            keywords: ["patience", "harvest", "assessment", "investment", "perseverance"],
            element: "Earth", zodiacAssociation: "Virgo", yesNo: "neutral"
        ),
        TarotCard(
            name: "Eight of Pentacles", arcana: "minor", suit: "Pentacles", number: 8,
            uprightMeaning: "Apprenticeship, repetitive tasks, mastery, skill development, and quality.",
            reversedMeaning: "Self-development, perfectionism, and misdirected activity.",
            keywords: ["diligence", "skill", "craftsmanship", "dedication", "mastery"],
            element: "Earth", zodiacAssociation: "Virgo", yesNo: "yes"
        ),
        TarotCard(
            name: "Nine of Pentacles", arcana: "minor", suit: "Pentacles", number: 9,
            uprightMeaning: "Abundance, luxury, self-sufficiency, and financial independence.",
            reversedMeaning: "Self-worth, over-investment in work, and hustling.",
            keywords: ["abundance", "luxury", "self-sufficiency", "independence", "achievement"],
            element: "Earth", zodiacAssociation: "Virgo", yesNo: "yes"
        ),
        TarotCard(
            name: "Ten of Pentacles", arcana: "minor", suit: "Pentacles", number: 10,
            uprightMeaning: "Wealth, financial security, family, long-term success, and contribution.",
            reversedMeaning: "The dark side of wealth, financial failure, and loss of stability.",
            keywords: ["wealth", "legacy", "family", "security", "fulfillment"],
            element: "Earth", zodiacAssociation: "Virgo", yesNo: "yes"
        ),
        TarotCard(
            name: "Page of Pentacles", arcana: "minor", suit: "Pentacles", number: 11,
            uprightMeaning: "Manifestation, financial opportunity, new beginnings, and skill development.",
            reversedMeaning: "Lack of progress, procrastination, learn from failure.",
            keywords: ["practicality", "opportunity", "scholarship", "diligence", "potential"],
            element: "Earth", zodiacAssociation: "Earth signs", yesNo: "yes"
        ),
        TarotCard(
            name: "Knight of Pentacles", arcana: "minor", suit: "Pentacles", number: 12,
            uprightMeaning: "Hard work, productivity, routine, and conservatism. Steady and reliable.",
            reversedMeaning: "Self-discipline, boredom, feeling stuck, and perfectionism.",
            keywords: ["reliable", "methodical", "hardworking", "routine", "dedication"],
            element: "Earth", zodiacAssociation: "Virgo", yesNo: "yes"
        ),
        TarotCard(
            name: "Queen of Pentacles", arcana: "minor", suit: "Pentacles", number: 13,
            uprightMeaning: "Nurturing, practical, providing financially, and a working parent.",
            reversedMeaning: "Financial independence, self-care, and work-home imbalance.",
            keywords: ["nurturing", "practical", "abundant", "provider", "grounded"],
            element: "Earth", zodiacAssociation: "Capricorn", yesNo: "yes"
        ),
        TarotCard(
            name: "King of Pentacles", arcana: "minor", suit: "Pentacles", number: 14,
            uprightMeaning: "Wealth, business, leadership, security, and discipline. Empire builder.",
            reversedMeaning: "Financially inept, obsessed with wealth, and stubborn.",
            keywords: ["abundance", "prosperity", "security", "ambition", "leadership"],
            element: "Earth", zodiacAssociation: "Taurus", yesNo: "yes"
        )
    ]

    // MARK: - Spreads

    static let allSpreads: [TarotSpread] = [
        TarotSpread(
            name: "Single Card",
            slug: "single",
            cardCount: 1,
            description: "A single card draw for daily guidance or a focused question.",
            positions: ["Present / Focus"]
        ),
        TarotSpread(
            name: "Three Card",
            slug: "three-card",
            cardCount: 3,
            description: "A classic three-card spread covering past, present, and future.",
            positions: ["Past", "Present", "Future"]
        ),
        TarotSpread(
            name: "Celtic Cross",
            slug: "celtic-cross",
            cardCount: 10,
            description: "The most comprehensive tarot spread for deep insight into a situation.",
            positions: [
                "Present Situation",
                "Crossing Influence",
                "Root / Foundation",
                "Recent Past",
                "Higher Purpose",
                "Near Future",
                "Your Approach",
                "External Influences",
                "Hopes and Fears",
                "Outcome"
            ]
        ),
        TarotSpread(
            name: "Love Spread",
            slug: "love",
            cardCount: 5,
            description: "A five-card spread to illuminate matters of the heart and relationships.",
            positions: [
                "Your Heart",
                "Their Heart",
                "The Connection",
                "Challenges",
                "Potential Outcome"
            ]
        ),
        TarotSpread(
            name: "Career Spread",
            slug: "career",
            cardCount: 5,
            description: "A five-card spread for professional guidance and career decisions.",
            positions: [
                "Current Situation",
                "Strengths to Leverage",
                "Challenges to Overcome",
                "Action to Take",
                "Likely Outcome"
            ]
        ),
        TarotSpread(
            name: "Mind Body Spirit",
            slug: "mind-body-spirit",
            cardCount: 3,
            description: "A three-card spread exploring mental, physical, and spiritual alignment.",
            positions: ["Mind", "Body", "Spirit"]
        )
    ]

    // MARK: - Helpers

    static func card(named name: String) -> TarotCard? {
        let normalized = name.lowercased().replacingOccurrences(of: "-", with: " ")
        return allCards.first { $0.name.lowercased() == normalized }
    }

    static func draw(count: Int) -> [TarotCard] {
        Array(allCards.shuffled().prefix(max(1, min(count, 78))))
    }

    static func spread(slug: String) -> TarotSpread? {
        allSpreads.first { $0.slug == slug }
    }

    static func reading(for spread: TarotSpread) -> TarotReadingResponse {
        let drawn = draw(count: spread.cardCount)
        let positionDescriptions: [String: String] = [
            "Past": "What has led to the current situation.",
            "Present": "The energy surrounding you right now.",
            "Future": "The likely direction if current energy continues.",
            "Present Situation": "The central issue or focus of your question.",
            "Crossing Influence": "What is helping or hindering you.",
            "Root / Foundation": "The underlying cause or basis of the situation.",
            "Recent Past": "Events that have just passed and their influence.",
            "Higher Purpose": "What you are working toward on a soul level.",
            "Near Future": "What is coming into being in the near term.",
            "Your Approach": "How you are approaching this situation.",
            "External Influences": "People and energies around you.",
            "Hopes and Fears": "Your deepest hope, which may also be your deepest fear.",
            "Outcome": "The likely outcome if current energies hold.",
            "Your Heart": "Your true feelings and desires in this relationship.",
            "Their Heart": "Their feelings and perspective.",
            "The Connection": "The energy that bonds you both.",
            "Challenges": "What stands in the way of harmony.",
            "Potential Outcome": "Where this relationship is headed.",
            "Current Situation": "Where you stand professionally right now.",
            "Strengths to Leverage": "Your greatest professional assets.",
            "Challenges to Overcome": "Obstacles on your path.",
            "Action to Take": "The most aligned next step.",
            "Likely Outcome": "The probable result of your current trajectory.",
            "Mind": "Your current mental state and thoughts.",
            "Body": "Your physical situation and wellbeing.",
            "Spirit": "Your spiritual energy and higher guidance.",
            "Present / Focus": "The energy most relevant to your question right now."
        ]
        var cards: [TarotCardPosition] = []
        for (index, position) in spread.positions.enumerated() {
            guard index < drawn.count else { break }
            let card = drawn[index]
            let isReversed = Bool.random()
            let posDesc = positionDescriptions[position] ?? "Reflects this area of your life."
            let meaning = isReversed ? card.reversedMeaning : card.uprightMeaning
            let interpretation = "\(card.name) in the \(position) position: \(meaning)"
            cards.append(TarotCardPosition(
                position: position,
                positionDescription: posDesc,
                card: card,
                isReversed: isReversed,
                interpretation: interpretation
            ))
        }
        let themes = cards.map { $0.card.keywords.first ?? $0.card.name }.joined(separator: ", ")
        let overall = "This reading highlights themes of \(themes). Reflect on how these energies are at play in your current journey."
        return TarotReadingResponse(spread: spread, cards: cards, overallInterpretation: overall)
    }
}
