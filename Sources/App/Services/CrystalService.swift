import Foundation

enum CrystalService {

    static let allCrystals: [Crystal] = [
        Crystal(
            name: "Amethyst",
            description: "A violet variety of quartz prized for its beauty and legendary powers to stimulate and soothe the mind and emotions.",
            properties: CrystalProperties(
                healing: ["Relieves stress and tension", "Supports restful sleep", "Eases headaches and migraines", "Boosts immune system"],
                emotional: ["Calms anxiety and fear", "Promotes emotional centering", "Encourages self-reflection", "Aids in grief and loss"],
                spiritual: ["Enhances intuition and psychic abilities", "Deepens meditation", "Connects to higher consciousness", "Provides spiritual protection"]
            ),
            chakraAssociations: ["Third Eye", "Crown"],
            zodiacAssociations: ["Pisces", "Virgo", "Aquarius", "Capricorn"],
            element: "Air",
            hardness: "7",
            color: "Purple to violet",
            cleansingMethods: ["Moonlight", "Sage smudging", "Selenite charging plate", "Sound healing"]
        ),
        Crystal(
            name: "Clear Quartz",
            description: "Known as the master healer, clear quartz amplifies energy and intention, and is the most versatile healing stone in the mineral kingdom.",
            properties: CrystalProperties(
                healing: ["Amplifies the energy of other crystals", "Boosts the immune system", "Balances and revitalizes physical body", "Enhances metabolism"],
                emotional: ["Brings clarity of thought", "Amplifies intentions", "Dissolves karmic seeds", "Enhances perception and understanding"],
                spiritual: ["Raises energy to the highest level", "Connects to higher self", "Amplifies psychic abilities", "Attunes to spiritual purpose"]
            ),
            chakraAssociations: ["All chakras", "Crown"],
            zodiacAssociations: ["All signs", "Leo", "Capricorn"],
            element: "All",
            hardness: "7",
            color: "Clear, white",
            cleansingMethods: ["Running water", "Sunlight", "Moonlight", "Sound healing", "Earth burial"]
        ),
        Crystal(
            name: "Rose Quartz",
            description: "The stone of unconditional love and infinite peace, Rose Quartz is the most important crystal for the heart and heart chakra.",
            properties: CrystalProperties(
                healing: ["Supports heart health", "Aids in fertility", "Soothes burns and blistering", "Improves skin complexion"],
                emotional: ["Attracts love and romance", "Deepens existing relationships", "Promotes self-love and self-worth", "Heals emotional wounds"],
                spiritual: ["Opens the heart to all forms of love", "Teaches the true essence of love", "Deepens empathy and compassion", "Attunes to the energy of love"]
            ),
            chakraAssociations: ["Heart"],
            zodiacAssociations: ["Taurus", "Libra"],
            element: "Water",
            hardness: "7",
            color: "Soft pink to deep rose",
            cleansingMethods: ["Moonlight", "Sage smudging", "Sound healing", "Running water"]
        ),
        Crystal(
            name: "Black Tourmaline",
            description: "One of the most powerful protection stones, Black Tourmaline creates an energetic shield against negative energy and psychic attacks.",
            properties: CrystalProperties(
                healing: ["Strengthens immune system", "Provides pain relief", "Supports detoxification", "Improves circulation"],
                emotional: ["Dispels negative thoughts", "Reduces anxiety and fear", "Creates a sense of safety", "Promotes positive thinking"],
                spiritual: ["Powerful psychic protection", "Grounds spiritual energy into the body", "Repels negative entities", "Creates a protective shield"]
            ),
            chakraAssociations: ["Root"],
            zodiacAssociations: ["Capricorn", "Scorpio"],
            element: "Earth",
            hardness: "7-7.5",
            color: "Black",
            cleansingMethods: ["Sunlight", "Smudging", "Running water", "Sound healing"]
        ),
        Crystal(
            name: "Citrine",
            description: "A powerful cleanser and regenerator carrying the power of the sun. Citrine is warming, energizing, and highly creative.",
            properties: CrystalProperties(
                healing: ["Energizes and invigorates", "Aids digestive system", "Supports metabolism", "Helps with chronic fatigue"],
                emotional: ["Raises self-esteem and confidence", "Releases negative traits", "Promotes motivation and creativity", "Attracts joy and abundance"],
                spiritual: ["Raises spiritual energy", "Attracts wealth and prosperity", "Activates crown chakra", "Enhances visualization and manifestation"]
            ),
            chakraAssociations: ["Solar Plexus", "Sacral", "Crown"],
            zodiacAssociations: ["Aries", "Gemini", "Leo", "Libra"],
            element: "Fire",
            hardness: "7",
            color: "Yellow to golden orange",
            cleansingMethods: ["Moonlight", "Smudging", "Sound healing"]
        ),
        Crystal(
            name: "Obsidian",
            description: "A powerful protective stone, Obsidian forms a shield against negativity and provides insight into the shadow self.",
            properties: CrystalProperties(
                healing: ["Aids in digestion", "Detoxifies the body", "Reduces pain and tension", "Supports wound healing"],
                emotional: ["Uncovers unconscious patterns", "Releases tension and stress", "Supports processing trauma", "Promotes honesty with oneself"],
                spiritual: ["Powerful protection against negativity", "Grounds spiritual energy", "Exposes shadow self", "Facilitates past life healing"]
            ),
            chakraAssociations: ["Root"],
            zodiacAssociations: ["Sagittarius", "Scorpio"],
            element: "Earth/Fire",
            hardness: "5-5.5",
            color: "Black",
            cleansingMethods: ["Smudging", "Sound healing", "Moonlight", "Earth burial"]
        ),
        Crystal(
            name: "Lapis Lazuli",
            description: "A stone of wisdom and truth, Lapis Lazuli has been used by healers, priests, and royalty throughout the ages.",
            properties: CrystalProperties(
                healing: ["Supports immune and nervous systems", "Lowers blood pressure", "Purifies blood", "Alleviates insomnia"],
                emotional: ["Brings harmony and deep inner peace", "Encourages self-awareness", "Promotes honest communication", "Reveals inner truth"],
                spiritual: ["Stimulates spiritual journey", "Activates higher mind", "Enhances psychic abilities", "Connects to spirit guides"]
            ),
            chakraAssociations: ["Third Eye", "Throat"],
            zodiacAssociations: ["Sagittarius", "Aquarius", "Pisces"],
            element: "Water/Air",
            hardness: "5-6",
            color: "Deep blue with gold flecks",
            cleansingMethods: ["Moonlight", "Smudging", "Sound healing"]
        ),
        Crystal(
            name: "Turquoise",
            description: "A purification stone that dispels negative energy and clears electromagnetic smog. A master healing stone for millennia.",
            properties: CrystalProperties(
                healing: ["Anti-inflammatory and detoxifying", "Supports respiratory system", "Aids nutrient absorption", "Enhances physical and psychic immune systems"],
                emotional: ["Promotes self-realization", "Assists creative problem-solving", "Calms the nervous system", "Stabilizes mood swings"],
                spiritual: ["Enhances communication with the physical and spiritual worlds", "Promotes spiritual attunement", "Unites earth and sky", "Protects during vision quests"]
            ),
            chakraAssociations: ["Throat", "Third Eye"],
            zodiacAssociations: ["Scorpio", "Sagittarius", "Aquarius", "Pisces"],
            element: "Earth/Air/Fire",
            hardness: "5-6",
            color: "Blue to blue-green",
            cleansingMethods: ["Moonlight", "Smudging", "Sound healing", "Selenite plate"]
        ),
        Crystal(
            name: "Malachite",
            description: "The stone of transformation, Malachite absorbs negative energies and pollutants and clears and activates the chakras.",
            properties: CrystalProperties(
                healing: ["Lowers blood pressure", "Treats asthma and arthritis", "Strengthens immune system", "Supports liver health"],
                emotional: ["Breaks unwanted ties and outworn patterns", "Encourages risk-taking", "Draws out deep feelings", "Releases inhibitions"],
                spiritual: ["Powerful transformation stone", "Facilitates deep energy clearing", "Merges with divine love", "Stimulates dreams and psychic vision"]
            ),
            chakraAssociations: ["Heart", "Solar Plexus"],
            zodiacAssociations: ["Capricorn", "Scorpio"],
            element: "Earth",
            hardness: "3.5-4",
            color: "Vivid green with banding",
            cleansingMethods: ["Smudging", "Sound healing", "Moonlight"]
        ),
        Crystal(
            name: "Carnelian",
            description: "A stabilizing stone that restores vitality and motivation. Carnelian gives courage, promotes positive life choices, and dispels apathy.",
            properties: CrystalProperties(
                healing: ["Increases fertility", "Stimulates metabolism", "Improves absorption of vitamins", "Supports lower back and joints"],
                emotional: ["Overcomes negative conditioning", "Stimulates creativity", "Promotes confidence", "Banishes emotional negativity"],
                spiritual: ["Grounds and anchors you in the present reality", "Protects against envy and resentment", "Stimulates ambition", "Promotes good fortune"]
            ),
            chakraAssociations: ["Sacral", "Root"],
            zodiacAssociations: ["Aries", "Taurus", "Cancer", "Leo"],
            element: "Fire",
            hardness: "6.5-7",
            color: "Orange to red-brown",
            cleansingMethods: ["Running water", "Sunlight", "Smudging", "Sound healing"]
        ),
        Crystal(
            name: "Sodalite",
            description: "The stone of logic and truth, Sodalite brings order and calm to the mind and encourages rational thought and objectivity.",
            properties: CrystalProperties(
                healing: ["Balances metabolism", "Boosts immune system", "Lowers blood pressure", "Treats throat disorders"],
                emotional: ["Releases mental confusion", "Enhances self-esteem", "Encourages self-acceptance", "Promotes trust and companionship"],
                spiritual: ["Deepens meditation", "Enhances psychic vision", "Stimulates pineal gland", "Brings information from the higher mind"]
            ),
            chakraAssociations: ["Throat", "Third Eye"],
            zodiacAssociations: ["Sagittarius"],
            element: "Air/Water",
            hardness: "5.5-6",
            color: "Blue with white veining",
            cleansingMethods: ["Moonlight", "Smudging", "Sound healing", "Selenite plate"]
        ),
        Crystal(
            name: "Tiger's Eye",
            description: "A stone of protection, Tiger's Eye may also bring good luck. It has the power to focus the mind, promoting mental clarity and resolving problems.",
            properties: CrystalProperties(
                healing: ["Heals eyes and throat", "Aids night vision", "Supports reproductive organs", "Strengthens spine"],
                emotional: ["Releases anxiety and fear", "Promotes courage and confidence", "Helps recognize talents", "Facilitates smooth transitions"],
                spiritual: ["Balances yin-yang energy", "Grounds and facilitates manifestation", "Enhances discernment", "Brings insight into complexity"]
            ),
            chakraAssociations: ["Sacral", "Solar Plexus", "Root"],
            zodiacAssociations: ["Capricorn", "Leo"],
            element: "Earth/Fire",
            hardness: "6.5-7",
            color: "Golden brown with shimmer",
            cleansingMethods: ["Sunlight", "Running water", "Smudging", "Sound healing"]
        ),
        Crystal(
            name: "Moonstone",
            description: "A stone of new beginnings and inner growth, Moonstone soothes emotional instability and stress and stabilizes the emotions.",
            properties: CrystalProperties(
                healing: ["Aids the digestive and reproductive systems", "Supports menstrual cycle", "Enhances fertility", "Reduces fluid retention"],
                emotional: ["Calms overreactions to situations", "Enhances intuition", "Promotes inspiration", "Brings success in love"],
                spiritual: ["Powerfully connects to moon energy", "Enhances psychic gifts", "Opens the mind to sudden and irrational impulses", "Stimulates clairvoyance"]
            ),
            chakraAssociations: ["Crown", "Third Eye", "Sacral"],
            zodiacAssociations: ["Cancer", "Libra", "Scorpio"],
            element: "Water",
            hardness: "6-6.5",
            color: "White, peach, pink, blue with adularescence",
            cleansingMethods: ["Moonlight", "Smudging", "Sound healing", "Selenite plate"]
        ),
        Crystal(
            name: "Labradorite",
            description: "A stone of transformation and magic, Labradorite is a useful companion through change, imparting strength and perseverance.",
            properties: CrystalProperties(
                healing: ["Treats disorders of the eyes and brain", "Relieves stress and anxiety", "Regulates metabolism", "Treats colds and gout"],
                emotional: ["Calms an overactive mind", "Energizes the imagination", "Brings up new ideas", "Alleviates insecurity"],
                spiritual: ["Raises consciousness and grounds spiritual energies", "Banishes fears and insecurities", "Strengthens faith in self", "Deflects unwanted energies from the aura"]
            ),
            chakraAssociations: ["Third Eye", "Crown", "Throat"],
            zodiacAssociations: ["Leo", "Scorpio", "Sagittarius"],
            element: "Water",
            hardness: "6-6.5",
            color: "Gray-black with iridescent blue/green/gold flash",
            cleansingMethods: ["Moonlight", "Smudging", "Sound healing"]
        ),
        Crystal(
            name: "Pyrite",
            description: "A stone of prosperity, Pyrite is a powerful protection stone and also shields and protects against all forms of negative vibrations.",
            properties: CrystalProperties(
                healing: ["Increases oxygen supply to the blood", "Treats bones and cellular formation", "Enhances lung capacity", "Supports male reproductive system"],
                emotional: ["Boosts self-worth and confidence", "Relieves anxiety and frustration", "Promotes positive thinking", "Enhances ambition"],
                spiritual: ["Attracts abundance and prosperity", "Enhances willpower", "Encourages ideal health and intellect", "Shields against psychic attack"]
            ),
            chakraAssociations: ["Solar Plexus"],
            zodiacAssociations: ["Leo"],
            element: "Earth/Fire",
            hardness: "6-6.5",
            color: "Metallic gold",
            cleansingMethods: ["Smudging", "Sound healing", "Selenite plate"]
        ),
        Crystal(
            name: "Selenite",
            description: "A high-vibration stone that brings clarity of mind and clears confusion. Selenite is unique in that it cleanses and charges other crystals.",
            properties: CrystalProperties(
                healing: ["Aligns the spinal column", "Promotes flexibility", "Neutralizes mercury poisoning", "Corrects deformities of the skeletal system"],
                emotional: ["Brings mental clarity", "Clears confusion and aids in seeing the deeper picture", "Promotes peace and calm", "Provides clarity of mind"],
                spiritual: ["Opens crown and higher crown chakras", "Accesses angelic consciousness", "Instills a deep peace", "Links to past lives and the future"]
            ),
            chakraAssociations: ["Crown", "Third Eye"],
            zodiacAssociations: ["Taurus", "Cancer"],
            element: "Wind",
            hardness: "2",
            color: "White, translucent",
            cleansingMethods: ["Smudging", "Sound healing", "Moonlight"]
        ),
        Crystal(
            name: "Green Aventurine",
            description: "Known as the Stone of Opportunity, Green Aventurine is thought to be the luckiest of all crystals for manifesting prosperity and wealth.",
            properties: CrystalProperties(
                healing: ["Benefits thymus gland and nervous system", "Balances blood pressure", "Stimulates metabolism", "Lowers cholesterol"],
                emotional: ["Releases old patterns", "Promotes growth and renewal", "Brings optimism", "Inspires confidence and joie de vivre"],
                spiritual: ["Reinforces leadership qualities", "Promotes compassion and empathy", "Encourages perseverance", "Enhances luck and opportunity"]
            ),
            chakraAssociations: ["Heart"],
            zodiacAssociations: ["Aries", "Leo"],
            element: "Earth",
            hardness: "6.5-7",
            color: "Green",
            cleansingMethods: ["Running water", "Moonlight", "Sunlight", "Smudging"]
        ),
        Crystal(
            name: "Aquamarine",
            description: "A stone of courage, Aquamarine calms the mind, reduces stress, and quiets the mind. Excellent for meditation and accessing higher guidance.",
            properties: CrystalProperties(
                healing: ["Treats throat, neck, and jaw issues", "Calms overreactions of the immune system", "Reduces fluid retention", "Aids eyes and vision"],
                emotional: ["Reduces fear and worry", "Calms the mind", "Helps overcome judgment", "Encourages taking responsibility for oneself"],
                spiritual: ["Stimulates, activates, and cleanses the throat chakra", "Enhances clairvoyance", "Promotes service to humanity", "Opens intuition"]
            ),
            chakraAssociations: ["Throat", "Third Eye"],
            zodiacAssociations: ["Gemini", "Pisces", "Aries"],
            element: "Water",
            hardness: "7.5-8",
            color: "Blue to blue-green",
            cleansingMethods: ["Running water", "Moonlight", "Smudging", "Sound healing"]
        ),
        Crystal(
            name: "Fluorite",
            description: "Highly protective psychically, Fluorite draws off negative energies and stress and cleanses and stabilizes the aura.",
            properties: CrystalProperties(
                healing: ["Strengthens bones and teeth", "Improves posture", "Enhances mental performance", "Treats infections and disorders of viruses"],
                emotional: ["Stabilizes emotions", "Overcomes chaos and restructures", "Improves concentration", "Dissolves illusions"],
                spiritual: ["Grounds excess energy", "Quickens spiritual awakening", "Helps you discern when outside influences are at work", "Draws off negative energies"]
            ),
            chakraAssociations: ["Third Eye", "Heart", "Crown"],
            zodiacAssociations: ["Capricorn", "Pisces"],
            element: "Air/Water",
            hardness: "4",
            color: "Purple, green, blue, clear, yellow, multi-color",
            cleansingMethods: ["Smudging", "Sound healing", "Moonlight", "Selenite plate"]
        ),
        Crystal(
            name: "Kyanite",
            description: "An exceptional stone for meditation and attunement, Kyanite will not retain negative vibrations and never needs cleansing.",
            properties: CrystalProperties(
                healing: ["Treats muscular disorders", "Relieves pain", "Lowers blood pressure", "Supports throat and voice"],
                emotional: ["Encourages speaking one's truth", "Cuts through fears and blockages", "Promotes compassion", "Bridges emotional blocks"],
                spiritual: ["Does not accumulate negative energy — never needs cleansing", "Aligns all chakras automatically", "Facilitates meditation", "Links physical, astral, and causal bodies"]
            ),
            chakraAssociations: ["Throat", "Third Eye", "All chakras"],
            zodiacAssociations: ["Aries", "Taurus", "Libra"],
            element: "Air/Storm",
            hardness: "4.5-7 (directional)",
            color: "Blue, black, green",
            cleansingMethods: ["Sound healing", "Moonlight", "Smudging"]
        ),
        Crystal(
            name: "Hematite",
            description: "Particularly effective for grounding and protecting, Hematite harmonizes mind, body, and spirit and dissolves negativity.",
            properties: CrystalProperties(
                healing: ["Supports the blood and circulatory system", "Aids iron absorption", "Treats leg cramps and anxiety", "Supports the kidneys"],
                emotional: ["Boosts self-esteem and confidence", "Overcomes compulsions", "Enhances willpower", "Imparts confidence and strength"],
                spiritual: ["Grounds and protects", "Stimulates concentration", "Enhances memory", "Brings the mind down to earth from spiritual heights"]
            ),
            chakraAssociations: ["Root"],
            zodiacAssociations: ["Aries", "Aquarius"],
            element: "Earth",
            hardness: "5.5-6.5",
            color: "Silvery-black, red-brown",
            cleansingMethods: ["Smudging", "Sound healing", "Selenite plate"]
        ),
        Crystal(
            name: "Lepidolite",
            description: "The Stone of Transition, Lepidolite assists in the release of old behavioral patterns and induces change and clearing of old energy.",
            properties: CrystalProperties(
                healing: ["Relieves stress and depression", "Treats conditions associated with mood disorders", "Aids sleep disorders", "Treats nerve pain"],
                emotional: ["Reduces stress and depression", "Halts obsessive thoughts", "Relieves despondency", "Overcomes emotional dependency"],
                spiritual: ["Brings cosmic awareness", "Facilitates astral travel", "Enhances shamanry", "Promotes calm and acceptance"]
            ),
            chakraAssociations: ["Heart", "Third Eye", "Crown"],
            zodiacAssociations: ["Libra"],
            element: "Water",
            hardness: "2.5-3",
            color: "Purple to lavender, pink",
            cleansingMethods: ["Moonlight", "Smudging", "Sound healing", "Selenite plate"]
        ),
        Crystal(
            name: "Smoky Quartz",
            description: "One of the most efficient grounding and anchoring stones, Smoky Quartz gently neutralizes negative vibrations and is detoxifying on all levels.",
            properties: CrystalProperties(
                healing: ["Relieves pain and muscle cramps", "Strengthens the back", "Treats radiation-related illness", "Aids the elimination organs"],
                emotional: ["Tolerates difficult times with equanimity", "Relieves fear, stress, and anxiety", "Manifests dreams into reality", "Teaches how to leave behind what no longer serves"],
                spiritual: ["One of the best grounding stones", "Raises vibrations during meditation", "Absorbs electromagnetic stress", "Neutralizes earth energies"]
            ),
            chakraAssociations: ["Root", "Solar Plexus"],
            zodiacAssociations: ["Capricorn", "Sagittarius"],
            element: "Earth",
            hardness: "7",
            color: "Brown to gray, translucent",
            cleansingMethods: ["Running water", "Sunlight", "Smudging", "Sound healing"]
        ),
        Crystal(
            name: "Rhodonite",
            description: "An emotional balancer that nurtures love, Rhodonite is the stone of compassion and stimulates, clears, and activates the heart.",
            properties: CrystalProperties(
                healing: ["Helps with arthritis and autoimmune diseases", "Treats stomach ulcers", "Supports emotional shock and panic", "Aids the heart"],
                emotional: ["Balances and integrates emotions", "Encourages self-love", "Heals emotional wounds and trauma", "Reconciles after arguments"],
                spiritual: ["Grounds energy and shows purpose", "Promotes service-oriented actions", "Stimulates heart energy", "Enables one to reach their highest potential"]
            ),
            chakraAssociations: ["Heart"],
            zodiacAssociations: ["Taurus", "Aries"],
            element: "Earth/Fire",
            hardness: "5.5-6.5",
            color: "Pink to rose red with black veining",
            cleansingMethods: ["Running water", "Moonlight", "Smudging", "Sound healing"]
        ),
        Crystal(
            name: "Celestite",
            description: "A high vibration stone that carries a gentle, uplifting energy. Celestite facilitates communication with the angelic realm.",
            properties: CrystalProperties(
                healing: ["Treats disorders of the eyes and ears", "Eliminates toxins", "Treats muscular spasms", "Supports thyroid gland"],
                emotional: ["Relieves stress and anxiety", "Promotes inner peace", "Instills mental calm", "Encourages emotional balance"],
                spiritual: ["Facilitates communication with the angelic realm", "Promotes purity of the heart", "Enhances dream recall and astral travel", "Connects to divine guidance"]
            ),
            chakraAssociations: ["Throat", "Third Eye", "Crown"],
            zodiacAssociations: ["Gemini", "Aries"],
            element: "Air",
            hardness: "3-3.5",
            color: "Pale blue, gray",
            cleansingMethods: ["Moonlight", "Smudging", "Sound healing", "Selenite plate"]
        )
    ]

    // MARK: - Helpers

    static func crystal(named name: String) -> Crystal? {
        let normalized = name.lowercased().replacingOccurrences(of: "-", with: " ")
        return allCrystals.first { $0.name.lowercased() == normalized }
    }

    static func crystals(forChakra chakra: String) -> [Crystal] {
        let normalized = chakra.lowercased().replacingOccurrences(of: "-", with: " ")
        return allCrystals.filter { crystal in
            crystal.chakraAssociations.contains { $0.lowercased().contains(normalized) }
        }
    }

    static func crystals(forZodiac sign: String) -> [Crystal] {
        let normalized = sign.lowercased()
        return allCrystals.filter { crystal in
            crystal.zodiacAssociations.contains { $0.lowercased().contains(normalized) }
        }
    }

    static func random() -> Crystal {
        allCrystals.randomElement()!
    }
}
