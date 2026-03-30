import Foundation

enum ChakraService {

    static let allChakras: [Chakra] = [
        Chakra(
            name: "Root",
            sanskritName: "Muladhara",
            number: 1,
            location: "Base of the spine, tailbone area",
            color: "Red",
            element: "Earth",
            purpose: "Survival, safety, and the foundation of all energy. Governs our most basic needs and sense of security.",
            balancedTraits: [
                "Feeling safe and secure",
                "Grounded and present",
                "Financial stability",
                "Strong physical vitality",
                "Trust in life and in others"
            ],
            imbalancedTraits: [
                "Anxiety and fear",
                "Financial insecurity",
                "Disconnection from the body",
                "Aggression or hypervigilance",
                "Digestive issues and lower back pain"
            ],
            associatedCrystals: ["Black Tourmaline", "Hematite", "Obsidian", "Smoky Quartz", "Carnelian", "Red Jasper"],
            healingPractices: [
                "Walking barefoot on earth or grass (earthing)",
                "Yoga poses: Mountain, Tree, Warrior I",
                "Physical exercise and movement",
                "Spending time in nature",
                "Eating root vegetables",
                "Breathwork and body scan meditations"
            ],
            affirmations: [
                "I am safe and secure.",
                "I am grounded, stable, and connected to the earth.",
                "I have everything I need.",
                "The earth supports me and I trust in life.",
                "I am worthy of all things good."
            ],
            foods: ["Red foods: strawberries, tomatoes, red peppers", "Root vegetables: carrots, beets, radishes, potatoes", "Protein-rich foods: meat, eggs, legumes", "Grounding spices: ginger, garlic, turmeric"]
        ),
        Chakra(
            name: "Sacral",
            sanskritName: "Svadhisthana",
            number: 2,
            location: "Lower abdomen, about two inches below the navel",
            color: "Orange",
            element: "Water",
            purpose: "Creativity, pleasure, sensuality, and emotional well-being. The center of passion and connection.",
            balancedTraits: [
                "Creative and inspired",
                "Emotionally fluid and adaptable",
                "Healthy sexuality and sensuality",
                "Joyful and playful",
                "Able to feel and express emotions freely"
            ],
            imbalancedTraits: [
                "Creative blocks",
                "Emotional instability or numbness",
                "Unhealthy relationship with pleasure",
                "Guilt or shame around sexuality",
                "Lower back pain, hip issues"
            ],
            associatedCrystals: ["Carnelian", "Orange Calcite", "Tiger's Eye", "Moonstone", "Sunstone", "Citrine"],
            healingPractices: [
                "Creative expression: art, dance, music, writing",
                "Yoga poses: Hip openers, Cobra, Seated Forward Bend",
                "Swimming or spending time near water",
                "Journaling about emotions and desires",
                "Sensual practices and healthy pleasure",
                "Womb healing meditations"
            ],
            affirmations: [
                "I embrace and celebrate my sexuality.",
                "I am creative, passionate, and inspired.",
                "I allow myself to experience pleasure.",
                "My emotions flow freely and I express them with ease.",
                "I am worthy of love and joy."
            ],
            foods: ["Orange foods: oranges, mangoes, peaches, carrots", "Sweet fruits: melon, coconut, passion fruit", "Cinnamon, vanilla", "Nuts: almonds, walnuts", "Seeds: sesame, pumpkin"]
        ),
        Chakra(
            name: "Solar Plexus",
            sanskritName: "Manipura",
            number: 3,
            location: "Upper abdomen, stomach area",
            color: "Yellow",
            element: "Fire",
            purpose: "Personal power, confidence, and self-will. The seat of identity and inner strength.",
            balancedTraits: [
                "Confident and self-assured",
                "Strong personal boundaries",
                "Decisive and action-oriented",
                "Motivated and ambitious",
                "Sense of personal authority"
            ],
            imbalancedTraits: [
                "Low self-esteem and self-doubt",
                "Need for control or power over others",
                "Inability to make decisions",
                "Digestive problems and stomach ulcers",
                "Victim mentality or aggression"
            ],
            associatedCrystals: ["Citrine", "Tiger's Eye", "Yellow Jasper", "Pyrite", "Amber", "Sunstone"],
            healingPractices: [
                "Core-strengthening exercises",
                "Yoga poses: Warrior III, Boat Pose, Sun Salutation",
                "Setting and respecting personal boundaries",
                "Working with personal goals and intentions",
                "Solar meditation: visualizing golden light at the navel",
                "Breathwork: Breath of Fire"
            ],
            affirmations: [
                "I am powerful, confident, and capable.",
                "I stand in my personal power.",
                "I am worthy of respect and love.",
                "I make clear and decisive choices.",
                "I honor my true self."
            ],
            foods: ["Yellow foods: bananas, corn, pineapple, lemons", "Grains: oats, rice, millet, spelt", "Fiber-rich foods", "Ginger, turmeric, chamomile", "Sunflower seeds, flaxseeds"]
        ),
        Chakra(
            name: "Heart",
            sanskritName: "Anahata",
            number: 4,
            location: "Center of the chest, just above the heart",
            color: "Green (and pink)",
            element: "Air",
            purpose: "Love, compassion, forgiveness, and connection. The bridge between the physical and spiritual chakras.",
            balancedTraits: [
                "Unconditional love and compassion",
                "Deep connection with others",
                "Ability to forgive and let go",
                "Empathetic and kind",
                "Healthy boundaries in relationships"
            ],
            imbalancedTraits: [
                "Difficulty giving or receiving love",
                "Jealousy and codependency",
                "Grief and loneliness",
                "Heart and lung conditions",
                "Fear of intimacy"
            ],
            associatedCrystals: ["Rose Quartz", "Green Aventurine", "Malachite", "Rhodonite", "Emerald", "Jade"],
            healingPractices: [
                "Practicing gratitude and loving-kindness meditation",
                "Yoga poses: Camel, Bridge, Wheel, Fish",
                "Spending time with loved ones",
                "Breathwork: Heart-opening pranayama",
                "Acts of service and giving",
                "Forgiveness practices and releasing old wounds"
            ],
            affirmations: [
                "I am open to giving and receiving love.",
                "I forgive myself and others.",
                "Love is my natural state.",
                "I am worthy of love.",
                "I choose compassion for myself and others."
            ],
            foods: ["Green foods: leafy greens, broccoli, kale, cucumber", "Green tea", "Herbs: basil, thyme, sage, cilantro", "Raw chocolate", "Avocado, lime"]
        ),
        Chakra(
            name: "Throat",
            sanskritName: "Vishuddha",
            number: 5,
            location: "Throat area",
            color: "Blue",
            element: "Ether (Sound)",
            purpose: "Communication, self-expression, and truth. The ability to speak and hear the truth.",
            balancedTraits: [
                "Clear and honest communication",
                "Creative self-expression",
                "Active listening",
                "Living authentically",
                "Speaking your truth with ease"
            ],
            imbalancedTraits: [
                "Difficulty expressing oneself",
                "Fear of speaking up",
                "Talking without listening",
                "Throat issues, thyroid problems",
                "Dishonesty and gossip"
            ],
            associatedCrystals: ["Aquamarine", "Turquoise", "Lapis Lazuli", "Sodalite", "Kyanite", "Celestite", "Blue Lace Agate"],
            healingPractices: [
                "Chanting, singing, and vocal toning",
                "Yoga poses: Fish, Shoulderstand, Plow, Lion's Breath",
                "Journaling and expressive writing",
                "Speaking affirmations aloud",
                "Gargling with salt water",
                "Mindful and authentic conversation"
            ],
            affirmations: [
                "I speak my truth with clarity and ease.",
                "I communicate with confidence.",
                "I am heard, seen, and understood.",
                "I express myself creatively and authentically.",
                "I speak and listen with compassion."
            ],
            foods: ["Blue and purple foods: blueberries, blackberries, figs", "Tree fruits: apples, pears, plums", "Herbal teas: chamomile, peppermint", "Honey and lemon", "Sea vegetables and sea salt"]
        ),
        Chakra(
            name: "Third Eye",
            sanskritName: "Ajna",
            number: 6,
            location: "Forehead, between the eyebrows",
            color: "Indigo",
            element: "Light",
            purpose: "Intuition, insight, and psychic vision. The seat of wisdom and inner knowing beyond the physical senses.",
            balancedTraits: [
                "Strong intuition and inner knowing",
                "Clear perception and insight",
                "Vivid imagination and visualization",
                "Access to higher wisdom",
                "Clarity in decision-making"
            ],
            imbalancedTraits: [
                "Poor intuition or ignoring gut feelings",
                "Headaches and migraines",
                "Nightmares or sleep disorders",
                "Difficulty concentrating",
                "Overthinking and lack of clarity"
            ],
            associatedCrystals: ["Amethyst", "Lapis Lazuli", "Labradorite", "Fluorite", "Sodalite", "Moonstone", "Clear Quartz"],
            healingPractices: [
                "Meditation and visualization practices",
                "Yoga poses: Child's Pose, Downward Dog, Eagle",
                "Dream journaling",
                "Limiting screen time and practicing digital detox",
                "Working with oracle or tarot cards",
                "Stargazing and moon watching"
            ],
            affirmations: [
                "I trust my intuition.",
                "I see clearly with my inner eye.",
                "I am open to divine wisdom.",
                "My intuition guides me to my highest good.",
                "I am connected to universal intelligence."
            ],
            foods: ["Purple and dark blue foods: purple grapes, blueberries, eggplant", "Cacao and dark chocolate", "Omega-3 rich foods for brain health", "Fasting and light eating for mental clarity", "Mugwort tea, lavender"]
        ),
        Chakra(
            name: "Crown",
            sanskritName: "Sahasrara",
            number: 7,
            location: "Top of the head",
            color: "Violet or white",
            element: "Thought (Cosmic Energy)",
            purpose: "Spiritual connection, enlightenment, and unity. The gateway to higher consciousness and the divine.",
            balancedTraits: [
                "Deep spiritual connection",
                "Sense of oneness with the universe",
                "Wisdom and understanding",
                "Transcendence of ego",
                "Living with purpose and meaning"
            ],
            imbalancedTraits: [
                "Spiritual disconnection or cynicism",
                "Excessive ego and closed-mindedness",
                "Confusion about life purpose",
                "Chronic headaches",
                "Disconnection from the body"
            ],
            associatedCrystals: ["Clear Quartz", "Amethyst", "Selenite", "Lepidolite", "Moonstone", "Celestite", "Diamond"],
            healingPractices: [
                "Silent meditation and mindfulness",
                "Yoga poses: Headstand, Tree Pose, Corpse Pose (Savasana)",
                "Spending time in nature under open sky",
                "Prayer and spiritual devotion",
                "Reading spiritual and philosophical texts",
                "Service to others without expectation"
            ],
            affirmations: [
                "I am connected to the divine.",
                "I am one with all that is.",
                "I trust in the universe.",
                "I am guided by a higher power.",
                "I am open to receiving divine wisdom."
            ],
            foods: ["Fasting and detox for spiritual clarity", "Clean, pure water", "Light, whole foods", "Herbal infusions: frankincense, myrrh", "Intentional, mindful eating"]
        )
    ]

    // MARK: - Helpers

    static func chakra(named name: String) -> Chakra? {
        let normalized = name.lowercased()
        return allChakras.first {
            $0.name.lowercased() == normalized ||
            $0.sanskritName.lowercased() == normalized
        }
    }

    static func crystals(forChakra chakra: Chakra) -> [Crystal] {
        CrystalService.crystals(forChakra: chakra.name)
    }
}
