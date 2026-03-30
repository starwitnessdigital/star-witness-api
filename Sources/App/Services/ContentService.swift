import Foundation

// MARK: - Content Service

enum ContentService {

    // MARK: - Seeding Helpers

    private static func dateSeed(year: Int, month: Int, day: Int) -> Int {
        year * 10000 + month * 100 + day
    }

    /// Picks one item from `array` using `seed + offset * 7` as the index.
    /// The multiplier 7 is coprime to most array sizes, ensuring adjacent offsets
    /// yield well-distributed picks across the content pool.
    private static func pick<T>(from array: [T], seed: Int, offset: Int = 0) -> T {
        let index = abs(seed + offset * 7) % array.count
        return array[index]
    }

    /// Picks `count` distinct items from `array` deterministically using `seed`.
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

    // MARK: - Horoscope

    static func horoscope(sign: ZodiacSign, year: Int, month: Int, day: Int) -> DailyHoroscopeResponse {
        let seed = dateSeed(year: year, month: month, day: day)
        let si = sign.index  // 0–11

        let general  = pick(from: generalForecasts,    seed: seed, offset: si)
        let love     = pick(from: loveReadings,         seed: seed, offset: si + 3)
        let career   = pick(from: careerReadings,       seed: seed, offset: si + 5)
        let health   = pick(from: healthReadings,       seed: seed, offset: si + 7)
        let color    = pick(from: luckyColors,          seed: seed, offset: si + 2)
        let mood     = pick(from: moods,                seed: seed, offset: si + 4)
        let compat   = pick(from: compatibilityTips,    seed: seed, offset: si + 6)
        let luckyNum = abs(seed + si * 11) % 99 + 1

        return DailyHoroscopeResponse(
            sign: sign.rawValue,
            symbol: sign.symbol,
            date: String(format: "%04d-%02d-%02d", year, month, day),
            generalForecast: general,
            love: love,
            career: career,
            health: health,
            luckyNumber: luckyNum,
            luckyColor: color,
            mood: mood,
            compatibilityTip: compat
        )
    }

    // MARK: - Affirmations

    static let validAffirmationCategories: [String] = [
        "abundance", "self-love", "confidence", "healing",
        "motivation", "gratitude", "creativity", "relationships"
    ]

    static func affirmations(category: String, count: Int) -> [String] {
        let pool = affirmationPools[category] ?? []
        return Array(pool.shuffled().prefix(count))
    }

    // MARK: - Journal Prompts

    static let validJournalThemes: [String] = [
        "reflection", "gratitude", "goals", "relationships",
        "creativity", "healing", "career", "self-discovery"
    ]

    static func journalPrompts(theme: String, count: Int) -> [String] {
        let pool = journalPromptPools[theme] ?? []
        return Array(pool.shuffled().prefix(count))
    }

    // MARK: - Daily Card

    static func dailyCard(year: Int, month: Int, day: Int) -> DailyCardResponse {
        let seed = dateSeed(year: year, month: month, day: day)

        let cardIndex     = abs(seed) % TarotService.allCards.count
        let card          = TarotService.allCards[cardIndex]
        let isReversed    = (abs(seed) % 3) == 0

        let affirmPool    = affirmationPools["abundance"]! + affirmationPools["self-love"]!
                          + affirmationPools["confidence"]! + affirmationPools["gratitude"]!
        let affirmation   = pick(from: affirmPool, seed: seed, offset: 1)

        let promptPool    = journalPromptPools["reflection"]! + journalPromptPools["self-discovery"]!
                          + journalPromptPools["gratitude"]!
        let journalPrompt = pick(from: promptPool, seed: seed, offset: 2)

        let guidances     = dailyCardGuidances
        let guidance      = pick(from: guidances, seed: seed, offset: 3)
        let personalised  = "\(card.name)\(isReversed ? " (Reversed)" : "") speaks today: \(guidance)"

        return DailyCardResponse(
            date: String(format: "%04d-%02d-%02d", year, month, day),
            card: card,
            isReversed: isReversed,
            affirmation: affirmation,
            journalPrompt: journalPrompt,
            guidance: personalised
        )
    }

    // MARK: - Meditation

    static let validMeditationThemes: [String] = [
        "calm", "sleep", "focus", "gratitude", "self-love", "morning", "energy"
    ]
    static let validMeditationDurations: [Int] = [3, 5, 10, 15]

    static func meditation(theme: String, durationMinutes: Int) -> MeditationResponse {
        guard let content = meditationScripts[theme] else {
            return meditation(theme: "calm", durationMinutes: durationMinutes)
        }
        let sections = buildMeditationSections(content: content, durationMinutes: durationMinutes)
        let fullScript = sections.map { "[\($0.title)]\n\($0.script)" }.joined(separator: "\n\n")
        return MeditationResponse(
            theme: theme,
            durationMinutes: durationMinutes,
            sections: sections,
            fullScript: fullScript
        )
    }

    private static func buildMeditationSections(
        content: MeditationContent,
        durationMinutes: Int
    ) -> [MeditationSection] {
        let totalSeconds = durationMinutes * 60
        let fixedSeconds = content.introSeconds + content.closingSeconds
        var bodySeconds  = totalSeconds - fixedSeconds

        var sections: [MeditationSection] = []
        sections.append(MeditationSection(
            title: "Opening",
            durationSeconds: content.introSeconds,
            script: content.intro
        ))

        // Add as many body sections as fit; cycle through if needed
        var remaining = bodySeconds
        var bodyIdx   = 0
        while remaining > 0 && !content.bodySections.isEmpty {
            let sec    = content.bodySections[bodyIdx % content.bodySections.count]
            let dur    = min(sec.durationSeconds, remaining)
            sections.append(MeditationSection(
                title: sec.title,
                durationSeconds: dur,
                script: sec.script
            ))
            remaining -= dur
            bodyIdx   += 1
            if bodyIdx >= content.bodySections.count * 2 { break } // safety cap
        }

        sections.append(MeditationSection(
            title: "Closing",
            durationSeconds: content.closingSeconds,
            script: content.closing
        ))
        return sections
    }

    // MARK: - Horoscope Content

    private static let generalForecasts: [String] = [
        "The cosmic winds are shifting in your favor today, bringing renewed clarity and a sense of forward momentum. Take time to reflect on recent decisions — the universe is confirming you are on the right path. An unexpected conversation could open a door you didn't know existed. Trust what feels aligned, and release what feels forced.",
        "Today carries a quiet power — the kind that builds beneath the surface before a breakthrough. Your intuition is heightened, and small signs around you carry bigger messages. Pay attention to synchronicities. This is a day for gathering your energy rather than dispersing it. Stillness is not stagnation; it is preparation.",
        "A creative surge arrives with today's energy, making this an ideal time to start something new or revisit a project you've abandoned. Your ideas are sharp and your confidence is building. Share your vision with someone you trust — their perspective will add a dimension you hadn't considered. The universe rewards bold beginnings.",
        "Tension that has been building begins to release today, like a deep exhale after holding your breath. Relationships you have been navigating with care will find smoother ground. An apology or honest conversation you've been avoiding may now feel effortless. Your vulnerability is your strength right now — lean into it.",
        "The stars align to amplify your analytical mind today. Complex problems that have stumped you recently begin to yield clear solutions. Trust your ability to organize, strategize, and execute. Others around you are looking for someone steady to follow — step into that role with confidence. Your groundedness inspires more than you know.",
        "Today brings a wave of social energy — connections made now carry long-term significance. A chance meeting or an unexpected message could set something meaningful in motion. Your charm and magnetism are at a peak; use them generously. Be open to invitations, even those that fall outside your usual comfort zone.",
        "A period of deep inner work is bearing fruit today. Patterns you have been consciously releasing finally begin to loosen their grip. Celebrate this quietly — the most profound shifts often happen without fanfare. Your commitment to growth has not gone unnoticed by the universe. More lightness is on its way to you.",
        "Financial and material matters come into focus today, offering an opportunity to review, reorganize, and realign. Small adjustments now can produce significant results over time. Resist the urge to overcomplicate — simplicity is wisdom. A resource you overlooked may prove more valuable than expected when you look at it with fresh eyes.",
        "Your emotional world is rich and full today, and honoring that depth is important. Rather than pushing feelings aside to maintain productivity, allow yourself to feel fully — this is where your creativity and insight live. Someone close to you needs your compassion today. The love you extend will return to you threefold.",
        "Adventure calls today, whether it manifests as a physical journey or an intellectual one. Your mind is expansive and hungry for new input. Say yes to learning something unfamiliar. A mentor, teacher, or wise friend could offer guidance that shifts your perspective. The bigger your vision, the more aligned the energy flowing toward you.",
        "Discipline and patience are your allies today. Progress may feel slower than you'd like, but the foundations you are building are solid and lasting. Rush nothing. Each careful step forward is creating something you will be proud of for years to come. Trust the process even when the destination feels distant.",
        "A burst of playful, spirited energy arrives today, inviting you to approach life with lightness and humor. Don't take yourself too seriously — the most creative and inspired moments often emerge when you are having fun. Laughter is healing. Share joy freely, and watch how it multiplies in every direction.",
        "Communication is highlighted today, making this an ideal time for important conversations, negotiations, or written correspondence. Your words carry extra weight and clarity. Speak your truth directly but with warmth. A misunderstanding from the past may finally find resolution through honest and open dialogue.",
        "Old cycles are completing as new ones prepare to dawn. You may feel caught between worlds today — nostalgic for what was and excited for what is coming. Honor both. Release the past with gratitude; greet the future with curiosity. The liminal space you occupy right now is sacred, even when it feels uncertain.",
        "Leadership qualities rise to the surface today, and others naturally look to you for direction. Step into that role with both confidence and humility. Your ability to inspire comes not from authority, but from authenticity. A project or collaborative effort benefits enormously from your focused attention and decisive energy right now.",
        "Spiritual sensitivity is heightened today, making this a powerful time for meditation, journaling, or any practice that connects you to your inner world. Dreams may carry meaningful messages — write them down. The veil between your conscious and unconscious mind is thin right now, offering rare insight if you are willing to look.",
        "Transformation energy courses through today — not the explosive kind, but the slow, steady alchemy of becoming. Something in you is deepening. Old identities and limited beliefs are quietly falling away, revealing a more authentic version of yourself beneath. Embrace this evolution with curiosity rather than resistance.",
        "Abundance in all its forms is available to you today. This includes not just material prosperity, but richness of connection, experience, and meaning. Open yourself to receiving — sometimes the greatest spiritual work is learning to accept what is freely offered. Say yes to good things without guilt.",
        "Your healing path takes a significant step forward today. Whether that healing is physical, emotional, or spiritual, progress is real and tangible. Be patient with your body and your process. The integration happening now runs deeper than the surface. Rest when you need to, and trust that healing is not linear.",
        "A stroke of luck or an unexpected opportunity arrives today. Remain alert and open — fortune favors the prepared mind. This is not the time for excessive caution or analysis; it is a time for trusting your instincts and moving with the current rather than against it. Something wonderful is moving toward you.",
        "Your sense of purpose is clarified today, cutting through confusion and doubt with remarkable precision. You know what matters and why. Let that clarity guide your choices and protect your energy. Say no to what doesn't serve your mission, and pour your best self into what does. Alignment feels like peace.",
        "Relationships of all kinds are blessed today with deeper understanding and greater warmth. Whether romantic, familial, or professional, the bonds you nurture now grow stronger. A gesture of appreciation goes further than you might expect. Love expressed, in even the smallest ways, is never wasted.",
        "Your ambitions are well-starred today — the energy favors bold moves toward your long-term goals. Don't wait for conditions to be perfect; they never are. Trust your preparation and take the next step. The universe rewards those who act in alignment with their dreams, even when they can't yet see the full path ahead.",
        "A reflective quality to today's energy invites you to slow down and take stock. Where have you been? Where are you going? Are the two in alignment? This is not a day for rushing forward but for ensuring your direction is true. Course corrections made now save enormous effort later. Wisdom is knowing when to pause.",
        "Innovation and original thinking are your gifts today. You may surprise yourself with ideas that feel genuinely new and exciting. Don't dismiss them for being unconventional — your uniqueness is your power. Share your vision with enthusiasm, and you will find others who are excited to join you in building something extraordinary.",
        "The energy today supports deep rest and gentle restoration. You have been giving a great deal, and the universe is inviting you to replenish. This is not laziness — it is wisdom. Honor your need for quiet and solitude without guilt. From a place of fullness, you will give and create with so much more to offer.",
        "Something you have been working toward begins to crystallize today. The effort you've invested is taking tangible form. Acknowledge this progress — celebrate even the smallest wins. Gratitude for what is already manifesting creates the magnetic field that draws more of the same toward you. You are in flow.",
        "Unexpected change arrives today, but rather than unsettling you, it opens a more interesting path than the one you were on. Stay flexible. The universe has a wider view than you do from where you stand. What looks like a detour may well be the main road. Trust the redirection.",
        "Your instincts are finely tuned today — trust them above all else. If something feels right, pursue it. If something feels off, honor that signal without needing to explain it. Your inner knowing is one of your greatest assets, and today it is particularly reliable. No justification required.",
        "The foundation you have been patiently laying is ready to support something much larger. Today marks a turning point — a quiet but significant shift from potential to momentum. What you build from here has the power to outlast you. Begin with intention. Continue with commitment. The universe is watching and responding.",
    ]

    private static let loveReadings: [String] = [
        "Venus graces your love life with warmth today. If you are partnered, express gratitude for the small things your person does — they need to hear it. If you are single, your authentic self is your greatest attractant right now. Stop performing and start being; the right connection finds the real you.",
        "A conversation you've been avoiding in your relationship becomes possible and even necessary today. Speak from the heart, not from fear. Vulnerability builds intimacy. If single, reflect on what patterns you are ready to release in your approach to love — awareness is the first step to lasting change.",
        "Romantic energy is high and playful today. Allow yourself to flirt, laugh, and enjoy the pleasures of connection without overthinking. Love does not always need to be serious to be meaningful. If in a relationship, do something spontaneous together. If single, allow yourself to enjoy the attention you receive.",
        "Boundaries in love become important today. Loving someone does not mean losing yourself in them. Healthy relationships have space, individuality, and mutual respect for each person's needs. Assert your boundaries not as walls but as the clear edges that allow you to show up fully in love.",
        "A deep emotional connection is possible today — the kind that goes beyond surface conversation. Share something real with someone you care about. Depth of feeling, when expressed honestly, is the foundation of lasting bonds. If single, invest in the relationship you have with yourself; it sets the template for everything else.",
        "Past loves or past relationship wounds may surface for acknowledgment today. This is not a regression — it is completion. Healing these old stories frees your heart for new possibilities. Be gentle with yourself as you process. What you are releasing is creating space for something genuinely better.",
        "Chemistry and attraction are heightened today. You may find yourself drawn to someone unexpectedly, or feeling a renewed spark with a long-term partner. Trust the energy between you. Don't overanalyze it — simply follow where joy and genuine connection lead, with awareness and integrity.",
        "Your need for emotional security is valid and important today. Communicate clearly with a partner about what makes you feel safe and seen. If single, ask yourself: what would it mean to feel truly secure in love? The answer reveals what you most need to cultivate within yourself first.",
        "Love requires patience today, and the universe is giving you an opportunity to practice it. A partner may be moving at a different pace than you, or a situation may not be resolving as quickly as you'd like. Trust the timing. What is meant to be will not pass you by.",
        "Your heart is open and generous today, and others feel that warmth. Generosity of spirit in love — not just romantic, but toward friends and family — creates a beautiful ripple effect. The love you give freely today returns to you multiplied in unexpected ways.",
        "A fresh perspective on a relationship challenge arrives today. What felt stuck or impossible may now have an elegant solution if you approach it from a different angle. Flexibility of heart is as important as strength of feeling. Try seeing the situation through your person's eyes.",
        "Commitment themes arise today — not necessarily proposals or contracts, but the daily recommitment to showing up for the people you love. Love is a verb. What small act of devotion can you offer today? These seemingly ordinary gestures are the substance of lasting, nourishing relationships.",
        "Independence within love is a gift you are learning to give and receive today. Neither losing yourself nor keeping yourself apart leads to true intimacy. The dance between togetherness and individuality is where real love lives. Celebrate the ways you and your partner complement rather than complete each other.",
        "An honest conversation about the future of a relationship becomes possible and important today. Where are you both headed? Are your visions aligned? These are not threatening questions — they are the ones that lead to real partnership. Approach the conversation with curiosity rather than anxiety.",
        "Your compassion and empathy are powerful in love today. A partner or loved one may be going through something they haven't fully articulated. Offer your presence rather than your solutions. Sometimes being truly seen and held is the most profound act of love there is.",
        "Forgiveness — of a partner, an ex, or yourself — is the theme of today's love energy. Holding onto hurt costs more than releasing it. This is not about condoning what hurt you; it is about freeing your heart to move forward. Release is not weakness. It is the bravest act of self-love.",
        "Joy and lightness in love are available to you today. Don't let the weight of the world crowd out the delight of connection. Laugh together. Play together. Share something silly. The relationships that can be both deep and light are the most sustaining ones.",
        "Your intuition about a romantic situation is particularly clear today. Trust what you are sensing beneath the surface. If something doesn't feel right, it probably isn't. If something feels genuinely aligned and safe, allow yourself to lean in. Your inner compass is a reliable guide in matters of the heart.",
        "Love is asking you to be brave today — to take a risk, say something real, or allow yourself to be truly seen. Courage in love is not the absence of fear; it is choosing connection despite it. The walls you've built around your heart were protective once, but now they may be keeping out the very thing you want.",
        "Today's energy invites you to love yourself as boldly as you love others. Treat yourself with the same tenderness, patience, and generosity you extend to those you care for. Self-love is not selfish — it is the source from which all healthy love flows. Fill your own cup first.",
        "Attraction and magnetism are themes today. You are drawing people toward you through your authenticity and warmth. In love, this is a powerful time to be visible, social, and open to who shows up. The universe is sending people your way with purpose — remain curious about each encounter.",
        "Communication in love is especially important today. Say what you mean clearly, and listen with genuine attention. Misunderstandings that have lingered can clear up quickly when both parties choose understanding over defensiveness. Love grows in the soil of honest, compassionate dialogue.",
        "A relationship in your life is evolving, and that evolution — though sometimes uncomfortable — is healthy and necessary. Growth changes people, and allowing both yourself and your partner to change without fear is the mark of a truly mature love. Celebrate who you are each becoming.",
        "Today is an excellent day to plan something special for someone you love. The effort of thoughtful gestures — however simple — communicates volumes about how much you value the connection. Your love language, whatever it is, deserves to be expressed freely and joyfully today.",
        "Your capacity for love is deepening. You are learning what it means to love without conditions, to care without control, and to trust without guarantees. This is advanced soul work, and the universe honors you for undertaking it. The love you are becoming capable of is extraordinary.",
    ]

    private static let careerReadings: [String] = [
        "Your professional instincts are sharpened today, allowing you to spot opportunities that others might miss. Trust your read on situations, people, and timing. A calculated risk in your career — one you've been deliberating — is worth taking now. Fortune favors your prepared and attentive mind.",
        "Collaboration yields exceptional results today. Involve others in your projects and be genuinely open to their contributions. The synergy created when the right people work toward a shared goal is exponentially more powerful than individual effort. Your team, properly engaged, is your greatest asset.",
        "A conversation or meeting today has the potential to shift your professional trajectory. Prepare thoughtfully and show up fully. First impressions and lasting impressions are being made. Be clear about your vision and your value — speak with conviction about what you bring to the work you do.",
        "Creative problem-solving is your superpower today. When you encounter an obstacle — and you will — resist the conventional approach. The answer is outside the standard playbook. Your ability to think laterally and envision what others cannot see is exactly the skill the situation requires.",
        "Your work ethic and commitment are noticed and appreciated, even when it doesn't feel that way. The seeds of effort you've planted are growing beneath the surface. Stay the course and trust that results are accumulating, even when progress feels invisible. Consistency is the foundation of extraordinary achievement.",
        "A leadership moment presents itself today. You may not have the official title, but the situation calls for someone to step up, provide clarity, and move things forward. That someone is you. Lead with both competence and empathy, and you will earn respect that outlasts any formal authority.",
        "Financial review and planning pay dividends today. Look carefully at where your resources — time, money, energy — are going. Small inefficiencies compound over time. Small optimizations also compound over time. Choose where your effort flows with increasing precision, and watch your results improve accordingly.",
        "A mentor, senior colleague, or trusted advisor has wisdom worth seeking out today. Don't let pride or independence prevent you from accepting guidance. The most successful people know that growth requires both self-reliance and the humility to learn from those who have walked further ahead.",
        "Your reputation for reliability and quality is your most valuable professional asset. Guard it with the care you would a precious resource. The standard you hold yourself to today either reinforces or erodes the trust others have placed in you. Excellence is not a destination — it is a daily practice.",
        "New skills or knowledge you've been acquiring begin to bear fruit in practical ways today. The investment in your own development is one of the best returns available. Continue learning, growing, and expanding your capability. The professional world rewards those who never stop becoming more capable and versatile.",
        "Networking, whether formal or informal, opens meaningful doors today. A conversation at the margins of an event, an introductory email, or a reconnection with an old colleague could set something valuable in motion. Your network is your net worth — invest in it generously and authentically.",
        "A project you care about deeply deserves your full creative energy today. Don't ration your enthusiasm — pour it in. Passion is contagious, and the work you do from a place of genuine engagement shows a quality that careful or distracted effort never can. Work that comes from the heart leaves a mark.",
        "Boundaries around your time and energy become important professionally today. It is not possible to be excellent at everything simultaneously. Identify what deserves your best attention and protect that focus fiercely. Saying no to the less important is saying yes to the essential.",
        "A challenge at work is less about the obstacle itself and more about what it is revealing about your current approach. Step back and examine the bigger picture. Often what presents as a problem is actually a prompt to evolve your methods, your communication, or your perspective. The difficulty is the teacher.",
        "Recognition or acknowledgment may come your way today, or you may be in a position to offer it to others. In either case, honor the exchange. Being seen for good work matters deeply to human motivation. If you are in a position to acknowledge someone's contribution, do so specifically and sincerely.",
        "A long-term career vision needs revisiting today. Are you moving toward what truly excites and fulfills you, or has the path drifted toward what was simply available? This is not a criticism of where you are — it is an invitation to realign your compass. Small adjustments in direction create enormous differences in destination.",
        "Strategic patience is a professional virtue today. Some results cannot be rushed, and attempting to force them produces poor outcomes. Identify what requires your steady, patient attention and what can be accelerated. Wisdom in work is knowing which situation you are in and responding accordingly.",
        "Innovation is rewarded today — the status quo is not the only option. If you have been holding back a new idea or approach because it felt unconventional, today is the day to voice it. Organizations and careers evolve through people who challenge convention with intelligence and purpose.",
        "Your communication style is particularly effective today. Whether writing, presenting, or in one-on-one conversation, your words land with clarity and impact. Use this heightened ability intentionally. The proposal you write, the message you send, the conversation you initiate — all of these carry extra weight and influence right now.",
        "Discipline and follow-through are the themes of today's career energy. The ideas are already there; what matters now is execution. Break the next step down into its smallest components and begin. Momentum builds from action, however small. The gap between good intentions and real results is bridged by consistent daily effort.",
        "Your professional intuition about a colleague, project, or opportunity is worth heeding today. Not all data is quantifiable, and your felt sense of situations — developed through experience — is a legitimate and valuable input into your decisions. Trust the signal beneath the noise.",
        "A shift in your professional environment — team changes, new responsibilities, or shifting priorities — presents itself as an opportunity rather than a disruption. Those who adapt quickly and positively to change are the ones who thrive in evolving organizations. Embrace the new chapter with flexibility and curiosity.",
        "The effort you invest in developing genuine relationships with colleagues and clients pays compound returns. People work harder for and with those they genuinely like and trust. Invest in the human side of your professional world today — it is not separate from productivity; it is the foundation of it.",
        "A decision that has been pending becomes clearer today. All the information you need is already available to you; the missing ingredient has been confidence in your own analysis. Trust yourself. You have done the work, considered the factors, and your judgment is sound. Decide and move forward.",
        "Your ambition and your integrity are not in conflict today — they are aligned. The success you are building does not require compromising your values; in fact, those values are precisely what make your success meaningful and lasting. Do not let anyone convince you otherwise.",
    ]

    private static let healthReadings: [String] = [
        "Your body is asking for nourishment today — real food, clean water, and movement that feels like care rather than punishment. Listen to what it's telling you. Your physical vessel is the container for everything else you do and feel. Treat it with the reverence it deserves.",
        "Rest is medicine today. If you have been pushing hard, your body is accumulating a debt that will eventually demand repayment. Sleep longer, rest more deeply, and allow full recovery. The investment in rest today pays dividends in energy, clarity, and resilience tomorrow.",
        "Your nervous system is sensitive today and benefits greatly from calming practices. Deep breathing, a short walk in nature, or a few quiet minutes without screens can reset your entire internal state. Small doses of stillness throughout the day accumulate into profound restoration.",
        "Movement — joyful, intentional, and suited to your current state — is the medicine today. It doesn't need to be intense to be effective. A walk, some gentle stretching, or dancing in your kitchen counts. The goal is circulation, oxygen, and the natural mood elevation that comes from moving your body.",
        "Digestive and gut health comes into focus today. Pay attention to what you eat and how it makes you feel. Your gut is your second brain — its state directly influences your mood, energy, and mental clarity. Nourishing choices today create a cascade of positive effects throughout your system.",
        "Hydration is simpler and more powerful than most people acknowledge. If you are feeling foggy, low energy, or emotionally flat today, begin with water. The most basic acts of self-care are often the most effective. Commit to excellent hydration today and notice the difference it makes.",
        "The mind-body connection is particularly strong today. Your emotional state is expressing itself physically, and vice versa. Pay attention to where tension lives in your body — it is often a direct message about what is unresolved emotionally. Bodywork, yoga, or even a warm bath can help integrate both dimensions.",
        "Sleep quality is worth prioritizing tonight and every night this week. The restoration that happens during deep sleep — physical repair, emotional processing, memory consolidation — cannot be replicated by any other means. Create a wind-down ritual that prepares your nervous system for true rest.",
        "Stress management is the health theme today. Chronic low-grade stress is one of the most pervasive threats to long-term wellbeing, and its effects accumulate quietly. Identify your primary stressors and commit to one concrete action to address or limit each one. Your health depends on this work.",
        "A health habit you've been meaning to establish is well-starred to begin today. The timing supports new beginnings in self-care. Start small, stay consistent, and build gradually. Sustainable habits are built through repetition and patience, not through dramatic overhauls that don't hold.",
        "Your immune system benefits from extra support today. Prioritize sleep, quality nutrition, moderate exercise, and anything that genuinely reduces stress. These are not supplementary practices — they are the foundation of resilient health. Don't wait until you're unwell to invest in them.",
        "Mental health is physical health. The care you give to your emotional and psychological wellbeing is directly expressed in your physical vitality. Give yourself permission to prioritize both with equal seriousness. Therapy, journaling, creative expression, and community connection are all acts of physical self-care.",
        "Your energy levels are ready to support something active today. Take advantage of this natural vitality by engaging in exercise or outdoor activity that you genuinely enjoy. The endorphins generated will sustain you through the rest of the day. Move with enthusiasm while you have it.",
        "Breath is the most immediately available tool for wellbeing, and today it deserves conscious attention. Several times today, pause and take five deep, slow breaths. This simple practice lowers cortisol, improves oxygen saturation, and shifts your nervous system toward rest and repair. Do it now.",
        "Nature is the medicine that today's energy is pointing toward. Even brief time outdoors — sunlight on your skin, fresh air in your lungs, the grounding effect of walking on earth — can shift your state profoundly. We are biological creatures, and our biology is calibrated to the natural world.",
        "Your relationship with your body is worth examining today. Do you speak to yourself with kindness about your physical self? The inner narrative running about your body directly influences its wellbeing. Shift toward gratitude for what your body does and away from criticism of how it looks.",
        "Creative engagement — making art, writing, cooking, playing music — is deeply nourishing for the nervous system and immune function. It is not a luxury but a biological need. Schedule time for creative expression today and notice how it affects not just your mood but your physical energy.",
        "Social connection has measurable health benefits — reduced stress hormones, improved immune function, and significantly increased longevity. Reach out to someone whose company genuinely nourishes you today. The simple act of feeling seen and supported by another person is profoundly healing.",
        "Your body is signaling a need for gentleness today. This is not the time to push through pain, override fatigue, or demand more than you have available. Softness toward yourself — honoring your limits without self-judgment — is the most sophisticated form of self-care. Listen. Rest. Recover.",
        "Prevention is the wisest health strategy, and today's energy supports looking ahead. Schedule check-ins, address minor concerns before they grow, and invest in the habits that keep you well rather than the remedies needed when you are not. Your future self is asking for this investment today.",
    ]

    private static let luckyColors: [String] = [
        "Deep Indigo", "Emerald Green", "Rose Gold", "Midnight Blue", "Warm Amber",
        "Soft Lavender", "Forest Green", "Burnt Orange", "Dusty Rose", "Cobalt Blue",
        "Golden Yellow", "Sage Green", "Terracotta", "Ivory White", "Plum Purple",
        "Cerulean Blue", "Champagne", "Crimson Red", "Teal", "Marigold Orange",
        "Opal White", "Copper Bronze", "Slate Blue", "Blush Pink", "Jade Green",
        "Warm Peach", "Lilac", "Mossy Brown", "Sky Blue", "Vibrant Coral",
    ]

    private static let moods: [String] = [
        "Expansive", "Grounded", "Playful", "Reflective", "Inspired", "Serene",
        "Bold", "Tender", "Focused", "Magnetic", "Dreamy", "Energized",
        "Contemplative", "Joyful", "Determined", "Receptive", "Adventurous", "Peaceful",
    ]

    private static let compatibilityTips: [String] = [
        "Aries brings dynamic energy that sparks your motivation. Together, you balance each other's intensity with shared passion.",
        "Taurus grounds your wilder impulses and reminds you of beauty in the simple and enduring. Their steadiness is a gift.",
        "Gemini stimulates your mind and keeps conversation alive with curiosity and wit. Embrace their versatility today.",
        "Cancer's emotional depth and nurturing nature complement your journey perfectly right now. Allow yourself to be cared for.",
        "Leo's warmth and generosity lift your spirits and remind you to celebrate. Their presence makes everything feel more vivid.",
        "Virgo's discernment and care for detail offer exactly the grounding and precision your current energy benefits from most.",
        "Libra brings beauty, balance, and diplomacy to your interactions today. Their perspective softens edges and finds middle ground.",
        "Scorpio's depth and intensity match a part of you that craves authentic, transformative connection. Don't shy away from the depth.",
        "Sagittarius expands your vision and reminds you that adventure and meaning go hand in hand. Follow their philosophical lead.",
        "Capricorn's ambition and reliability are steadying forces that help your plans take concrete form. Trust their practical wisdom.",
        "Aquarius introduces perspective that surprises and challenges you in the best ways. Their originality ignites your own.",
        "Pisces offers intuition, compassion, and a connection to something beyond the ordinary. Let their gentle presence soften you today.",
        "Fire signs (Aries, Leo, Sagittarius) activate your courage and enthusiasm today. Seek out their company for inspiration.",
        "Earth signs (Taurus, Virgo, Capricorn) provide steadiness and practical support for your goals right now.",
        "Air signs (Gemini, Libra, Aquarius) bring mental stimulation and new ideas that spark your creativity today.",
        "Water signs (Cancer, Scorpio, Pisces) offer emotional intelligence and intuitive support for your current journey.",
        "Your opposite sign on the zodiac wheel holds the qualities that complement and complete you. Explore that polarity today.",
        "Those born in spring (Aries, Taurus, Gemini) share your sense of beginning and renewal — connect with that energy.",
        "Those born in summer (Cancer, Leo, Virgo) bring warmth and abundance to your interactions right now.",
        "Those born in autumn (Libra, Scorpio, Sagittarius) offer balance, depth, and wisdom well-suited to your current needs.",
        "Those born in winter (Capricorn, Aquarius, Pisces) carry reflection and inner strength that resonates with your path today.",
    ]

    // MARK: - Daily Card Guidances

    private static let dailyCardGuidances: [String] = [
        "Trust what is emerging. The energy moving through you today is genuine and worth following with full commitment.",
        "Release what no longer serves your highest self. Space cleared is space created for what is meant to arrive.",
        "Your intuition is your compass today. Before acting, pause and listen to what your inner knowing is saying.",
        "The courage you need already lives within you. Step toward what feels right, even if you cannot yet see the full path.",
        "Abundance is your birthright. Open your hands, your heart, and your mind to receiving what the universe is offering.",
        "Transformation is underway. Embrace the discomfort of becoming, knowing the other side holds something beautiful.",
        "Connection is the medicine. Reach toward another soul today with honesty and warmth. You are not meant to walk alone.",
        "This moment is exactly where you are supposed to be. Trust the timing, even when patience feels impossible.",
        "Your creativity is a force of nature. Give it permission to express itself without judgment or condition today.",
        "The foundation you have laid is strong. Build upon it with confidence. Your work is not in vain.",
        "Light emerges from the shadows. What you feared is losing its power. Walk forward into greater clarity and ease.",
        "Rest is sacred. Receiving is as spiritual as giving. Allow yourself to be replenished without guilt.",
        "Truth spoken with love changes everything. Be honest today — with yourself first, and then with those who need to hear it.",
        "You are more powerful than you currently believe. The evidence of your strength surrounds you if you choose to see it.",
        "New chapters deserve your full presence. Bring your whole self to what is beginning right now.",
    ]

    // MARK: - Affirmation Pools

    static let affirmationPools: [String: [String]] = [
        "abundance": [
            "I am a magnet for prosperity, and wealth flows to me easily and naturally.",
            "I deserve abundance in all its forms — financial, emotional, and spiritual.",
            "Money is a tool for good, and I use it wisely to create a life I love.",
            "Every day, I attract new opportunities for income and growth.",
            "I release all limiting beliefs about money and welcome infinite possibility.",
            "I am worthy of financial freedom and I claim it with confidence.",
            "Abundance is my natural state; I step into it fully right now.",
            "I trust the universe to provide for all my needs, always and in all ways.",
            "My income grows steadily and consistently as I align with my purpose.",
            "I am grateful for the wealth that already exists in my life, and more is coming.",
            "My mindset is my greatest asset; I think abundantly and reap abundantly.",
            "I give freely because I know the universe replenishes everything I share.",
            "Financial opportunities recognize me and come to me effortlessly.",
            "I am open to receiving wealth in expected and unexpected ways.",
            "I celebrate the prosperity of others, knowing there is more than enough for everyone.",
            "My talents and gifts create immense value in the world and are richly rewarded.",
            "I am secure, supported, and provided for in every area of my life.",
            "I make money decisions from a place of clarity, not fear.",
            "Generosity flows through me like a river and returns to me amplified.",
            "I am building a legacy of abundance that blesses my family and community.",
            "The universe conspires to bring me exactly what I need at exactly the right time.",
            "I am an excellent steward of my resources and they multiply under my care.",
            "My relationship with money is healthy, joyful, and deeply aligned with my values.",
            "Every financial challenge I have faced has made me wiser and more resilient.",
            "I live in a universe of unlimited potential, and I claim my share without apology.",
        ],
        "self-love": [
            "I am worthy of love exactly as I am, without needing to change a single thing.",
            "I honor my body, mind, and spirit with the care they deserve.",
            "I forgive myself for my imperfections and embrace my full, complex humanity.",
            "My worth is not determined by my productivity, appearance, or anyone else's opinion.",
            "I am enough. I have always been enough. I will always be enough.",
            "I treat myself with the same tenderness I would offer my dearest friend.",
            "My needs matter and I give myself permission to meet them without guilt.",
            "I celebrate my uniqueness rather than comparing myself to others.",
            "I am becoming more comfortable in my own skin every single day.",
            "I release the need for external validation; I am my own best source of affirmation.",
            "I listen to my inner voice and honor the wisdom that lives there.",
            "My past does not define me; it has shaped me into someone beautifully resilient.",
            "I choose to speak kindly to myself, even on the hardest days.",
            "I deserve rest, joy, pleasure, and ease — not as rewards, but as birthright.",
            "I am proud of how far I have come, even when the journey felt impossible.",
            "My boundaries are expressions of self-respect and those who matter will honor them.",
            "I love myself deeply and that love spills over generously to everyone around me.",
            "I am a complete human being, not a project in need of constant improvement.",
            "I allow myself to receive love, care, and abundance without resistance.",
            "Every cell in my body is infused with worthiness, vitality, and light.",
            "I release shame and embrace the full truth of who I am — beautifully, gloriously myself.",
            "I am at peace with my own presence. I am good company for myself.",
            "The relationship I have with myself is the most important relationship in my life.",
            "I nourish my soul as carefully as I nourish anything else I love.",
            "I am whole, worthy, and deeply lovable exactly as I stand here today.",
        ],
        "confidence": [
            "I walk into every room knowing I belong there.",
            "I trust my own judgment and I act on it with decisive clarity.",
            "My voice matters and I speak up for myself with conviction.",
            "I am capable, competent, and continuously growing in my abilities.",
            "Challenges make me stronger; I face them with courage and skill.",
            "I project calm authority because I know my own worth.",
            "I am not intimidated by success — I was built for it.",
            "My presence alone has a positive impact on every room I enter.",
            "I replace self-doubt with self-trust, one decision at a time.",
            "I am proud of who I am and where I am going.",
            "I take up space fully and unapologetically because I have something real to contribute.",
            "Every experience has prepared me for exactly where I stand today.",
            "I have overcome every obstacle that has come my way, and this will be no different.",
            "My confidence is not arrogance; it is the honest acknowledgment of my own value.",
            "I speak truth and stand by it with grace and strength.",
            "I believe in my ideas and I champion them with enthusiasm and persistence.",
            "I act in spite of fear because I know that action is how confidence grows.",
            "I am a dynamic, evolving person whose best is always yet to come.",
            "I am exactly who the situation needs me to be, and I rise to meet it.",
            "Rejection and failure are data, not definitions. I keep going.",
            "I am magnetic, capable, and impossible to ignore when I show up fully.",
            "My confidence is my gift to everyone who needs someone to believe it's possible.",
            "I own my achievements with gratitude and without minimizing them.",
            "I set the standard for how I am treated by how I treat myself.",
            "I am becoming more confident every day through consistent courage and self-trust.",
        ],
        "healing": [
            "My body has an extraordinary capacity to heal and I support it with love.",
            "I release what no longer serves my wellbeing with gentleness and gratitude.",
            "Every breath I take delivers healing energy to every cell in my body.",
            "I am patient with my healing journey — it moves at exactly the right pace.",
            "I allow old wounds to surface, knowing that feeling them is how they finally release.",
            "I deserve to heal completely and I claim that healing without reservation.",
            "I trust my body's wisdom; it knows what it needs to restore wholeness.",
            "Healing is not linear, and I honor every step of my journey without judgment.",
            "I release the story that this is just how things are. I am capable of profound change.",
            "I seek the support I need without shame — healing is a collaborative act.",
            "With every passing day, I feel lighter, freer, and more at ease in my life.",
            "I forgive my body for its struggles and love it for its tremendous effort.",
            "I nourish my nervous system with rest, beauty, and gentle self-compassion.",
            "The pain I have carried is not a punishment — it is a teacher I am now graduating from.",
            "I am safe in this moment. I am held. I am healing.",
            "My healing ripples outward, making me a source of hope for others on their journey.",
            "I choose practices that honor my wholeness — physical, emotional, and spiritual.",
            "I release the urgency to be healed and embrace the grace of healing in progress.",
            "Every scar I carry is evidence of survival and deserves to be worn with honor.",
            "I am more than my diagnosis, my trauma, or my history. I am the one who continues.",
            "My healing is not a burden on others — it is an act of love for myself and everyone I touch.",
            "I create the conditions for healing: safety, nourishment, rest, and genuine connection.",
            "The universe supports my healing journey with resources I have yet to discover.",
            "I am moving toward wholeness with courage, grace, and unwavering self-compassion.",
            "I am healing right now, in ways both visible and invisible. I trust the process.",
        ],
        "motivation": [
            "I have everything I need to begin, and beginning is how everything great starts.",
            "My potential is limitless and I choose to act on it today.",
            "Progress, however small, is still progress — I celebrate each step forward.",
            "I am driven by purpose and I align my daily actions with my deepest values.",
            "Discipline is the bridge between my dreams and my reality, and I walk it every day.",
            "I do the hard things first and enjoy the satisfaction of earned momentum.",
            "I am motivated by what I am building, not what I am avoiding.",
            "Every morning is a new invitation to become more of who I am meant to be.",
            "I show up fully even on the days when motivation feels distant. Action creates momentum.",
            "The results I want require the effort I've been saving. I invest it fully today.",
            "I replace excuses with accountability and watch my life transform accordingly.",
            "I am surrounded by evidence that consistency and effort create remarkable things.",
            "I pursue my goals with the patience of someone who knows they will succeed.",
            "I turn obstacles into stepping stones because I refuse to let anything stop me.",
            "My dreams are worth every sacrifice, every early morning, every difficult choice.",
            "I commit to my vision before I feel ready, because readiness is built through action.",
            "I inspire others through the dedication with which I pursue my own path.",
            "Every challenge I face is building the strength I need for what comes next.",
            "I am relentless in the best possible way — persistent, adaptable, and purpose-driven.",
            "Today I do what others won't so that tomorrow I can live what others can't.",
            "My discipline is an act of love for my future self. I take it seriously.",
            "I celebrate small wins because they are the building blocks of the biggest victories.",
            "I am energized by possibility and fueled by the knowledge that I can make it happen.",
            "I choose action over perfection and momentum over waiting for the perfect moment.",
            "The version of me I am becoming is worth every ounce of effort I put in today.",
        ],
        "gratitude": [
            "I am grateful for the gift of this day and all the possibilities it contains.",
            "Gratitude is the lens through which I see the beauty hidden in ordinary moments.",
            "I appreciate the people in my life who love me, challenge me, and cheer me on.",
            "I am thankful for my body and all it does for me without being asked.",
            "Every experience — difficult and joyful alike — has shaped the strength I carry today.",
            "I find reasons to be grateful even on the hardest days because they always exist.",
            "I am grateful for the abundance of food, warmth, and safety that so many lack.",
            "The gift of another day is not a small thing — I treat it with reverence.",
            "I am thankful for my curious mind and its capacity to learn, grow, and wonder.",
            "Gratitude transforms my perspective from what is missing to what is magnificently present.",
            "I am grateful for the challenges that have forged my resilience and deepened my wisdom.",
            "Every sunset reminds me to be grateful for the beauty woven into this existence.",
            "I appreciate the small pleasures — morning coffee, a kind word, a moment of quiet.",
            "Gratitude fills me to the point of overflowing and I share that overflow generously.",
            "I am thankful for every person who believed in me before I believed in myself.",
            "My heart is a garden of thankfulness and gratitude is the light that makes it grow.",
            "I am grateful for the lessons hidden inside my mistakes — they are my greatest teachers.",
            "Thank you for this breath. For this heartbeat. For this one precious life.",
            "I cultivate gratitude as a daily practice and watch it multiply into abundance.",
            "I am grateful for the version of me that kept going when stopping felt easier.",
            "Appreciation for what I have creates the fertile ground for more blessings to arrive.",
            "I express gratitude to those around me and witness how it transforms our connection.",
            "I am grateful for seasons of rest that prepare me for seasons of growth.",
            "The universe has given me exactly what I needed, even when it didn't look like what I wanted.",
            "My gratitude practice is my daily act of reverence for the extraordinary gift of existence.",
        ],
        "creativity": [
            "I am a channel for creative expression and I allow ideas to move through me freely.",
            "My creativity is unique, valuable, and the world needs what only I can offer.",
            "I give myself permission to make imperfect art and to grow through the making.",
            "Creativity is not a talent I have or lack — it is a practice I commit to daily.",
            "I approach every problem with the curiosity and openness of a creative mind.",
            "My imagination is boundless and my ability to bring ideas to life is expanding.",
            "I create without censoring myself — the inner critic has no power over my flow.",
            "Every creative risk I take teaches me something that makes my work richer.",
            "I am inspired by the world around me; beauty and meaning are everywhere I look.",
            "My creative voice is distinctive and worthy of being heard, seen, and shared.",
            "I play with ideas the way a child plays — freely, joyfully, without preconceived limits.",
            "I show up to my creative practice even when inspiration is quiet; showing up is enough.",
            "Collaboration expands my creativity in ways that solo work cannot — I seek it out.",
            "I release comparison and trust that my creative path is exactly right for me.",
            "My creations are not just products — they are expressions of my deepest self.",
            "I am a maker, a builder, a dreamer who brings visions into tangible reality.",
            "Every creative block contains the seed of a breakthrough. I stay curious and keep going.",
            "I honor the creative process in all its messy, non-linear, surprising glory.",
            "My best work is ahead of me and I am excited to discover what it will become.",
            "I nourish my creativity with beauty, rest, new experiences, and generous wonder.",
            "I trust my creative instincts even when I cannot yet explain them rationally.",
            "The world is richer for my creative contributions and I give them with open hands.",
            "I celebrate the creativity of others and know that their success makes space for mine.",
            "I am a creative force who makes meaning, finds beauty, and leaves the world more interesting.",
            "Every creative act I take is an act of courage and I honor myself for taking it.",
        ],
        "relationships": [
            "I attract relationships that are grounded in mutual respect, honesty, and genuine care.",
            "I give love freely and I receive it with equal grace and openness.",
            "I communicate my needs clearly and trust that those who love me want to know them.",
            "I release the need to control outcomes in relationships and trust the natural flow.",
            "I am worthy of deep, nourishing, soul-level connection and I claim it.",
            "I set boundaries from a place of self-love, not fear, and they make my relationships stronger.",
            "I forgive those who have hurt me — not for their benefit, but for my own freedom.",
            "I choose relationships that uplift, inspire, and bring out the best in me.",
            "I am a generous friend, a loving partner, and a supportive presence in every relationship.",
            "I release people who are no longer aligned with my growth, with love and gratitude.",
            "Vulnerability is the doorway to intimacy and I walk through it with trust and courage.",
            "I attract people who value authenticity and who show up with their whole, honest selves.",
            "Every relationship in my life teaches me something essential about love and myself.",
            "I invest time and presence in the relationships that matter most and they thrive because of it.",
            "I am a safe harbor for the people I love — reliable, honest, and genuinely caring.",
            "I choose connection over the comfort of isolation, even when it feels risky.",
            "I heal old relationship patterns and create new ones built on health and mutual growth.",
            "I express appreciation to those I love openly, specifically, and often.",
            "I am surrounded by people who genuinely love and support me on my journey.",
            "The love I have given and received has made me who I am — and who I am is beautiful.",
            "I resolve conflict with grace, directness, and a genuine desire for understanding.",
            "I am learning to love better every day — with more patience, depth, and wisdom.",
            "My relationships are mirrors that reveal my greatest strengths and my deepest growth edges.",
            "I create space in my relationships for both closeness and individuality — and both thrive.",
            "Love is the most powerful force in my life and I allow it to guide every interaction.",
        ],
    ]

    // MARK: - Journal Prompt Pools

    static let journalPromptPools: [String: [String]] = [
        "reflection": [
            "What is one truth about yourself that you have been avoiding? What would shift if you fully accepted it?",
            "Describe a moment in the last month when you felt genuinely proud of yourself. What made it significant?",
            "What patterns keep appearing in your life? What do you think they are trying to teach you?",
            "If you could go back and give your younger self one piece of advice, what would it be and why?",
            "How have your values shifted in the last five years? Which new values feel most true to who you are now?",
            "What does your intuition keep telling you that your rational mind keeps overriding?",
            "Describe a relationship that has significantly shaped who you are today — how has it changed you?",
            "What beliefs did you inherit from your upbringing that you are consciously choosing to revise or release?",
            "When do you feel most like yourself? What conditions create that sense of alignment?",
            "What would you do differently if you knew that failure was temporary and lessons were permanent?",
            "What is one chapter of your life you are still holding onto? What would it mean to finally let it close?",
            "List five things that are going well in your life right now that you haven't given enough credit to.",
            "What does 'living authentically' mean to you, and how closely does your daily life reflect that?",
            "Describe your relationship with rest. Do you allow yourself to truly recharge? What gets in the way?",
            "Who in your life reflects the person you are becoming? How does their presence inspire you?",
            "What is your definition of success? Has it changed from what it once was?",
            "If your future self could send you a message about this period in your life, what would it say?",
            "What are you most resistant to right now? What might that resistance be protecting or hiding?",
        ],
        "gratitude": [
            "Write about three people who have positively shaped your life without fully knowing their impact.",
            "What difficulty in your past are you now grateful for? How did it ultimately serve you?",
            "Describe your body with gratitude — list ten things it does for you that you usually overlook.",
            "What aspects of your daily routine are quiet gifts you rarely pause to appreciate?",
            "Write a letter of gratitude to your past self for surviving something that once felt unsurvivable.",
            "What simple pleasures brought you unexpected joy this week? Why do they matter?",
            "Who in your life consistently shows up for you? What would you want them to know?",
            "What privilege or advantage in your life are you most grateful for? How do you honor it?",
            "Describe a season of struggle in your life that ultimately led somewhere worthwhile.",
            "What is something about today — this specific day — that contains hidden beauty or gift?",
            "List ten things in your immediate environment that you are grateful for right now.",
            "Write about a skill or strength you have developed that once felt impossible to build.",
            "Who is a stranger or casual acquaintance whose small kindness made a real difference to you?",
            "What aspects of your culture, heritage, or community fill you with genuine pride and gratitude?",
            "How has being alive during this particular moment in history shaped you in ways you value?",
            "Write about a creative work — a book, song, film, piece of art — that changed something in you.",
            "What opportunities are currently available to you that you haven't fully appreciated?",
            "Reflect on a friendship that has surprised you with its depth and staying power. What makes it last?",
        ],
        "goals": [
            "What is the one goal that, if achieved, would make the most meaningful difference in your life right now?",
            "Describe the life you want to be living three years from today in as much sensory detail as possible.",
            "What are the three biggest obstacles between you and your most important goal? Be brutally honest.",
            "What is a goal you have been carrying for years without meaningful progress? What is actually in the way?",
            "If you were not afraid of what others thought, what goal would you be pursuing right now?",
            "What does success look like for you — not the world's definition, but your own authentic version?",
            "What are you willing to sacrifice or release in order to achieve what you want most?",
            "Describe the version of yourself who has already achieved your biggest goal. Who is that person?",
            "What daily habit, if practiced consistently for a year, would most transform your trajectory?",
            "What is one goal you set that you are proud of abandoning? What did walking away teach you?",
            "Break down your most important goal into the smallest possible next step. What is it? When will you do it?",
            "Who in your life is already living something close to your dream? What can you learn from their path?",
            "What would you pursue if you knew you could not fail? What does that reveal about your true desires?",
            "How do your current daily choices align — or not align — with the future you say you want?",
            "What goals feel exciting and alive versus which ones feel dutiful or inherited? Which deserve more energy?",
            "Write a letter from your future self, one year from now, to your present self. What is the message?",
            "What external validation are you waiting for before giving yourself permission to go after what you want?",
            "What does accountability look like for you? Who or what helps you stay committed to your own growth?",
        ],
        "relationships": [
            "Describe the qualities you most admire in the people you love. How do those qualities reflect your own values?",
            "What relationship in your life is asking for more attention, honesty, or care? What is one step you could take?",
            "Write about a conflict you handled well. What made your response constructive rather than reactive?",
            "What are your relationship patterns — the ways you consistently show up in intimate connections?",
            "Describe your friendship with yourself. Are you kind, patient, and honest with yourself as a friend?",
            "What do you need from relationships that you have been reluctant to ask for? Why is it hard to ask?",
            "Who in your life challenges you in ways that ultimately lead to growth? How do you feel about that?",
            "Write about forgiveness — someone you need to forgive, or a place where you need to forgive yourself.",
            "What does a healthy relationship look like in practice, on a regular Tuesday? Describe the specifics.",
            "What relationship from your past still occupies mental or emotional real estate? What would help you release it?",
            "How has your definition of love changed over your lifetime? What has experience taught you that theory couldn't?",
            "What is something you have never fully told someone important in your life? What would it mean to say it?",
            "Describe a time you showed up for someone in the exact way they needed. What did that require of you?",
            "What are your non-negotiable relationship values? Are the people in your life honoring them?",
            "Write about the relationship between independence and intimacy in your own life. How do you balance both?",
            "Who in your life consistently makes you feel seen, safe, and celebrated? How do you reciprocate?",
            "What relationship lessons have been the hardest won and the most transformative?",
            "How do you typically handle conflict — with avoidance, directness, or something in between? What serves you best?",
        ],
        "creativity": [
            "Describe a creative project you have been putting off. What is the real reason you haven't started?",
            "What did you love to create as a child that you have since abandoned? What would it feel like to return to it?",
            "If you could spend a full week immersed in any creative pursuit without judgment or obligation, what would it be?",
            "Describe a moment when creative expression helped you understand something about yourself or your experience.",
            "What beliefs about creativity — 'I'm not talented,' 'it has to be useful,' etc. — have limited you most?",
            "Write about someone whose creative life inspires you. What specifically do you admire about how they work?",
            "What would you create if no one would ever see it? What does that reveal about your true creative desire?",
            "Describe your relationship with the inner critic. When does it arrive, and how do you (or could you) work with it?",
            "What creative risk have you taken that surprised you with how it turned out?",
            "How does creativity show up in unexpected areas of your life — problem-solving, cooking, parenting, communication?",
            "Write about a time when someone's creative work moved you deeply. What did it touch in you?",
            "What conditions make creativity easiest for you — time of day, environment, state of mind?",
            "Describe a creative block you are currently experiencing. What might it be trying to tell you?",
            "If your creative life had a theme right now, what would it be? What is it trying to express?",
            "What would you make if resources, time, and skill were unlimited? Begin planning it here.",
            "How does play connect to creativity in your life? When did you last give yourself permission to truly play?",
            "What is one creative skill you would love to develop? What is the smallest first step toward that?",
            "Write a piece of wildly unedited stream-of-consciousness for ten minutes. What emerges?",
        ],
        "healing": [
            "Describe one wound you carry that has never fully been witnessed or held by another person. Begin here.",
            "What would it mean to fully forgive yourself for your biggest regret? What would become possible?",
            "Write to the part of you that is in pain right now. What does it need to hear from you?",
            "What does healing feel like in your body when it is happening? Can you describe the sensation?",
            "Who or what first made you feel like you weren't enough? How do you work to disprove that story daily?",
            "What are the ways you have been your own healer? Acknowledge the survival and growth you have navigated.",
            "Describe a coping mechanism you have outgrown. What healthier response are you learning to put in its place?",
            "What emotions do you find hardest to feel? What happens when you allow yourself to feel them fully?",
            "Write about the role of grief in your life — losses large and small that have asked something of you.",
            "What part of your past self is still waiting for you to return and fully acknowledge what it went through?",
            "What would it feel like to lay down the heaviest thing you are carrying? Describe that feeling in detail.",
            "How has your body communicated your emotional state to you? What has it tried to tell you through physical symptoms?",
            "Write about a moment when you chose yourself. When you drew a boundary, left something, or said no. How did it feel?",
            "What healing rituals, practices, or relationships have been most genuinely restorative for you?",
            "Describe the version of yourself that has fully healed this particular wound. Who is that person?",
            "What does being gentle with yourself actually look like in daily practice? Are you doing it?",
            "Write a letter to your pain — not to push it away, but to acknowledge what it has carried and taught you.",
            "What support do you currently need in your healing that you have been too proud or afraid to ask for?",
        ],
        "career": [
            "If money were not a factor, what work would you spend your life doing? What does that tell you?",
            "Describe your ideal workday in complete, vivid detail. How does it differ from today?",
            "What is the most meaningful contribution you have made in your professional life? Why did it matter?",
            "What skills or strengths do you have that you are not currently using in your work? What would it take to change that?",
            "What has been your biggest professional failure? What did it ultimately teach you?",
            "If you were starting your career over today, knowing what you know now, what would you do differently?",
            "What does success look and feel like for you professionally — not the standard definition, but your own?",
            "Who has been your most important mentor, teacher, or inspiration in your professional life?",
            "Describe a moment when your professional and personal values came into conflict. How did you navigate it?",
            "What are you most afraid of professionally? What would it mean to face that fear directly?",
            "What would you create, build, or contribute to your field if you knew you had enough time and support?",
            "Describe your ideal professional relationship — with a boss, client, colleague, or team. What makes it work?",
            "What work accomplishment are you most proud of that not enough people know about?",
            "How do you handle professional feedback that stings? What is your relationship with criticism?",
            "What part of your work energizes you, and what part consistently drains you? What does that data suggest?",
            "What professional risk are you currently avoiding? What would it look like to take a small step toward it?",
            "How has your career path surprised you? What unexpected turns led to something worthwhile?",
            "Write your ideal professional eulogy — what do you want to be known for having created or contributed?",
        ],
        "self-discovery": [
            "Who are you beneath all the roles you play — parent, professional, partner? Describe that essential self.",
            "What do your recurring dreams or daydreams reveal about what you most desire?",
            "Describe a version of yourself you once were that you have since grown beyond. What do you miss? What don't you?",
            "What do people consistently come to you for? What does that reveal about your natural gifts?",
            "When do you feel most fully alive? What are the common elements of those moments?",
            "What assumptions about yourself have turned out to be completely wrong? How did you discover the truth?",
            "Describe your relationship with uncertainty. Does it excite you, paralyze you, or somewhere in between?",
            "What is a conviction you hold that you have never really examined? Is it truly yours?",
            "What would the most courageous version of yourself do right now? What is stopping you from being that person?",
            "Describe a moment when you surprised yourself. What did you learn about who you really are?",
            "What aspects of your personality do you tend to hide or minimize in social situations? Why?",
            "Write about the space between who you are and who you are becoming. What is that edge asking of you?",
            "What do you envy in others that might actually be pointing toward what you yourself desire?",
            "Describe your inner child — their needs, their wounds, their joys. What do they need from you now?",
            "What values guide your life that you have never explicitly named? Name them here.",
            "How do you sabotage yourself when things are going well? What drives that pattern?",
            "What part of yourself do you judge most harshly? What would it mean to offer that part compassion?",
            "If you could know the absolute truth about one thing in your life, what would you most want to know?",
        ],
    ]

    // MARK: - Meditation Scripts

    struct MeditationBodySection {
        let title: String
        let durationSeconds: Int
        let script: String
    }

    struct MeditationContent {
        let intro: String
        let introSeconds: Int
        let bodySections: [MeditationBodySection]
        let closing: String
        let closingSeconds: Int
    }

    static let meditationScripts: [String: MeditationContent] = [
        "calm": MeditationContent(
            intro: "Find a comfortable position — seated or lying down, whichever allows your body to fully release. Close your eyes gently. Take a slow breath in through your nose, filling your lungs completely... and exhale slowly through your mouth, releasing any tension you've been holding. Again — breathe in... and out. Let your shoulders drop. Let your jaw unclench. This moment belongs to you. There is nowhere else you need to be.",
            introSeconds: 60,
            bodySections: [
                MeditationBodySection(
                    title: "Breath Awareness",
                    durationSeconds: 90,
                    script: "Begin to breathe naturally now, without controlling it. Simply observe the breath as it moves in and out. Notice the cool air entering your nostrils. Feel your chest and belly rise and fall. Your only task is to follow this breath with gentle, non-judgmental attention. When your mind wanders — and it will — simply notice that it has wandered, and gently return to the breath. No frustration. Just a quiet return. Breathe in calm... breathe out tension. Breathe in stillness... breathe out everything that has been weighing on you today."
                ),
                MeditationBodySection(
                    title: "Body Release",
                    durationSeconds: 120,
                    script: "Now let your awareness travel slowly through your body. Begin at the top of your head and feel the muscles of your scalp soften. Let that softening travel down your forehead, smoothing out any lines of concern. Your eyes relax behind closed lids. Your cheeks grow heavy. Your jaw releases fully — let your teeth part slightly. The neck and shoulders — those great holders of stress — begin to let go. Feel your arms grow heavier. Your hands open. Your chest softens with each exhale. Your belly grows warm and relaxed. Your hips, your thighs, your calves, your feet — each one releasing, one by one, into the support beneath you. You are held. You are safe. You can let go completely."
                ),
                MeditationBodySection(
                    title: "Calm Visualization",
                    durationSeconds: 120,
                    script: "Imagine yourself in a place of complete peace — perhaps a quiet beach at dusk, a sun-dappled forest clearing, or a cozy room with rain against the windows. You are entirely safe here. The air is exactly the right temperature. There is a soft sound — perhaps water, perhaps wind through leaves — that holds you in a state of deep ease. With each breath, you sink more deeply into this peaceful place. Feel the texture of where you are resting. Breathe in the air of this sanctuary. Let yourself be here completely. This peace is not borrowed — it is yours. It lives within you, always available, always waiting to be discovered again."
                ),
                MeditationBodySection(
                    title: "Deepening",
                    durationSeconds: 120,
                    script: "As you rest in this peaceful state, allow your mind to grow quieter. Thoughts may arise — let them float through like clouds passing across a still sky. You are not your thoughts. You are the awareness that observes them. Beneath all the noise, there is a part of you that is always calm, always steady, always whole. Rest in that part of yourself now. This is your natural state. Peace is not something you must create — it is something you uncover. Let the quiet expand with every breath. Deeper. Stiller. More completely at ease."
                ),
            ],
            closing: "Slowly begin to bring your awareness back to the room around you. Wiggle your fingers and toes. Take one deep, conscious breath. When you are ready, gently open your eyes. Carry this stillness with you as you move through the rest of your day. Peace is always only a breath away. You can return here whenever you need to.",
            closingSeconds: 60
        ),
        "sleep": MeditationContent(
            intro: "Settle into your bed and let your body grow completely still. Close your eyes. You have nowhere to be and nothing to do. This time belongs only to rest. Take three slow, deep breaths — each exhale longer than the inhale. Let the weight of the day dissolve from your body with each breath. Feel the mattress receiving you completely. You are safe. You are supported. Sleep is coming.",
            introSeconds: 60,
            bodySections: [
                MeditationBodySection(
                    title: "Releasing the Day",
                    durationSeconds: 90,
                    script: "Allow everything from today to begin to fade. Any conversations, any tasks, any worries — let them dissolve like fog in morning sunlight. They will all be there if you need them tomorrow. Right now, none of it matters. Breathe in... and with your exhale, let go of today. Let it be complete. You did what you could. Now it is time to rest. The night has come, and with it, permission to fully release."
                ),
                MeditationBodySection(
                    title: "Heavy Body Scan",
                    durationSeconds: 120,
                    script: "Feel how heavy your body has become. Your head sinks into the pillow as if made of warm clay. Your eyes are heavy — so pleasantly, comfortably heavy. Your jaw releases. Your neck is soft. Your shoulders are melting into the bed. Your arms are heavy... so heavy. Your chest rises and falls slowly. Your stomach is soft and warm. Your hips... your thighs... your calves... your feet. Every part of you is growing heavier, warmer, more deeply relaxed with every breath. Heavier. More still. Drifting downward into beautiful, restorative sleep."
                ),
                MeditationBodySection(
                    title: "Counting Down",
                    durationSeconds: 120,
                    script: "With each number I count, you drift ten times more deeply into sleep. Ten... feeling the comfort surrounding you completely... nine... your thoughts are fading now, becoming soft and indistinct... eight... the room is quiet, you are safe, all is well... seven... so deeply relaxed now... six... drifting... five... halfway into sleep... four... three... the world is growing distant and quiet... two... you are almost there... one... sleep is wrapping around you like a warm, soft blanket. Allow yourself to fall."
                ),
                MeditationBodySection(
                    title: "Dream Space",
                    durationSeconds: 120,
                    script: "Imagine a beautiful, peaceful place — somewhere warm and safe that feels like home to your deepest self. Perhaps it is a meadow filled with soft golden light. Perhaps it is a quiet library, candles flickering, rain against the windows. You are there now, comfortable and completely at ease. The sounds around you are soothing and rhythmic. Your mind is soft. Your breathing is slow and even. You are welcome here. This is the threshold of dreams, and beyond it lies deep, healing, restorative sleep."
                ),
            ],
            closing: "Continue breathing slowly and deeply. There is nothing more to do. Simply surrender to the warmth, the weight, the silence. Sleep is already here, carrying you gently downward. Rest well. Your body and mind will restore everything you need through the gift of this night's sleep. Good night.",
            closingSeconds: 60
        ),
        "focus": MeditationContent(
            intro: "Sit upright in a position that is alert yet comfortable. Plant your feet firmly on the floor or cross your legs beneath you. Close your eyes. Take three intentional breaths — inhale for four counts, hold for two, exhale for six. Let your mind begin to clear like a whiteboard being wiped clean. You are about to step into a state of focused clarity. Your attention is your most powerful tool. Prepare to sharpen it.",
            introSeconds: 60,
            bodySections: [
                MeditationBodySection(
                    title: "Clearing Mental Clutter",
                    durationSeconds: 90,
                    script: "Notice any thoughts currently occupying your mind. Without engaging with them, simply acknowledge their presence — yes, I see you — and gently set them aside. Imagine a corkboard in your mind where you pin each distracting thought: I'll return to this later. The project worry — pin it. The unfinished conversation — pin it. The grocery list — pin it. They are safe on the board. They will be there when you return. For now, your mind is clear. Clean. Spacious. Ready."
                ),
                MeditationBodySection(
                    title: "Sharpening Attention",
                    durationSeconds: 120,
                    script: "Bring your full attention to the point where your breath enters your nostrils. Notice the subtle sensations — the coolness of the inhale, the slight warmth of the exhale. This single point of sensation is your anchor. Each time your mind drifts — and it will — bring it back to this precise point. This practice, repeated dozens of times, is literally training your brain's focus centers. Each return is a mental pushup. You are not failing when your mind wanders; you are succeeding each time you notice and return. Keep returning. The focus is getting stronger with every breath."
                ),
                MeditationBodySection(
                    title: "Clarity Visualization",
                    durationSeconds: 120,
                    script: "Picture your mind as a clear mountain lake at dawn. The surface is perfectly still. The reflections are crisp and undistorted. This is your natural state of clarity — available to you always, beneath the noise and rush of daily thought. Let your mind settle into this stillness now. From this place of clarity, your best thinking arises. Solutions appear. Priorities become obvious. The fog lifts and you see clearly what matters and what does not. Breathe into this clarity. Let it permeate your mind and body. You are ready."
                ),
                MeditationBodySection(
                    title: "Setting Intention",
                    durationSeconds: 90,
                    script: "Now bring your primary task or goal gently into your mind — not with urgency or pressure, but with focused curiosity. What is the one most important thing your time and attention should go toward? See it clearly. Notice what feels important about it. Feel the quiet sense of purpose that comes from knowing your direction. You are aligned. Your mind is clear. Your intention is set. When you open your eyes, your best, most focused self will be ready to begin."
                ),
            ],
            closing: "Take one final deep breath and exhale completely. Slowly open your eyes. Notice the sharpness of your vision, the clarity of your mind. Carry this focused state with you. Begin your most important task within the next two minutes — before the distractions return. You are at your most clear and ready. Go.",
            closingSeconds: 60
        ),
        "gratitude": MeditationContent(
            intro: "Find a comfortable, upright position. Close your eyes. Bring one hand to your heart and feel it beating — this faithful muscle that has supported you through everything, without being asked, without demanding recognition. Take a slow breath in... and exhale with an audible sigh of release. As you settle into this moment, begin to open the door of your heart to gratitude. Not forced appreciation, but genuine recognition of what is good and true and present in your life right now.",
            introSeconds: 60,
            bodySections: [
                MeditationBodySection(
                    title: "The Body's Gifts",
                    durationSeconds: 90,
                    script: "Begin with the most immediate gift — your body. Your lungs are breathing right now without your direction. Your heart is beating. Your eyes, when open, will show you a world of color and form. Your hands can touch, create, and reach toward others. Your ears carry the music of the world to you. Even if your body is struggling in some way, it is also doing so much right. Take a moment to genuinely thank it. Breathe in gratitude for the vessel that carries you through this life. Breathe out appreciation for all the work happening within you, right now, in this very moment."
                ),
                MeditationBodySection(
                    title: "People Who Love You",
                    durationSeconds: 120,
                    script: "Bring to mind someone who loves you — a friend, family member, partner, or mentor. Let their face appear in your mind's eye. Remember a specific moment when they showed up for you, when you felt genuinely held and cared for by them. Feel the warmth of that memory in your chest. Let it spread. Think of another person who has believed in you, perhaps even before you believed in yourself. And another. You have been loved. You are being loved. Even when it doesn't feel like enough, there is love in your life that is real and sustaining. Breathe in gratitude for the people in your circle. Exhale, and send that warmth back to them."
                ),
                MeditationBodySection(
                    title: "Hidden Blessings",
                    durationSeconds: 120,
                    script: "Now expand your gratitude to the quiet gifts — the ones easy to overlook. Clean water available whenever you need it. A roof overhead. Food. A bed. Sunsets. Music. The first sip of something warm in the morning. The relief of a good laugh. The feeling of warm sunlight on skin. A moment of genuine understanding with another person. These are not small things. For billions of people throughout history, these experiences were rare or absent. You have them. Take a slow breath and let yourself feel the genuine abundance of your life, just as it is, right now in this moment."
                ),
                MeditationBodySection(
                    title: "Gratitude for Growth",
                    durationSeconds: 90,
                    script: "Finally, bring gratitude to the difficult things — the challenges that have made you wiser, the losses that have deepened your capacity for love, the failures that have redirected you toward something more authentic. These too are gifts, even if they arrived wrapped in pain. You have not been crushed by your hardest moments; you have been shaped by them. The strength, compassion, and wisdom you carry today were forged through fire. Breathe in gratitude for your own resilience. Exhale in appreciation for the person your experiences have allowed you to become."
                ),
            ],
            closing: "Place both hands on your heart. Feel the warmth there — the warmth of genuine appreciation for this life, with all its complexity and beauty. Carry this feeling with you as you open your eyes. Let it soften how you see the people around you. Let it inform the choices you make today. Gratitude is not a practice for good days alone — it is the light you bring to all days. Open your eyes when you are ready.",
            closingSeconds: 60
        ),
        "self-love": MeditationContent(
            intro: "Settle into a comfortable position and close your eyes. Place one hand gently on your heart. Feel the steady, faithful rhythm beneath your palm. This heart has loved, grieved, hoped, and persisted through everything. Today, you are going to offer love not outward, but inward — toward the one person who most needs to receive it from you. Breathe in slowly... and exhale. You are here. You are enough. You are worthy of the deepest love. Let's begin.",
            introSeconds: 60,
            bodySections: [
                MeditationBodySection(
                    title: "Compassionate Witness",
                    durationSeconds: 90,
                    script: "Imagine that you can step back and observe yourself from the outside — with the eyes of someone who loves you completely. Someone who knows every flaw, every failure, every moment of doubt — and loves you still, without reservation. Look at yourself through those eyes. See the person who is doing their best with what they have. Who carries so much and still shows up. Who has been through real difficulty and kept going. What does that person deserve? What would you want them to know? Let those words land on your own heart now. You are more than you give yourself credit for."
                ),
                MeditationBodySection(
                    title: "Loving Kindness",
                    durationSeconds: 120,
                    script: "Silently, with your full attention, offer these words to yourself: May I be happy. Say them to yourself as if speaking to someone you cherish. May I be safe. Feel the sincerity behind each phrase. May I be healthy and strong. Let these words be more than words — let them be felt intentions, offered from your heart to your whole self. May I live with ease. Notice any resistance that arises and gently breathe through it. You deserve these wishes. You deserve happiness, safety, health, and ease as much as anyone you have ever loved. Allow yourself to receive what you are offering."
                ),
                MeditationBodySection(
                    title: "The Inner Child",
                    durationSeconds: 120,
                    script: "Bring to mind an image of yourself as a young child — perhaps at five or six years old. See this little one clearly. Notice what they are wearing, the expression on their face. This child simply wants to be loved, accepted, and told they are enough. Speak to this child now — in your mind, in your heart. Tell them what they needed to hear and perhaps didn't get enough of. I love you. I'm here. You are safe. You are wonderful exactly as you are. Hold this little one. Let your adult self be the steady, loving presence this child always needed. This is the most fundamental act of self-love — reparenting ourselves with the tenderness we deserved."
                ),
                MeditationBodySection(
                    title: "Releasing Self-Judgment",
                    durationSeconds: 90,
                    script: "Bring to mind something you judge yourself harshly for — a failure, a flaw, a choice. Feel whatever arises without trying to change it. Now breathe in compassion for yourself as a human being doing your best in difficult circumstances. And exhale — let the judgment go. You are not your worst moments. You are not your worst habits. You are a whole person, worthy of the same forgiveness and compassion you would offer someone you love. With each breath, release another layer of self-criticism. Replace it, breath by breath, with understanding, forgiveness, and genuine care for yourself."
                ),
            ],
            closing: "Take a final slow breath and let it fill you completely. Hold for just a moment at the top. And release. Keep your hand on your heart as you gently open your eyes. You deserve your own love — fully, completely, without conditions. Let that truth walk with you today. Be gentle with yourself. You are doing beautifully.",
            closingSeconds: 60
        ),
        "morning": MeditationContent(
            intro: "Good morning. Take a moment to appreciate the gift of this new day — one that has never existed before and will never come again. Sit upright if you can, or simply bring alertness into your resting body. Take three deep, energizing breaths — inhale fully through your nose... and exhale completely through your mouth. Feel yourself waking: your mind sharpening, your body beginning to stir with the energy of a new beginning. Today is full of possibility. Let's meet it with intention.",
            introSeconds: 60,
            bodySections: [
                MeditationBodySection(
                    title: "Waking the Body",
                    durationSeconds: 90,
                    script: "With your next inhale, gently stretch — arms overhead, fingers spread wide, legs extended. Feel the pleasant tension of a morning stretch, and release. Breathe in and feel warmth spreading from your core to your fingertips and toes. Roll your neck gently side to side. Wiggle your fingers. Feel the circulation beginning to move. Your body is waking up, refreshed and ready from the restoration of sleep. Breathe in vitality. Breathe out any heaviness that lingers from last night. You are present. You are awake. A new day has begun and it is yours."
                ),
                MeditationBodySection(
                    title: "Setting Your Intention",
                    durationSeconds: 120,
                    script: "Before the day fills with tasks and noise, take this quiet moment to set your intention. Ask yourself: Who do I want to be today? Not what do I need to do — but who do I want to be. Choose one quality to embody: patience, courage, creativity, kindness, groundedness, joy. Let that quality become your compass for the hours ahead. When you face a choice today, when you feel pulled off center, this intention will return you to yourself. Breathe it in now — feel it in your body. This is who you are choosing to be today. Let that choice be made consciously, here, in this moment of quiet clarity."
                ),
                MeditationBodySection(
                    title: "Gratitude Opening",
                    durationSeconds: 90,
                    script: "Three things. Without reaching too far — just three simple things you are genuinely grateful for today. They can be ordinary: the warmth of your bed, a person you'll see later, your own health, a meal you're looking forward to. Let each one land in your chest as a warm glow. You already have reasons to move through today with a grateful heart. Carry them with you. Gratitude is not a passive emotion — it is an active lens that changes what you see and therefore what you experience. Begin today already in appreciation, and watch how the day responds."
                ),
                MeditationBodySection(
                    title: "Energizing Breath",
                    durationSeconds: 90,
                    script: "Take ten breaths with me — each inhale slightly deeper and more energizing than the last. Breathe in energy and possibility. Breathe out any residue of sleep, resistance, or apprehension about the day. In... and out. In... and out. Let your breath bring you fully into this morning. Feel your mind clearing. Feel your body coming alive. Feel the quiet but real excitement of a day just beginning. Everything you need for today is already within you — the strength, the wisdom, the creativity, the heart. Breathe it in. You are ready."
                ),
            ],
            closing: "Take one final energizing breath — fill your lungs completely — and release it with a sense of readiness. Open your eyes. The day is here and it is good. Carry your intention with you. Move with purpose and presence. This morning, this day, this one life — it is your extraordinary gift. Go meet it fully.",
            closingSeconds: 60
        ),
        "energy": MeditationContent(
            intro: "Find a comfortable seated position and sit tall — spine long, crown of the head rising toward the ceiling. Close your eyes. Take a deep breath in and feel your chest expand fully. Exhale completely, emptying your lungs. You are about to awaken and circulate your vital energy. Whether you are feeling depleted or already good, this practice will amplify your natural vitality and align your energy with the frequency of your highest potential. Let's begin.",
            introSeconds: 60,
            bodySections: [
                MeditationBodySection(
                    title: "Root Connection",
                    durationSeconds: 90,
                    script: "Feel the points of contact between your body and the ground or chair beneath you. Breathe down into those contact points, imagining roots extending from the base of your spine deep into the earth. With each inhale, draw up the earth's stable, sustaining energy through those roots. Feel it rising: through your feet, your legs, your pelvis, your belly, spreading through your torso. The earth is an inexhaustible source of grounding energy. You are plugged into it right now. Breathe in vitality from the earth beneath you. Feel solid. Anchored. Energized from the ground up."
                ),
                MeditationBodySection(
                    title: "Energy Circulation",
                    durationSeconds: 120,
                    script: "Now imagine a warm golden light gathering in your solar plexus — your power center, just above your navel. With each inhale, this light grows brighter and warmer. On each exhale, let it expand: up through your chest, your heart, your throat, your mind. Down through your hips, your legs, your feet. This golden energy is yours — it is the essence of your aliveness. Let it move through every part of you, clearing anything stagnant, revitalizing anything depleted. You are a living system of flowing energy. Feel it moving. Feel yourself brightening from the inside out."
                ),
                MeditationBodySection(
                    title: "Activating Breath",
                    durationSeconds: 120,
                    script: "Breathe in through your nose for four counts... hold for two... breathe out through your mouth for four counts. Again: in for four... hold... out for four. As you hold the breath at the top, feel energy gathering and building. As you release, feel it distribute throughout your entire system. Continue this rhythm on your own now. Let each cycle of breath add fuel to your internal fire. You are gathering energy with each inhale, distributing it with each exhale. Notice how your body responds — the warmth, the tingles, the aliveness rising within you. This is your natural vitality, awakened."
                ),
                MeditationBodySection(
                    title: "Radiance",
                    durationSeconds: 90,
                    script: "Take a moment to feel the full aliveness of your system. Energy moving through you. Breath flowing freely. Your body vibrant and awake. Imagine this energy extending beyond your physical form — a field of vitality surrounding you, interacting with the world around you. You carry this energy with you wherever you go. People feel it when you enter a room. It is magnetic and generous and real. You are not just a physical body — you are an energetic presence, and right now, that presence is vibrant, clear, and fully alive. Breathe in the truth of that. You are radiant."
                ),
            ],
            closing: "Take one last deep, filling breath... and release it with everything you have, emptying completely. And breathe in again — fresh, vital, alive. Open your eyes. Carry this energy into your day. Move with purpose. Speak with presence. Know that you carry within you a renewable source of vitality that is yours to access anytime. You are alive. Use it fully.",
            closingSeconds: 60
        ),
    ]
}
