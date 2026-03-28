import Vapor

/// GET /v1/moon-phase
///
/// Optional query params:
///   date — YYYY-MM-DD (defaults to today UTC)
///
/// Returns phase name, illumination %, next full moon, next new moon.
struct MoonPhaseController {
    func index(req: Request) async throws -> MoonPhaseResponse {
        let (year, month, day): (Int, Int, Int)
        if let dateStr = req.query[String.self, at: "date"],
           let parsed = dateStr.parseDate() {
            (year, month, day) = parsed
        } else {
            var cal = Calendar(identifier: .gregorian)
            cal.timeZone = TimeZone(secondsFromGMT: 0)!
            let now = Date()
            year  = cal.component(.year,  from: now)
            month = cal.component(.month, from: now)
            day   = cal.component(.day,   from: now)
        }

        let result = AstrologyCalculationService.moonPhase(year: year, month: month, day: day)

        return MoonPhaseResponse(
            date: String(format: "%04d-%02d-%02d", year, month, day),
            phase: result.phase,
            phaseEmoji: result.phaseEmoji,
            illuminationPercent: result.illuminationPercent,
            cycleDay: result.cycleDay,
            moonSign: result.moonSign,
            moonSignSymbol: result.moonSignSymbol,
            nextFullMoon: result.nextFullMoon,
            nextNewMoon: result.nextNewMoon,
            ritualSuggestion: ritualSuggestion(for: result.phase),
            energyDescription: energyDescription(for: result.phase)
        )
    }

    private func ritualSuggestion(for phase: String) -> String {
        switch phase {
        case "New Moon":        return "Set intentions, start new projects, plant seeds — literal or metaphorical."
        case "Waxing Crescent": return "Take action on intentions set at the new moon. Momentum is building."
        case "First Quarter":   return "Push through resistance. Half the cycle complete — adjust course if needed."
        case "Waxing Gibbous":  return "Refine and perfect. The full manifestation is close — sweat the details."
        case "Full Moon":       return "Celebrate, release, express. Peak energy — charge crystals, make decisions."
        case "Waning Gibbous":  return "Share gratitude and wisdom. Distribute what was gained during the cycle."
        case "Last Quarter":    return "Let go of what isn't working. Forgive, release, and create space."
        case "Waning Crescent": return "Rest, reflect, and dream. The cycle ends — surrender before the new moon."
        default:                return "Connect with lunar energy through journaling or moon gazing."
        }
    }

    private func energyDescription(for phase: String) -> String {
        switch phase {
        case "New Moon":        return "Quiet, receptive, and ripe with possibility. The best time for beginnings."
        case "Waxing Crescent": return "Emerging energy, cautious optimism. The seed is sprouting."
        case "First Quarter":   return "Decision point. Tension between old and new — take decisive action."
        case "Waxing Gibbous":  return "Building intensity. Refinement and perseverance pay off now."
        case "Full Moon":       return "Peak illumination. Emotions run high, clarity arrives, things come to fruition."
        case "Waning Gibbous":  return "Gratitude and distribution. Share your harvest with others."
        case "Last Quarter":    return "Release and forgiveness. Clear space for what comes next."
        case "Waning Crescent": return "Surrender and restoration. Let the cycle complete naturally."
        default:                return "In transition between lunar phases."
        }
    }
}

// MARK: - Response Shape

struct MoonPhaseResponse: Content {
    let date: String
    let phase: String
    let phaseEmoji: String
    let illuminationPercent: Double
    let cycleDay: Int
    let moonSign: String
    let moonSignSymbol: String
    let nextFullMoon: String
    let nextNewMoon: String
    let ritualSuggestion: String
    let energyDescription: String
}
