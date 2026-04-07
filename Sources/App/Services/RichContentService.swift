import Foundation

// MARK: - Rich Content Service
// Provides deterministic content for compatibility reports, zodiac profiles, and transit forecasts.

enum RichContentService {

    // MARK: - Seed Helpers

    /// Order-independent seed for a sign pair.
    private static func signPairSeed(_ s1: ZodiacSign, _ s2: ZodiacSign) -> Int {
        let a = min(s1.index, s2.index)
        let b = max(s1.index, s2.index)
        return a * 100 + b
    }

    private static func pick<T>(from array: [T], seed: Int, offset: Int = 0) -> T {
        let index = abs(seed + offset * 7) % array.count
        return array[index]
    }

    private static func picks<T>(from array: [T], seed: Int, count: Int) -> [T] {
        let n = min(count, array.count)
        var result: [T] = []
        var usedIndices = Set<Int>()
        var step = 0
        while result.count < n {
            let index = abs(seed + step * 13) % array.count
            if !usedIndices.contains(index) {
                usedIndices.insert(index)
                result.append(array[index])
            }
            step += 1
        }
        return result
    }

    // MARK: - Compatibility Report

    static func compatibilityReport(sign1: ZodiacSign, sign2: ZodiacSign) -> CompatibilityReportResponse {
        let seed = signPairSeed(sign1, sign2)
        let score = compatibilityScore(sign1: sign1, sign2: sign2, seed: seed)
        return CompatibilityReportResponse(
            sign1: sign1.rawValue,
            sign2: sign2.rawValue,
            overallScore: score,
            overview: pick(from: compatOverview, seed: seed, offset: 0),
            love: pick(from: compatLove, seed: seed, offset: 1),
            friendship: pick(from: compatFriendship, seed: seed, offset: 2),
            communication: pick(from: compatCommunication, seed: seed, offset: 3),
            trust: pick(from: compatTrust, seed: seed, offset: 4),
            values: pick(from: compatValues, seed: seed, offset: 5),
            challenges: pick(from: compatChallenges, seed: seed, offset: 6),
            advice: pick(from: compatAdvice, seed: seed, offset: 7)
        )
    }

    private static func compatibilityScore(sign1: ZodiacSign, sign2: ZodiacSign, seed: Int) -> Int {
        var score = 55
        // Same element: great synergy
        if sign1.element == sign2.element { score += 20 }
        // Compatible elements
        let compatPairs: [(String, String)] = [
            ("Fire", "Air"), ("Air", "Fire"),
            ("Earth", "Water"), ("Water", "Earth")
        ]
        if compatPairs.contains(where: { $0.0 == sign1.element && $0.1 == sign2.element }) { score += 12 }
        // Different modality is generatively good
        if sign1.modality != sign2.modality { score += 6 }
        // Deterministic variance from seed
        score += (seed % 11) - 5
        return max(22, min(97, score))
    }

    // MARK: Compatibility Content Pools

    private static let compatOverview: [String] = [
        "This pairing brings together two distinct cosmic energies that, when balanced, can create something genuinely remarkable. Each partner carries strengths the other lacks, forming a whole greater than its parts. The journey together will be filled with growth, discovery, and the occasional delightful surprise.",
        "There is a natural magnetism between these signs, rooted in a mix of similarity and complementary difference. Their shared values create a stable foundation while their contrasting approaches keep things interesting and alive. With intention and care, this partnership can deepen into a lasting, meaningful bond.",
        "These two signs meet with an energetic charge that can feel electric or overwhelming depending on how it is channeled. The chemistry between them is undeniable, and what they build together can be lasting if both are willing to navigate the inevitable rough patches with patience. Their pairing is one of growth through productive tension.",
        "On the surface these signs may seem unlikely partners, yet astrology often surprises us with the chemistry found between apparent opposites. Each brings a quality the other quietly longs for, and in recognizing this, they can teach one another some of life's most valuable lessons. Mutual respect is the key that unlocks this pairing's true potential.",
        "This combination speaks to one of the zodiac's most intuitively harmonious unions, where both signs feel recognized and at ease in each other's presence. Their shared understanding runs deep, allowing for communication that transcends words. Together they create a sanctuary of trust and authentic connection that nourishes both souls.",
        "Two strong personalities meet in this pairing, each with their own way of moving through the world. The sparks can fly in both positive and challenging directions, and the direction they take is entirely within this couple's power to choose. With mutual willingness to honor difference, their combined force becomes an extraordinary source of strength.",
        "These signs carry a cosmic familiarity, as if their meeting was written in the stars long before they found each other. The ease with which they understand each other's deeper nature allows for a relationship that develops quickly and sustains itself beautifully. Their bond is one of genuine recognition and evolving warmth.",
        "A complex and fascinating pairing emerges here — one shaped by layers of difference that, when explored with openness, reveal surprising depth of compatibility. The work this couple puts into understanding each other pays enormous dividends. What begins as an intriguing puzzle can become one of the most rewarding relationships either has known."
    ]

    private static let compatLove: [String] = [
        "In love, these two signs bring out each other's most romantic and devoted qualities. Their physical and emotional chemistry tends to run hot, fueled by a mutual desire for depth and genuine connection. Over time, this love can mature into a steady flame that warms without burning.",
        "The romantic dimension of this pairing is marked by a tenderness and genuine appreciation that deepens over time. Both signs offer what the other secretly needs — one providing stability, the other bringing spontaneity and passion. Their love story, if written with care, becomes one of the most cherished chapters either will know.",
        "Love between these signs can feel destined from the very first meeting, charged with an intensity that is both exciting and a little daunting. The key is channeling that intensity into intimacy rather than conflict. When they do, the result is a love that leaves both partners feeling fully seen and adored.",
        "Romance between these two blooms slowly but roots deeply, built on the kind of trust that can only come from genuine mutual understanding. They are not inclined toward dramatic gestures but instead create love through consistent presence and quiet acts of devotion. Their partnership becomes a safe harbor that each carries within them always.",
        "These signs love differently at first, which can create some initial misunderstanding before a beautiful rhythm is found. One leads with passion, the other with patience, and in this dance they discover a complementarity that makes their love both exciting and enduring. Learning each other's love language is the great romantic adventure of this pairing.",
        "There is a playful, joyful quality to the love these signs share — full of laughter, shared discovery, and a mutual delight in each other's company. The chemistry between them feels effortless, as though they were designed to enjoy each other. Their romantic life has the quality of a beautiful, ongoing adventure.",
        "Love in this pairing asks both partners to grow beyond their comfort zones, and in doing so they discover capacities for intimacy they did not know they possessed. The challenges they navigate together forge a bond of extraordinary resilience and depth. What emerges is a love that has been tested and proven, and that both partners can rely on completely."
    ]

    private static let compatFriendship: [String] = [
        "As friends, these signs form a natural alliance built on mutual admiration and complementary strengths. They have an instinct for bringing out the best in each other, whether through encouragement, honest feedback, or simply showing up when it matters most. Their friendship is one that endures across time and distance.",
        "The friendship between these two signs is characterized by genuine warmth and a deep enjoyment of each other's company. They share similar values around loyalty and fun, creating a bond that is both uplifting and reliably supportive. Friends who know this pair often remark on the easy joy they bring to every gathering.",
        "These signs make excellent friends precisely because they understand and accept each other's quirks without judgment. Their dynamic is one of mutual respect, and their conversations tend to be either deeply meaningful or hilariously enjoyable — often both at once. This is the kind of friendship that becomes a cornerstone of each person's life.",
        "Friendship between these two signs is energizing and dynamic, each one pushing the other toward new experiences and broader horizons. They challenge one another in the best sense, expanding each other's thinking and perspectives with enthusiasm. The friend group that forms around this pairing tends to be lively, adventurous, and loyal.",
        "There is a grounding quality to the friendship these signs share — each one providing a stable presence that the other can count on during uncertain times. Their bond is built on reliability and sincerity, the kind of friendship where help is offered before it is asked for. This is a friendship for the long haul.",
        "The friendship between these signs has a creative, generative quality, with each partner inspiring the other to new ideas and endeavors. They collaborate naturally, combining their different strengths into projects and adventures neither would undertake alone. Their partnership produces something genuinely original and exciting."
    ]

    private static let compatCommunication: [String] = [
        "Communication between these signs tends to be remarkably direct and effective, with each partner feeling heard and understood. They have an intuitive sense for each other's communication style, allowing them to navigate difficult conversations with unusual grace. Over time they develop a shorthand that makes their exchanges swift and deeply satisfying.",
        "These two signs communicate with a blend of honesty and tact that is rare and valuable in any relationship. They know how to deliver hard truths without cruelty and how to receive feedback without defensiveness. This mutual communicative skill keeps their relationship honest, evolving, and resilient.",
        "There can be an initial period of adjustment as these signs learn each other's communication styles, which can be quite different on the surface. One may prefer direct, decisive exchange while the other favors a more exploratory approach. As they learn to bridge this gap, their conversations become extraordinarily rich and satisfying.",
        "The intellectual chemistry between these signs makes for stimulating and lively communication that both find deeply enjoyable. Their conversations range easily from the profound to the playful, held together by genuine curiosity about each other's perspectives. This shared delight in ideas and expression is one of the greatest gifts of their pairing.",
        "Communication requires some conscious effort in this pairing, as each sign processes and expresses differently enough to create occasional misunderstanding. The good news is that both are capable of the kind of patient, attentive listening that transforms potential miscommunication into deeper understanding. The investment in learning to communicate well pays enormous rewards.",
        "These signs communicate with a naturalness and ease that suggests a deep and pre-existing understanding. They seem to intuitively grasp what the other means even when the words are imprecise, and can finish each other's sentences with a frequency that delights them both. Their communicative harmony is one of the real pleasures of this relationship."
    ]

    private static let compatTrust: [String] = [
        "Trust builds steadily and surely in this pairing, grounded in both signs' genuine commitment to honesty and follow-through. Neither is inclined to play games, and their shared distaste for deception creates a foundation of transparency that makes the relationship deeply secure. Over time, the trust between them becomes unshakeable.",
        "Building trust is a process for these two signs — one that unfolds with care and is all the more valuable for it. Each partner has their own patterns around vulnerability, and respecting these as they open up to each other creates a bond of genuine safety. The trust they eventually share feels earned and thus deeply valued.",
        "There is a natural trustworthiness that each of these signs perceives in the other fairly early in their relationship. Their instincts tell them they are safe here, and those instincts tend to be confirmed over time. The trust between them becomes one of the most treasured aspects of their connection.",
        "Trust is tested in this pairing, often in ways that ultimately strengthen it rather than damage it. These two signs are both capable of the growth that genuine trustworthiness requires, and when they face their tests together, they emerge with a bond that is truly solid. The relationship that comes through these tests is one built to last.",
        "For these signs, trust is built through consistent action over time rather than words or promises. Both instinctively understand this and demonstrate their reliability in the thousand small ways that compose a life shared together. The trust they build is the quiet but powerful bedrock beneath everything else they create."
    ]

    private static let compatValues: [String] = [
        "These signs share a core set of values around authenticity, loyalty, and personal growth that provides a strong alignment beneath their surface differences. When the big questions of life arise — how to treat others, what to build toward, what to protect — they tend to find themselves in agreement. This values alignment is the compass that keeps their relationship on course.",
        "The values of these two signs overlap in meaningful ways while also offering productive differences that expand each partner's sense of what matters. One may privilege freedom while the other values security, and in navigating this difference honestly, they arrive at a richer understanding of what they each truly need. The dialogue around values is one of this pairing's great gifts.",
        "Both of these signs hold integrity and depth of commitment as central values, creating a strong resonance at the foundation of their relationship. They may express these values differently in daily life, but the underlying orientation is shared and mutually recognized. This alignment makes them powerful allies in building a life that reflects what they both believe.",
        "These signs approach life with a shared orientation toward meaning and purpose that creates a profound sense of alignment. They are both drawn to experiences and relationships that carry genuine significance, and in each other they find a partner who understands why this matters. Their shared values make them powerful co-creators of a life well-lived.",
        "There are places where these signs' values diverge, and these represent opportunities for genuine dialogue and mutual expansion. One may emphasize practicality while the other leans toward idealism, and in the space between these poles they can find a synthesis that serves them both beautifully. Their differences in values, explored with openness, become a source of growth."
    ]

    private static let compatChallenges: [String] = [
        "The primary challenge in this pairing arises when each sign retreats into their most defensive or rigid patterns. One may become distant under stress while the other intensifies, and these opposing coping strategies can create painful misunderstandings. The solution lies in learning to communicate needs directly rather than hoping the other will intuit them.",
        "These signs can occasionally clash around pace and priorities — one may push forward when the other needs to pause, or one may require more emotional processing than the other naturally offers. Recognizing these differences as complementary rather than incompatible is the key insight that transforms friction into flow. Patience and curiosity about each other's rhythms go a long way.",
        "Power dynamics can become a challenge for this pairing if neither partner is willing to yield when it matters. Both signs carry considerable will and conviction, which is part of their mutual attraction but can also generate conflict when interests diverge. Learning to hold their ground while genuinely honoring the other's perspective is the ongoing work of this relationship.",
        "Communication breakdowns represent the primary challenge for this pair, often stemming from genuinely different ways of processing and expressing emotion. What one reads as coldness may simply be the other's way of thinking, and what feels like intensity to one may be normal expression for the other. Building a shared language for emotional life is the most important ongoing project of this relationship.",
        "Trust is the central challenge for this pairing — not because either sign is untrustworthy, but because both carry wounds from past experiences that can make vulnerability feel dangerous. The courage to be genuinely open with each other, despite past hurts, is what this relationship asks of both partners. The reward for that courage is an intimacy that transforms both of them."
    ]

    private static let compatAdvice: [String] = [
        "Honor the differences between you as features rather than flaws. The qualities that can frustrate you most in each other are often the exact gifts you came into each other's lives to receive. When tension arises, lead with curiosity rather than certainty, and let the conversation take you somewhere new.",
        "Create regular rituals of connection — small, consistent practices that keep you tuned to each other amid the noise of daily life. The quality of your attention to each other in the ordinary moments is what determines the extraordinary nature of your bond. Do not wait for grand occasions to show up fully for each other.",
        "Speak your needs clearly and early, before they have accumulated the weight of resentment. This pairing thrives on honesty, and the vulnerability of saying 'I need this from you' is exactly the kind of intimacy that deepens your connection. Trust each other enough to be direct, and receive directness as the gift it is.",
        "Celebrate each other's individual growth and pursuits with genuine enthusiasm. The security of this relationship is a launching pad, not a cage, and when each of you is thriving independently, the partnership becomes even richer. Bring your fullest, most alive selves to each other rather than the comfortable but diminished version.",
        "Give each other the gift of generous interpretation — assume positive intent when the other's actions are ambiguous, and ask before concluding. The story you tell about each other's behavior shapes the relationship as much as the behavior itself. Choosing the most loving interpretation, and then checking it, creates a relationship culture of warmth and trust.",
        "Learn each other's love languages with the same care you would dedicate to learning a language for travel to a beloved country. The effort of understanding how your partner gives and receives love — and meeting them there — is one of the most profound acts of care available to you. Speak the language of their heart, and watch your relationship flourish.",
        "Build a shared vision of the life you are creating together, revisiting and refining it as you both grow. Couples who navigate differences successfully are often united by a larger purpose that gives context to the inevitable compromises. Know what you are building, and let that shared commitment carry you through the moments of uncertainty."
    ]

    // MARK: - Zodiac Profile

    static func zodiacProfile(sign: ZodiacSign) -> ZodiacProfileResponse {
        let d = profileData[sign]!
        return ZodiacProfileResponse(
            sign: sign.rawValue,
            symbol: sign.symbol,
            element: sign.element,
            modality: sign.modality,
            rulingPlanet: sign.rulingPlanet,
            dates: d.dates,
            overview: d.overview,
            personalityTraits: d.personalityTraits,
            strengths: d.strengths,
            weaknesses: d.weaknesses,
            loveStyle: d.loveStyle,
            careerStrengths: d.careerStrengths,
            bestMatches: d.bestMatches,
            worstMatches: d.worstMatches
        )
    }

    private struct ProfileData {
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

    // swiftlint:disable:next closure_body_length
    private static let profileData: [ZodiacSign: ProfileData] = [
        .aries: ProfileData(
            dates: "March 21 – April 19",
            overview: "Aries is the first sign of the zodiac, embodying the spirit of new beginnings and pioneering energy. Ruled by Mars, those born under this fire sign possess an irresistible drive and passion that propels them forward in all areas of life. Aries individuals are natural leaders who thrive on challenge and competition, setting ambitious goals and charging toward them with infectious enthusiasm. Their boldness and authenticity make them inspiring presences who remind everyone around them that extraordinary things are possible.",
            personalityTraits: ["Adventurous", "Courageous", "Enthusiastic", "Impulsive", "Independent"],
            strengths: ["Natural leadership", "Boundless energy", "Quick decision-making", "Fearless attitude", "Contagious confidence"],
            weaknesses: ["Impatience", "Short temper", "Impulsiveness", "Selfishness", "Competitive to a fault"],
            loveStyle: "In love, Aries is passionate, direct, and fiercely devoted once they have chosen their person. They pursue their heart's desire with the same intensity they bring to all endeavors, but need a partner who can match their energy and maintain their interest through genuine engagement and spark.",
            careerStrengths: "Aries excels in roles that demand initiative, leadership, and fast-paced decision-making. Entrepreneurship, athletics, emergency services, and any field where boldness is rewarded are natural fits for their courage and drive.",
            bestMatches: ["Leo", "Sagittarius", "Aquarius"],
            worstMatches: ["Cancer", "Capricorn", "Pisces"]
        ),
        .taurus: ProfileData(
            dates: "April 20 – May 20",
            overview: "Taurus is the steadfast earth sign ruled by Venus, embodying stability, sensuality, and a deep appreciation for life's finer pleasures. Those born under this sign are celebrated for their reliability, patience, and powerful sense of values that guides every major decision they make. Taurus individuals build lasting foundations in all they undertake, from relationships to careers, with a methodical patience that yields enduring results. Their connection to beauty and the material world gives them a grounded wisdom that others trust and seek out.",
            personalityTraits: ["Reliable", "Patient", "Sensual", "Stubborn", "Practical"],
            strengths: ["Unwavering loyalty", "Financial acumen", "Aesthetic appreciation", "Persistence", "Dependability"],
            weaknesses: ["Stubbornness", "Possessiveness", "Resistance to change", "Materialism", "Overindulgence"],
            loveStyle: "Taurus is a devoted, sensual partner who expresses love through physical comfort, thoughtful provision, and steadfast presence. They move slowly toward commitment but once they arrive, their loyalty is absolute — a bedrock of affection and care that a partner can rely on completely.",
            careerStrengths: "Taurus thrives in stable, tangible fields such as finance, real estate, culinary arts, and design. Their methodical approach and eye for quality make them exceptional in any role where patience, precision, and an appreciation for value are rewarded.",
            bestMatches: ["Virgo", "Capricorn", "Pisces"],
            worstMatches: ["Leo", "Aquarius", "Aries"]
        ),
        .gemini: ProfileData(
            dates: "May 21 – June 20",
            overview: "Gemini is the intellectual air sign ruled by Mercury, symbolized by the twins representing duality and the gift of seeing every side of a situation. Those born under this sign are quick-witted, endlessly curious, and adaptable communicators who thrive on variety and mental stimulation. Gemini individuals possess a remarkable ability to connect with people from all walks of life, weaving ideas together with a playful, effervescent brilliance. Their minds are constantly in motion, and they bring extraordinary vitality to every conversation and project they touch.",
            personalityTraits: ["Witty", "Versatile", "Curious", "Indecisive", "Expressive"],
            strengths: ["Exceptional communication", "Intellectual agility", "Adaptability", "Social charisma", "Creative thinking"],
            weaknesses: ["Inconsistency", "Indecisiveness", "Superficiality", "Restlessness", "Nervous energy"],
            loveStyle: "Gemini falls in love with the mind first, needing a partner who stimulates their intellect and keeps conversation endlessly fresh. They are affectionate and playful in romance but require genuine freedom and variety to sustain their interest and prevent the restlessness that is their greatest romantic challenge.",
            careerStrengths: "Gemini excels in writing, journalism, teaching, sales, and any field requiring sharp communication and rapid adaptability. Their ability to absorb information quickly and multitask with grace makes them invaluable in fast-moving, idea-driven environments.",
            bestMatches: ["Libra", "Aquarius", "Aries"],
            worstMatches: ["Pisces", "Virgo", "Scorpio"]
        ),
        .cancer: ProfileData(
            dates: "June 21 – July 22",
            overview: "Cancer is the nurturing water sign ruled by the Moon, deeply connected to the tides of emotion, the meaning of home, and the bonds of family. Those born under this sign are profoundly intuitive and empathetic, often sensing the emotional needs of others before a word has been spoken. Cancer individuals create warm, safe havens wherever they go, driven by an instinct to protect and cherish those they love. Beneath their protective shell lies a rich inner world of creativity and compassion that, when shared, has the power to heal.",
            personalityTraits: ["Nurturing", "Intuitive", "Protective", "Moody", "Imaginative"],
            strengths: ["Deep empathy", "Fierce loyalty", "Emotional intelligence", "Creativity", "Domestic wisdom"],
            weaknesses: ["Moodiness", "Over-sensitivity", "Clinginess", "Indirect communication", "Dwelling on the past"],
            loveStyle: "Cancer loves deeply and unconditionally, creating bonds of extraordinary intimacy and tender devotion. They need genuine security and consistent reassurance from a partner, offering in return a love that nurtures the soul and stands firm through every season of life.",
            careerStrengths: "Cancer thrives in caregiving, education, healthcare, psychology, and the arts. Their intuitive understanding of human needs and their genuine desire to support others make them exceptional counselors, teachers, and creators whose work touches hearts.",
            bestMatches: ["Scorpio", "Pisces", "Taurus"],
            worstMatches: ["Aries", "Libra", "Aquarius"]
        ),
        .leo: ProfileData(
            dates: "July 23 – August 22",
            overview: "Leo is the radiant fire sign ruled by the Sun, embodying creativity, generosity, and a natural flair for the grand gesture. Those born under this sign carry an innate magnetism that draws others into their warm, generous orbit, where they feel genuinely celebrated. Leo individuals possess a regal confidence and a heart of gold — they are as devoted to uplifting others as they are committed to their own shining expression. Their spirit burns brightest when they are creating, inspiring, and reminding the world that life is meant to be celebrated fully.",
            personalityTraits: ["Charismatic", "Generous", "Creative", "Dramatic", "Loyal"],
            strengths: ["Natural leadership", "Creative vision", "Generosity of spirit", "Charismatic presence", "Unwavering loyalty"],
            weaknesses: ["Arrogance", "Stubbornness", "Need for praise", "Domineering tendencies", "Vanity"],
            loveStyle: "Leo loves with grand gestures and an open, devoted heart, seeking a partner who both appreciates their warmth and reciprocates with genuine admiration. They are fiercely loyal and protective in love, but need to feel celebrated and truly seen to sustain the passion that defines them.",
            careerStrengths: "Leo excels in performance arts, entertainment, leadership, and creative entrepreneurship. Their natural authority and ability to inspire loyalty and enthusiasm make them powerful directors, executives, and public figures whose vision others are proud to follow.",
            bestMatches: ["Aries", "Sagittarius", "Gemini"],
            worstMatches: ["Taurus", "Scorpio", "Capricorn"]
        ),
        .virgo: ProfileData(
            dates: "August 23 – September 22",
            overview: "Virgo is the analytical earth sign ruled by Mercury, celebrated for its meticulous attention to detail, quiet competence, and deep dedication to service. Those born under this sign possess a keen, discerning intellect and a practical wisdom that allows them to solve complex problems with elegant precision. Virgo individuals hold high standards for themselves and others, driven by a genuine desire to improve and perfect everything they touch. Their thoughtful care and reliability make them indispensable in every area of life they devote themselves to.",
            personalityTraits: ["Analytical", "Diligent", "Modest", "Critical", "Practical"],
            strengths: ["Attention to detail", "Reliability", "Analytical thinking", "Health consciousness", "Service orientation"],
            weaknesses: ["Perfectionism", "Over-criticism", "Excessive worry", "Rigidity", "Self-doubt"],
            loveStyle: "Virgo expresses love through acts of service and a thousand thoughtful gestures that improve a partner's daily life in tangible ways. They need time to build genuine trust before opening their heart, but once committed, their attentiveness and loyalty create deep bonds of lasting devotion.",
            careerStrengths: "Virgo thrives in healthcare, research, editing, accounting, and any field demanding precision and analytical skill. Their methodical nature and uncompromising commitment to excellence make them indispensable wherever accuracy, careful judgment, and dedicated effort are valued.",
            bestMatches: ["Taurus", "Capricorn", "Cancer"],
            worstMatches: ["Sagittarius", "Gemini", "Aquarius"]
        ),
        .libra: ProfileData(
            dates: "September 23 – October 22",
            overview: "Libra is the harmonious air sign ruled by Venus, symbolized by the scales that represent balance, justice, and a profound appreciation for beauty in all its forms. Those born under this sign are natural diplomats with an innate ability to perceive multiple perspectives and forge consensus where others see only conflict. Libra individuals are drawn to elegance — in their surroundings, their relationships, and their ideas — and they work tirelessly to create harmony wherever life takes them. Their charm, fairness, and genuine care for others make them beloved companions and powerful peacemakers.",
            personalityTraits: ["Diplomatic", "Charming", "Idealistic", "Indecisive", "Social"],
            strengths: ["Fairness and justice", "Aesthetic sense", "Social grace", "Diplomatic skill", "Romantic devotion"],
            weaknesses: ["Indecisiveness", "People-pleasing", "Avoidance of conflict", "Superficiality", "Co-dependency"],
            loveStyle: "Libra is a romantic idealist who seeks a true partnership of equals, built on mutual respect, shared beauty, and rich intellectual connection. They are attentive and considerate partners who create an atmosphere of harmony and delight, though they may sidestep difficult conversations to preserve the peace they love.",
            careerStrengths: "Libra excels in law, diplomacy, design, counseling, and public relations. Their ability to mediate disputes, create beautiful environments, and build relationships of trust makes them exceptional in roles that blend creativity with genuine human connection.",
            bestMatches: ["Gemini", "Aquarius", "Leo"],
            worstMatches: ["Cancer", "Capricorn", "Pisces"]
        ),
        .scorpio: ProfileData(
            dates: "October 23 – November 21",
            overview: "Scorpio is the intense water sign ruled by Pluto, associated with transformation, depth, and the hidden mysteries that lie beneath the surface of ordinary experience. Those born under this sign possess extraordinary willpower and penetrating perceptive abilities that allow them to see what others overlook or prefer not to confront. Scorpio individuals are deeply magnetic, drawing others in with their intensity and the sense that engaging with them will change you. Their capacity for profound loyalty and radical self-transformation makes them some of the most powerful forces of evolution in the zodiac.",
            personalityTraits: ["Intense", "Perceptive", "Determined", "Secretive", "Passionate"],
            strengths: ["Emotional depth", "Investigative ability", "Remarkable resilience", "Fierce loyalty", "Strategic intelligence"],
            weaknesses: ["Jealousy", "Vindictiveness", "Obsessiveness", "Distrust of others", "Controlling tendencies"],
            loveStyle: "Scorpio loves with an all-or-nothing intensity that forges bonds of extraordinary depth, loyalty, and transformative power. They require complete trust and genuine vulnerability from a partner, offering in return a love that faces every challenge and emerges stronger for having been tested.",
            careerStrengths: "Scorpio thrives in investigation, research, psychology, surgery, and any field involving hidden information or the management of transformation and crisis. Their penetrating focus and ability to work beneath the surface make them exceptional researchers, strategists, and guides through difficult change.",
            bestMatches: ["Cancer", "Pisces", "Virgo"],
            worstMatches: ["Leo", "Aquarius", "Aries"]
        ),
        .sagittarius: ProfileData(
            dates: "November 22 – December 21",
            overview: "Sagittarius is the adventurous fire sign ruled by Jupiter, embodying freedom, philosophical inquiry, and an insatiable appetite for wisdom and experience that spans the full range of human possibility. Those born under this sign carry an infectious optimism and a natural enthusiasm that broadens horizons and reminds others that the world is wider than they imagined. Sagittarius individuals are truth-seekers and explorers, equally drawn to physical journeys and the great intellectual adventures of ideas and meaning. Their expansive vision and generous spirit make them inspiring teachers, adventurers, and companions on life's journey.",
            personalityTraits: ["Optimistic", "Adventurous", "Philosophical", "Tactless", "Free-spirited"],
            strengths: ["Expansive vision", "Philosophical depth", "Infectious optimism", "Genuine generosity", "Courage of honesty"],
            weaknesses: ["Restlessness", "Bluntness", "Overconfidence", "Inconsistency", "Fear of commitment"],
            loveStyle: "Sagittarius approaches love as a grand adventure, seeking a partner who shares their appetite for exploration, honest discourse, and the kind of growth that comes from living fully and freely together. They are warm and generous lovers but need meaningful personal freedom and will not thrive with a partner who attempts to confine their expansive spirit.",
            careerStrengths: "Sagittarius excels in academia, publishing, travel, law, and entrepreneurship. Their big-picture thinking, love of learning, and natural ability to inspire and educate others make them exceptional professors, adventurers, visionaries, and leaders of expanding enterprises.",
            bestMatches: ["Aries", "Leo", "Aquarius"],
            worstMatches: ["Virgo", "Pisces", "Cancer"]
        ),
        .capricorn: ProfileData(
            dates: "December 22 – January 19",
            overview: "Capricorn is the ambitious earth sign ruled by Saturn, defined by discipline, perseverance, and an unrelenting commitment to building something meaningful and enduring. Those born under this sign approach life as a structured, purposeful climb toward goals that matter, using patience and strategic precision where others might rely on impulse. Capricorn individuals possess a quiet authority and a dry, understated wit that commands genuine respect, concealing a warm and devoted heart beneath their composed exterior. Their integrity and long view leave legacies in all they undertake — in career, in family, in community.",
            personalityTraits: ["Ambitious", "Disciplined", "Reserved", "Pragmatic", "Patient"],
            strengths: ["Exceptional work ethic", "Strategic planning", "Steadfast reliability", "Long-term vision", "Leadership by example"],
            weaknesses: ["Rigidity", "Pessimistic tendencies", "Workaholic patterns", "Emotional repression", "Status-consciousness"],
            loveStyle: "Capricorn builds love slowly, deliberately, and with an eye toward permanence, prioritizing long-term compatibility and genuine character over early passion. They are devoted and protective partners who express love through acts of provision, reliability, and the quiet daily demonstrations that a life together is being carefully tended.",
            careerStrengths: "Capricorn excels in business, finance, government, architecture, and any field that rewards long-term discipline, strategic thinking, and the willingness to do the work others find too demanding. Their organizational brilliance makes them exceptional builders of institutions that stand the test of time.",
            bestMatches: ["Taurus", "Virgo", "Pisces"],
            worstMatches: ["Aries", "Libra", "Leo"]
        ),
        .aquarius: ProfileData(
            dates: "January 20 – February 18",
            overview: "Aquarius is the visionary air sign ruled by Uranus, associated with innovation, humanitarianism, and the progressive ideals that shape the world of tomorrow. Those born under this sign possess brilliantly original minds that see beyond conventional boundaries, championing causes and solutions that serve the collective good before the individual. Aquarius individuals prize intellectual freedom and authenticity above almost everything else, often finding themselves decades ahead of the cultural conversation in their thinking and social awareness. Their unique blend of detached idealism and genuine care for humanity makes them powerful and often beloved catalysts for positive change.",
            personalityTraits: ["Innovative", "Independent", "Humanitarian", "Eccentric", "Intellectual"],
            strengths: ["Original thinking", "Humanitarian vision", "Intellectual brilliance", "Fierce independence", "Social consciousness"],
            weaknesses: ["Emotional detachment", "Stubborn contrarianism", "Unpredictability", "Rebelliousness for its own sake", "Aloofness"],
            loveStyle: "Aquarius needs a true intellectual equal and a genuine friend in a romantic partner, valuing shared ideals and stimulating conversation above conventional romantic gestures. They are loyal and inventive in love but require significant personal independence and are deeply uncomfortable with possessiveness or emotional manipulation.",
            careerStrengths: "Aquarius thrives in technology, science, social activism, design, and humanitarian work. Their ability to envision radical solutions to complex systemic problems makes them groundbreaking scientists, technologists, social reformers, and innovators whose work reshapes entire fields.",
            bestMatches: ["Gemini", "Libra", "Sagittarius"],
            worstMatches: ["Taurus", "Scorpio", "Cancer"]
        ),
        .pisces: ProfileData(
            dates: "February 19 – March 20",
            overview: "Pisces is the mystical water sign ruled by Neptune, embodying compassion, imagination, and a profound attunement to the spiritual dimensions of existence that most people can only glimpse. Those born under this sign are deeply empathetic dreamers who move through life guided by intuition and an open, receptive heart that feels the world's beauty and pain with equal intensity. Pisces individuals possess remarkable creative gifts and a natural ability to dissolve the boundaries between self and other, channeling universal compassion into art, healing, and devoted service. Their otherworldly sensitivity allows them to perceive meaning and beauty invisible to others, and to translate that perception into works that touch the deepest places in the human heart.",
            personalityTraits: ["Empathetic", "Imaginative", "Intuitive", "Escapist", "Compassionate"],
            strengths: ["Boundless compassion", "Artistic ability", "Spiritual insight", "Powerful intuition", "Fluid adaptability"],
            weaknesses: ["Over-idealism", "Escapism", "Chronic indecisiveness", "Emotional over-sensitivity", "Victim patterns"],
            loveStyle: "Pisces loves with a transcendent, selfless devotion that sees the divine in their beloved and seeks a soul-deep union that transcends ordinary romance. They are among the most tender and giving of partners, but must consciously guard against dissolving so completely into another's needs that they lose touch with their own.",
            careerStrengths: "Pisces excels in the arts, healing professions, spiritual counseling, social work, and film or music. Their empathy, visionary creativity, and ability to channel universal human emotion make them extraordinary artists, therapists, spiritual guides, and advocates for the vulnerable.",
            bestMatches: ["Cancer", "Scorpio", "Capricorn"],
            worstMatches: ["Gemini", "Sagittarius", "Virgo"]
        )
    ]

    // MARK: - Transit Forecast

    static let validPeriods: [String] = ["daily", "weekly", "monthly"]

    static func transitForecast(sign: ZodiacSign, period: String, year: Int, month: Int, day: Int) -> TransitForecastResponse {
        let dateSeed = year * 10000 + month * 100 + day
        let si = sign.index
        // Period offset so daily/weekly/monthly return distinct content
        let periodOffset: Int
        switch period {
        case "weekly":  periodOffset = 100
        case "monthly": periodOffset = 200
        default:        periodOffset = 0
        }
        let seed = dateSeed + si * 37 + periodOffset

        let luckyNum = abs(seed + si * 11) % 99 + 1
        let energyLevel = abs(seed + si * 17) % 10 + 1
        let color = pick(from: luckyColors, seed: seed, offset: si + 2)
        let mood = pick(from: transitMoods, seed: seed, offset: si + 4)

        return TransitForecastResponse(
            sign: sign.rawValue,
            period: period,
            overview: pick(from: transitOverview[period] ?? transitOverview["weekly"]!, seed: seed, offset: 0),
            love: pick(from: transitLove[period] ?? transitLove["weekly"]!, seed: seed, offset: si + 1),
            career: pick(from: transitCareer[period] ?? transitCareer["weekly"]!, seed: seed, offset: si + 2),
            health: pick(from: transitHealth[period] ?? transitHealth["weekly"]!, seed: seed, offset: si + 3),
            luckyNumber: luckyNum,
            luckyColor: color,
            mood: mood,
            energyLevel: energyLevel,
            advice: pick(from: transitAdvice, seed: seed, offset: si + 5)
        )
    }

    // MARK: Transit Content Pools

    private static let luckyColors: [String] = [
        "Crimson", "Sapphire Blue", "Forest Green", "Amethyst Purple",
        "Golden Yellow", "Rose Pink", "Midnight Blue", "Copper",
        "Turquoise", "Silver", "Coral", "Ivory", "Jade", "Scarlet", "Lavender"
    ]

    private static let transitMoods: [String] = [
        "Inspired", "Reflective", "Bold", "Nurturing", "Analytical",
        "Playful", "Determined", "Serene", "Passionate", "Curious",
        "Grounded", "Expansive", "Focused", "Dreamy", "Energized"
    ]

    private static let transitOverview: [String: [String]] = [
        "daily": [
            "Today carries a potent energetic charge that invites you to act on what you have been hesitating to initiate. The planets align in your favor for bold moves and honest conversations. Trust the impulse that has been quietly building — today is the day to follow it.",
            "A reflective energy pervades the day, drawing you inward to assess recent events and recalibrate your direction. This is not a time for hasty action but for the deeper clarity that comes from stillness. What you discover in today's quiet moments will guide your decisions for days to come.",
            "Today brings a surge of creative and social energy that makes it an excellent day for collaboration and inspired expression. Ideas flow freely and connections feel meaningful. Follow the threads of inspiration without overthinking — you can refine later what you create today.",
            "The energy today supports practical action on the projects and relationships that matter most to you. There is a steadiness in the cosmic weather that makes focused effort unusually productive. Set aside distractions and dedicate your attention to what genuinely deserves it.",
            "A complex energetic mixture defines today — there are both opportunities and challenges on offer, and your awareness of both is what determines the outcome. Meet the day with flexibility and a willingness to adapt your plans if circumstances shift. Your resilience today is your greatest asset.",
            "Today opens a window of unusual insight, where things that were previously unclear suddenly come into focus. Pay close attention to the thoughts and observations that arise, as they carry important information about your path forward. This is a day when listening — to yourself and to others — pays remarkable dividends."
        ],
        "weekly": [
            "This week initiates a meaningful new cycle in your life, one that may not be fully visible yet but whose effects will be felt for months to come. The cosmic currents are supportive of new beginnings, particularly in areas where you have been patient and persistent. Show up with your whole self and allow things to unfold with intention rather than force.",
            "The week ahead carries themes of integration and deepening — a time to consolidate the progress you have made recently rather than charging forward into new territory. Revisit your priorities with fresh eyes, and do not be afraid to release what no longer serves your evolving vision. The clarity that comes from this discernment will be invaluable.",
            "This week favors connection, communication, and the kinds of conversations that change the course of relationships and projects. There is a social and creative energy present that responds powerfully to engagement and enthusiasm. Reach out, share your ideas, and trust that the universe is conspiring to bring you together with the right people at the right time.",
            "A week of heightened intuition and inner knowing lies ahead, where your instincts are particularly reliable and deserve to be honored. Information that arrives this week — through dreams, chance encounters, or sudden insight — carries special significance. Trust what you know beneath the noise of logic and expectation.",
            "The week holds a productive tension between the familiar and the new, with opportunities arising at the intersection of past experience and fresh possibility. Your ability to draw on what you have learned while remaining open to being surprised is your greatest strength this week. Stay present, stay curious, and let the week teach you what it has come to teach.",
            "This is a week of significant momentum, where actions taken now have an outsized positive impact on your longer trajectory. The energy supports bold decisions and courageous conversations that you may have been postponing. What you set in motion this week has an uncommon power to shape the weeks and months that follow."
        ],
        "monthly": [
            "This month marks a genuine turning point in your journey — one of those rare periods when the efforts of the past begin to yield visible fruit and when the direction of your future begins to clarify. The cosmic conditions this month are unusually supportive of both inner work and outer accomplishment. Show up with full commitment and allow yourself to receive what you have been working toward.",
            "The month ahead invites a comprehensive review and renewal of the priorities and patterns that have been defining your daily life. What is worth keeping? What has served its purpose and is ready to be released? The clarity you gain through this honest inventory will lighten your load and sharpen your focus for the months ahead.",
            "A month of significant relational themes lies ahead, where your connections with others take center stage and teach you important things about yourself. Partnerships — romantic, professional, and social — are energized and illuminated by the planetary activity this month. Invest in your most important relationships and watch them deepen and flourish.",
            "This month supports sustained effort toward your most important long-term goals, with a steady, productive energy that rewards persistence and patience. You may not see dramatic breakthroughs overnight, but the consistent progress you make throughout the month will compound into meaningful advancement. Trust the process and honor the work.",
            "The month ahead is rich with creative and expressive potential, a time when your ideas and inspirations have unusual power and resonance. Projects begun this month carry a distinctive vitality, and the creative risks you take now are especially likely to yield rewarding results. Let yourself play, experiment, and create without the constraint of premature judgment.",
            "This month brings a profound opportunity for healing and integration — a time when old patterns and wounds are ready to be understood and released in ways that were not previously possible. The work you do on yourself this month has lasting effects. Trust the process of transformation and be gentle with yourself as you make room for something new."
        ]
    ]

    private static let transitLove: [String: [String]] = [
        "daily": [
            "Today's energy invites vulnerability in your closest relationship — a small but meaningful opening toward a deeper connection. If you have been holding back a feeling or a thought, today is the day to share it gently. Authentic expression, even when imperfect, draws hearts closer.",
            "A playful, light energy enlivens your romantic life today. Do not overlook the power of simple joy and laughter to strengthen the bonds between you and someone special. Today is less about grand gestures and more about the small delights that constitute a genuinely happy partnership.",
            "Today's planetary energy may bring a relationship challenge to the surface — one that, if met with honesty and compassion, can lead to a meaningful breakthrough. The discomfort of honest conversation is infinitely preferable to the quiet erosion of unspoken resentments. Trust the process of clearing the air."
        ],
        "weekly": [
            "Your love life enters an expansive and enlivening phase this week, with the cosmic energy supporting both new romantic possibilities and the deepening of existing bonds. If you are in a partnership, this is an excellent time to plan something special that reconnects you to what you love most about each other. If you are single, your natural magnetism is heightened — allow yourself to be seen.",
            "This week asks you to bring greater intention and presence to your most important relationships. The daily distractions that pull you away from genuine connection are unusually resistible now, and the quality of attention you offer someone special will be deeply felt and remembered. Choose presence over productivity in your relational life this week.",
            "A week of honest relational reckoning arrives — not dramatic or destructive, but honest and ultimately clarifying. If a relationship has been carrying unspoken tension, this week provides the cosmic support for the conversation that needs to happen. Honesty, delivered with care, deepens love rather than threatening it."
        ],
        "monthly": [
            "Love is profoundly highlighted this month, with planetary activity bringing both opportunities for new connection and deepening of existing bonds. For those in relationships, a new chapter of intimacy and understanding is available if you are willing to be vulnerable and present. For those seeking love, your authentic self is your greatest attraction — let it be seen fully.",
            "This month calls for a reassessment of what you truly want and need in your relational life. Past patterns may become visible in new ways, offering the opportunity to make different, more conscious choices going forward. The work you do this month to understand your own relational patterns will pay dividends in every future partnership.",
            "A month of relational growth and healing unfolds, where both the gifts and the growing edges of your closest connections come into clear view. Be willing to have the conversations you have been avoiding, and approach those conversations with as much compassion as conviction. The love that can survive and even deepen through honest dialogue is worth fighting for."
        ]
    ]

    private static let transitCareer: [String: [String]] = [
        "daily": [
            "Today favors decisive action on a professional matter that has been awaiting your attention. Your judgment is unusually clear, and the confidence with which you make decisions today will have a positive ripple effect on your trajectory. Trust what you know and act with the authority your experience has earned.",
            "A day for strategic thinking and planning rather than execution, today invites you to step back from the immediate and consider the broader landscape of your professional life. The insights that arise from this bird's-eye perspective are more valuable than any number of tasks completed. Give yourself the gift of thinking time.",
            "Collaboration and communication are the keys to career success today. The connections you make and strengthen now — a well-crafted message, a generous offer of support, a timely follow-up — are quietly building the professional network and reputation that will serve you powerfully in the months ahead."
        ],
        "weekly": [
            "Your professional life receives a meaningful energetic boost this week, supporting visibility, recognition, and the advancement of projects that have been gaining momentum. This is a week to step forward with confidence, share your ideas in larger forums, and allow your expertise to be seen by those who matter. Your moment is here — meet it.",
            "The week supports deep, focused work on the projects and goals that are most aligned with your long-term vision. You have an unusual capacity for sustained concentration now, and the quiet, consistent effort you make this week will compound into results that exceed your expectations. Honor your focus by protecting it from unnecessary interruptions.",
            "Relationship dynamics at work take center stage this week, with opportunities to build alliances and to navigate any existing tensions with skill and diplomacy. The professional relationships you cultivate and care for now will be among your most important career assets in the months and years ahead. Invest in them with the same intention you bring to your actual work."
        ],
        "monthly": [
            "A month of significant professional momentum arrives, with the cosmic energy supporting advancement, recognition, and the kind of bold action that moves careers forward. This is not the time for modesty about your accomplishments or hesitation about your ambitions. Step into your authority, own your expertise, and let your work speak its full truth.",
            "This month calls for a comprehensive review of your professional direction and priorities. Is the path you are on still truly aligned with your deepest purpose and gifts? The honest answer to this question, however complex, is more valuable than any amount of continued effort in the wrong direction. This month offers the clarity to course-correct if needed.",
            "Collaboration and expanded professional networks define the career opportunities of this month. The people you meet, the alliances you form, and the conversations you initiate throughout this month are building something important whose full significance may not be visible until later. Approach every professional encounter with curiosity and genuine engagement."
        ]
    ]

    private static let transitHealth: [String: [String]] = [
        "daily": [
            "Today's energy calls for a renewed investment in physical vitality — even a brief, intentional movement practice will have an outsized positive effect on your energy and mood. Your body is asking to be moved and cared for. Listen to what it needs today and honor that request with kindness.",
            "Mental and emotional wellbeing deserve your primary attention today. The inner weather is complex, and giving yourself permission to feel what you are feeling — without judgment or urgency to resolve it — is itself a powerful act of self-care. Rest, reflection, and gentleness with yourself are today's most important prescriptions.",
            "A day of robust physical energy is yours to direct. Channel it into activities that build strength, stamina, or skill — anything that connects you to the aliveness in your body. The vitality available to you today is a gift; use it for something that makes you feel genuinely well and strong."
        ],
        "weekly": [
            "Health and vitality are well-supported this week, making it an excellent time to establish or reinforce habits that will serve your long-term wellbeing. The energy for discipline is available — use it to set in place the sleep, nutrition, and movement practices that, consistently maintained, become the foundation of a truly healthy life.",
            "This week invites a more nuanced attention to your body's signals and needs. Rather than pushing through fatigue or ignoring tension, practice the counter-cultural act of actually listening to what your body is telling you. The information it offers is precise and important, and acting on it now prevents larger health issues from developing.",
            "Rest and recovery are this week's most important health themes, even — especially — if that feels counterintuitive to you. The most productive thing you can do for your long-term energy and effectiveness is to allow genuine restoration. Honor your body's need for stillness and sleep without guilt."
        ],
        "monthly": [
            "This month offers a significant opportunity to establish a new level of physical and energetic wellbeing. The cosmic support for health habits is strong, making this an ideal time to begin a new wellness regimen, address a longstanding health concern, or simply commit to the basics of good self-care with renewed consistency. Your body will thank you for the attention.",
            "Mental and emotional health are the central wellness themes of this month. The inner work you do — whether through therapy, meditation, journaling, or simply creating more space for genuine rest — will have profound effects on your vitality and clarity of mind. Invest in your inner life as generously as you invest in external accomplishments.",
            "A month of renewed physical vitality and embodiment lies ahead, with the cosmic energy supporting physical expression, movement, and the kind of engaged, joyful relationship with your body that makes daily life genuinely pleasurable. Explore new forms of movement, eat with pleasure and intention, and celebrate what your physical form makes possible."
        ]
    ]

    private static let transitAdvice: [String] = [
        "The most powerful action you can take right now is to align your daily choices more precisely with your deepest values. The gap between what you truly believe and how you are actually living is where energy leaks occur. Closing that gap, even by a small margin, produces a noticeable surge of vitality and sense of purpose.",
        "Trust the information your body and intuition are providing, even when it contradicts the louder voice of rational analysis. You know more than you think you know. The quiet certainty that arises in moments of stillness is not wishful thinking — it is wisdom. Act on it.",
        "Release the need to have everything figured out before you move forward. The path clarifies as you walk it, not before. The next right step is visible if you are willing to take it, and the step after that will reveal itself in its own time. Trust the journey you are on.",
        "Invest your energy in the relationships and projects that energize you rather than deplete you. This sounds simple but requires a consistent practice of honest discernment. What fills you? What empties you? The life you most want to be living is composed primarily of the former.",
        "Allow yourself to receive support as graciously as you offer it. The self-sufficiency that has served you well can become a wall between you and the nourishment that comes through genuine connection and collaboration. Let others in. Let yourself be helped. This is not weakness; it is wisdom.",
        "The timing you have been frustrated by is not arbitrary — it is preparation. What feels like delay is often the universe ensuring that you arrive at the right opportunity with exactly the readiness required. Use the waiting time to become the person who is worthy of what you are waiting for.",
        "Give yourself full permission to want what you want. The dreams that feel too big or too vulnerable to speak aloud are often the most important ones — the ones that, if pursued, will define the most meaningful chapter of your life. Speak them, gently at first, and watch them begin to take shape.",
        "The obstacle you are facing is not an indication that you are on the wrong path — it is an invitation to grow into the person who can navigate this kind of challenge with skill and grace. Everything you need to move through this difficulty is already within you. Trust your resources.",
        "Simplify. The complexity that has accumulated in your schedule, your commitments, and perhaps your thinking is obscuring what matters most. The path forward is often clearer than it appears — it just requires the courage to say no to the things that have been crowding out your most important yes.",
        "This is a time to honor how far you have come rather than focusing exclusively on how far you have yet to go. The perspective gained from acknowledging your progress is not complacency — it is the sustainable fuel that makes continued growth possible. Celebrate yourself, genuinely and without reservation."
    ]
}
