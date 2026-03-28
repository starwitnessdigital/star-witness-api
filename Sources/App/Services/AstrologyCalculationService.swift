import Foundation
import Vapor

// MARK: - Astrology Calculation Service
//
// This service provides the calculation layer for the Star Witness API.
// Currently uses mock data with deterministic algorithms for demo purposes.
//
// TODO: Replace stub calculations with real Swiss Ephemeris integration:
//   1. Add dependency: .package(url: "https://github.com/ncreated/SwissEphemeris", from: "1.0.0")
//   2. Mirror SwissEphemerisCalculator.swift from the Star Witness iOS app
//   3. The SwissEphemeris Swift package requires ephemeris data files (JPL DE431)
//      bundled in the Resources/ directory — copy from the iOS app bundle.
//   4. Call JPLFileManager.setEphemerisPath() in configure.swift at startup.
//   5. Replace each calculate*() method below with SwissEphemeris Coordinate<Planet> calls.
//
// Reference: Star Witness/Star Witness/Calculations/SwissEphemerisCalculator.swift

struct AstrologyCalculationService {

    // MARK: - Julian Day

    /// Standard Julian Day Number calculation (UTC).
    /// Used as the base for all planetary position math.
    static func julianDay(year: Int, month: Int, day: Int, hour: Double = 12.0) -> Double {
        var y = year
        var m = month
        if m <= 2 {
            y -= 1
            m += 12
        }
        let a = y / 100
        let b = 2 - a + (a / 4)
        return floor(365.25 * Double(y + 4716))
             + floor(30.6001 * Double(m + 1))
             + Double(day) + Double(b) - 1524.5
             + hour / 24.0
    }

    /// Julian centuries from J2000.0
    static func julianCenturies(jd: Double) -> Double {
        (jd - 2451545.0) / 36525.0
    }

    // MARK: - Sun Sign (exact, calendar-based)

    /// Sun sign from calendar date — matches ZodiacSign.from(date:) in Star Witness.
    /// Accurate enough for sun sign determination (within ±1 day of cusp).
    ///
    /// TODO: For cusp-exact accuracy, replace with SwissEphemeris:
    ///   let coord = Coordinate<SwissEphemeris.Planet>(body: .sun, date: date)
    ///   return convertToZodiacSign(coord.tropical.sign)
    static func sunSign(year: Int, month: Int, day: Int) -> ZodiacSign {
        ZodiacSign.sunSign(month: month, day: day)
    }

    // MARK: - Planetary Positions (stub)

    /// Returns planetary positions for a given Julian Day.
    ///
    /// Currently uses simplified mean longitude approximations based on
    /// Meeus "Astronomical Algorithms" Table 31.a mean elements.
    /// Accurate to within ~2–5° for outer planets, ~1° for inner planets.
    ///
    /// TODO: Replace with SwissEphemeris calls:
    ///   let coord = Coordinate<SwissEphemeris.Planet>(body: sePlanet, date: date)
    ///   let tropical = coord.tropical
    ///   // degrees within sign: tropical.degree + tropical.minute/60 + tropical.second/3600
    static func planetaryPositions(
        year: Int, month: Int, day: Int,
        hour: Double = 12.0,
        latitude: Double? = nil, longitude: Double? = nil,
        timezoneOffset: Double = 0
    ) -> [PlanetaryPosition] {
        let utcHour = hour - timezoneOffset
        let jd = julianDay(year: year, month: month, day: day, hour: utcHour)
        let T = julianCenturies(jd: jd)

        // Mean longitudes (Meeus Table 31.a, degrees)
        let rawPositions: [(Planet, Double, Bool)] = [
            (.sun,     sunLongitude(T: T),     false),
            (.moon,    moonLongitude(T: T),     false),
            (.mercury, mercuryLongitude(T: T), isRetrograde(planet: .mercury, T: T)),
            (.venus,   venusLongitude(T: T),   isRetrograde(planet: .venus,   T: T)),
            (.mars,    marsLongitude(T: T),     isRetrograde(planet: .mars,    T: T)),
            (.jupiter, jupiterLongitude(T: T), isRetrograde(planet: .jupiter, T: T)),
            (.saturn,  saturnLongitude(T: T),  isRetrograde(planet: .saturn,  T: T)),
            (.uranus,  uranusLongitude(T: T),  isRetrograde(planet: .uranus,  T: T)),
            (.neptune, neptuneLongitude(T: T), isRetrograde(planet: .neptune, T: T)),
            (.pluto,   plutoLongitude(T: T),   isRetrograde(planet: .pluto,   T: T)),
        ]

        // TODO: Calculate real house cusps using SwissEphemeris HouseCusps when
        //       lat/lon are provided:
        //   let houses = HouseCusps(date: date, latitude: lat, longitude: lon,
        //                           houseSystem: .placidus)
        let houses = latitude != nil && longitude != nil
            ? mockHouseCusps(for: rawPositions)
            : Array(repeating: Int?.none, count: 10)

        return rawPositions.enumerated().map { i, tuple in
            let (planet, lon, retro) = tuple
            let normalized = ((lon.truncatingRemainder(dividingBy: 360)) + 360)
                .truncatingRemainder(dividingBy: 360)
            let sign = ZodiacSign.from(eclipticLongitude: normalized)
            let degreesInSign = normalized.truncatingRemainder(dividingBy: 30.0)
            return PlanetaryPosition(
                planet: planet,
                sign: sign,
                degrees: degreesInSign,
                house: houses[i],
                isRetrograde: retro
            )
        }
    }

    // MARK: - House Cusps (stub)

    /// Returns 12 house cusps for a given birth time and location.
    ///
    /// TODO: Replace with SwissEphemeris HouseCusps(date:latitude:longitude:houseSystem:)
    ///   See SwissEphemerisCalculator.calculateHouseCusps() in the iOS app.
    static func houseCusps(
        year: Int, month: Int, day: Int,
        hour: Double, latitude: Double, longitude: Double,
        timezoneOffset: Double = 0
    ) -> [HouseCusp] {
        // Simplified: ascendant approximation based on LST
        let utcHour = hour - timezoneOffset
        let jd = julianDay(year: year, month: month, day: day, hour: utcHour)
        let T = julianCenturies(jd: jd)

        // Greenwich Mean Sidereal Time (degrees)
        let gmst = (280.46061837 + 360.98564736629 * (jd - 2451545.0)
            + 0.000387933 * T * T
            - T * T * T / 38710000.0)
            .truncatingRemainder(dividingBy: 360.0)

        // Local Sidereal Time
        let lst = ((gmst + longitude) + 360).truncatingRemainder(dividingBy: 360)

        // Ascendant estimate (very simplified — TODO: use SwissEphemeris for accuracy)
        let ascendant = ((lst + 90) + 360).truncatingRemainder(dividingBy: 360)

        return (1...12).map { house in
            let cuspLon = ((ascendant + Double(house - 1) * 30) + 360)
                .truncatingRemainder(dividingBy: 360)
            let sign = ZodiacSign.from(eclipticLongitude: cuspLon)
            return HouseCusp(
                house: house,
                sign: sign.rawValue,
                signSymbol: sign.symbol,
                degrees: cuspLon.truncatingRemainder(dividingBy: 30.0)
            )
        }
    }

    // MARK: - Rising Sign (stub)

    /// Derives the Ascendant sign from house cusps.
    ///
    /// TODO: Replace with SwissEphemeris:
    ///   let houses = HouseCusps(date: date, latitude: lat, longitude: lon, houseSystem: .placidus)
    ///   return convertToZodiacSign(houses.ascendent.tropical.sign)
    static func risingSign(
        year: Int, month: Int, day: Int,
        hour: Double, latitude: Double, longitude: Double,
        timezoneOffset: Double = 0
    ) -> ZodiacSign {
        let cusps = houseCusps(
            year: year, month: month, day: day,
            hour: hour, latitude: latitude, longitude: longitude,
            timezoneOffset: timezoneOffset
        )
        return ZodiacSign(rawValue: cusps[0].sign) ?? .aries
    }

    // MARK: - Aspects

    /// Calculate aspects between a set of planetary positions.
    /// Logic mirrors AspectCalculator.swift from Star Witness.
    static func aspects(from positions: [PlanetaryPosition]) -> [PlanetaryAspect] {
        let planetOrder = Planet.allCases.map { $0.rawValue }

        // Convert to absolute ecliptic longitudes
        let longitudes: [(String, String, Double)] = positions.compactMap { pos in
            guard let sign = ZodiacSign(rawValue: pos.sign),
                  let planet = Planet(rawValue: pos.planet) else { return nil }
            let lon = Double(sign.index) * 30.0 + pos.degrees
            return (planet.rawValue, planet.symbol, lon)
        }.sorted { a, b in
            (planetOrder.firstIndex(of: a.0) ?? 0) < (planetOrder.firstIndex(of: b.0) ?? 0)
        }

        let aspectTypes: [AspectType] = [.conjunction, .sextile, .square, .trine, .opposition]
        let orbs: [AspectType: Double] = [
            .conjunction: 8, .sextile: 6, .square: 8, .trine: 8, .opposition: 8
        ]

        var aspects: [PlanetaryAspect] = []

        for i in 0..<longitudes.count {
            for j in (i+1)..<longitudes.count {
                let (name1, sym1, lon1) = longitudes[i]
                let (name2, sym2, lon2) = longitudes[j]

                var diff = abs(lon1 - lon2)
                if diff > 180 { diff = 360 - diff }

                for aspectType in aspectTypes {
                    let orbValue = diff - aspectType.angle
                    let maxOrb = orbs[aspectType] ?? 8.0
                    if abs(orbValue) <= maxOrb {
                        aspects.append(PlanetaryAspect(
                            planet1: name1,
                            planet1Symbol: sym1,
                            planet2: name2,
                            planet2Symbol: sym2,
                            aspect: aspectType.rawValue,
                            aspectSymbol: aspectType.symbol,
                            nature: aspectType.nature,
                            orb: (orbValue * 100).rounded() / 100,
                            description: aspectType.description,
                            isApplying: orbValue < 0
                        ))
                    }
                }
            }
        }

        return aspects.sorted { abs($0.orb) < abs($1.orb) }
    }

    // MARK: - Moon Phase

    /// Returns moon phase information for a given date.
    /// Uses a reference new moon (Jan 6, 2000 at 18:14 UTC, JD 2451549.26) and
    /// the mean synodic period (29.53058867 days).
    ///
    /// TODO: For sub-degree accuracy, replace with SwissEphemeris:
    ///   Compute elongation = moonLon - sunLon, then derive phase from that.
    static func moonPhase(year: Int, month: Int, day: Int) -> MoonPhaseResult {
        let jd = julianDay(year: year, month: month, day: day)
        let referenceNewMoon = 2451549.26   // Jan 6, 2000 18:14 UTC
        let synodicPeriod = 29.53058867

        let daysSince = jd - referenceNewMoon
        let cyclePosition = ((daysSince.truncatingRemainder(dividingBy: synodicPeriod))
            + synodicPeriod).truncatingRemainder(dividingBy: synodicPeriod)

        let illumination = (1 - cos(cyclePosition / synodicPeriod * 2 * .pi)) / 2 * 100

        let (phaseName, phaseEmoji) = phaseName(cyclePosition: cyclePosition, period: synodicPeriod)

        // Next new moon
        let daysToNewMoon = synodicPeriod - cyclePosition
        let nextNewMoonJD = jd + daysToNewMoon
        let nextNewMoon = jdToDateString(nextNewMoonJD)

        // Next full moon (half period from new moon)
        let daysToFullMoon: Double
        if cyclePosition < synodicPeriod / 2 {
            daysToFullMoon = synodicPeriod / 2 - cyclePosition
        } else {
            daysToFullMoon = synodicPeriod - cyclePosition + synodicPeriod / 2
        }
        let nextFullMoon = jdToDateString(jd + daysToFullMoon)

        // Moon sign
        let T = julianCenturies(jd: jd)
        let moonLon = moonLongitude(T: T)
        let moonSign = ZodiacSign.from(eclipticLongitude: moonLon)

        return MoonPhaseResult(
            phase: phaseName,
            phaseEmoji: phaseEmoji,
            illuminationPercent: (illumination * 10).rounded() / 10,
            moonSign: moonSign.rawValue,
            moonSignSymbol: moonSign.symbol,
            nextFullMoon: nextFullMoon,
            nextNewMoon: nextNewMoon,
            cycleDay: Int(cyclePosition) + 1
        )
    }

    private static func phaseName(cyclePosition: Double, period: Double) -> (String, String) {
        let fraction = cyclePosition / period
        switch fraction {
        case 0..<0.03, 0.97...:  return ("New Moon", "🌑")
        case 0.03..<0.22:        return ("Waxing Crescent", "🌒")
        case 0.22..<0.28:        return ("First Quarter", "🌓")
        case 0.28..<0.47:        return ("Waxing Gibbous", "🌔")
        case 0.47..<0.53:        return ("Full Moon", "🌕")
        case 0.53..<0.72:        return ("Waning Gibbous", "🌖")
        case 0.72..<0.78:        return ("Last Quarter", "🌗")
        default:                  return ("Waning Crescent", "🌘")
        }
    }

    // MARK: - Retrograde Periods

    /// Returns retrograde periods for a planet in a given year.
    ///
    /// TODO: Replace with real ephemeris scanning — step through each day of the
    ///       year, compare planet velocity sign changes (using SwissEphemeris
    ///       Coordinate<Planet>.speedInLongitude or finite differences).
    ///       Current implementation uses historically-accurate hardcoded 2025/2026
    ///       dates and approximates other years by offset.
    static func retrogradePeriods(planet: Planet, year: Int) -> [RetrogradePeriod] {
        let baseline = baselineRetrogradePeriods(planet: planet)
        let yearOffset = year - 2026

        return baseline.enumerated().map { idx, period in
            // Shift each period forward/back by the planet's orbital characteristics
            let shiftDays = Int(Double(yearOffset) * period.averageShiftPerYear)
            return RetrogradePeriod(
                startDate: shiftDateString(period.startDate, days: shiftDays),
                endDate:   shiftDateString(period.endDate,   days: shiftDays),
                shadowStart: shiftDateString(period.shadowStart, days: shiftDays),
                shadowEnd:   shiftDateString(period.shadowEnd,   days: shiftDays),
                zodiacSign: period.zodiacSign,
                description: period.description
            )
        }
    }

    static func isCurrentlyRetrograde(planet: Planet, year: Int, month: Int, day: Int) -> Bool {
        let dateStr = String(format: "%04d-%02d-%02d", year, month, day)
        let periods = retrogradePeriods(planet: planet, year: year)
        return periods.contains { p in dateStr >= p.startDate && dateStr <= p.endDate }
    }

    // MARK: - Compatibility Score

    /// Compute a compatibility score (0–100) between two sun signs.
    /// Based on element harmony and traditional astrological aspect relationships.
    static func compatibilityScore(sign1: ZodiacSign, sign2: ZodiacSign) -> Int {
        let angleBetween = abs(sign1.index - sign2.index)
        let normalized = min(angleBetween, 12 - angleBetween)

        // Aspect-based compatibility
        let baseScore: Int
        switch normalized {
        case 0:  baseScore = 85  // Conjunction — same sign, powerful but can clash
        case 1:  baseScore = 55  // Semi-sextile — mild friction
        case 2:  baseScore = 75  // Sextile — harmonious
        case 3:  baseScore = 45  // Square — challenging tension
        case 4:  baseScore = 88  // Trine — natural harmony
        case 5:  baseScore = 60  // Quincunx — adjustment needed
        case 6:  baseScore = 65  // Opposition — attract/challenge
        default: baseScore = 55
        }

        // Element bonus
        let elementBonus: Int
        if sign1.element == sign2.element {
            elementBonus = 8  // Same element — innate understanding
        } else {
            let complements: [String: String] = ["Fire": "Air", "Earth": "Water", "Air": "Fire", "Water": "Earth"]
            elementBonus = complements[sign1.element] == sign2.element ? 5 : 0
        }

        return min(100, baseScore + elementBonus)
    }

    // MARK: - Daily Horoscope Text

    /// Returns static horoscope text for a sign and date.
    /// The text is deterministically seeded from sign + date so it varies daily.
    ///
    /// TODO: Integrate the Apple Foundation Models AI service from the iOS app, or
    ///       a server-side LLM (Claude API) for personalized AI horoscopes:
    ///   let client = Anthropic.Client(apiKey: Environment.get("ANTHROPIC_API_KEY")!)
    ///   let response = try await client.messages.create(...)
    static func dailyHoroscope(sign: ZodiacSign, year: Int, month: Int, day: Int) -> DailyHoroscopeResult {
        let seed = sign.index * 1000 + month * 31 + day
        let themes = horoscopeThemes(for: sign)
        let theme = themes[seed % themes.count]
        let luckyNumbers = [(seed % 9) + 1, (seed / 7 % 9) + 10, (seed / 13 % 9) + 20]
        let colors = ["Midnight Blue", "Rose Gold", "Forest Green", "Deep Purple",
                      "Burnt Orange", "Silver", "Teal", "Crimson", "Gold", "Lavender"]
        let moods = ["Powerful", "Dreamy", "Chill", "Chaotic", "Intense",
                     "Playful", "Reflective", "Productive", "Romantic", "Restless"]

        return DailyHoroscopeResult(
            sign: sign.rawValue,
            signSymbol: sign.symbol,
            date: String(format: "%04d-%02d-%02d", year, month, day),
            horoscope: theme,
            mood: moods[seed % moods.count],
            moodTagline: moodTagline(moods[seed % moods.count]),
            luckyNumbers: luckyNumbers,
            luckyColor: colors[seed % colors.count],
            element: sign.element,
            rulingPlanet: sign.rulingPlanet
        )
    }

    // MARK: - Private: Planetary Longitude Algorithms

    // Sun — Jean Meeus "Astronomical Algorithms" Chapter 27, simplified
    private static func sunLongitude(T: Double) -> Double {
        let L0 = 280.46646 + 36000.76983 * T
        let M  = toRad(357.52911 + 35999.05029 * T - 0.0001537 * T * T)
        let C  = (1.914602 - 0.004817 * T - 0.000014 * T * T) * sin(M)
                + (0.019993 - 0.000101 * T) * sin(2 * M)
                + 0.000289 * sin(3 * M)
        return norm(L0 + C)
    }

    // Moon — simplified Brown lunar theory, accurate to ~0.5°
    private static func moonLongitude(T: Double) -> Double {
        let L = 218.3165 + 481267.8813 * T
        let M = toRad(357.5291 + 35999.0503 * T)
        let Mm = toRad(134.9634 + 477198.8676 * T)
        let D = toRad(297.8502 + 445267.1115 * T)
        let F = toRad(93.2721 + 483202.0175 * T)
        let correction = 6.2886 * sin(Mm)
                        + 1.2740 * sin(2 * D - Mm)
                        + 0.6583 * sin(2 * D)
                        + 0.2136 * sin(2 * Mm)
                        - 0.1851 * sin(M)
                        - 0.1143 * sin(2 * F)
                        + 0.0588 * sin(2 * D - 2 * Mm)
        return norm(L + correction)
    }

    // Mercury — simplified VSOP87
    private static func mercuryLongitude(T: Double) -> Double {
        let L = 252.2509 + 149472.6674 * T
        let correction = 0.3874 * sin(toRad(168.6 + 14325.5 * T))
                        + 0.2500 * sin(toRad(175.1 + 58517.8 * T))
        return norm(L + correction)
    }

    // Venus
    private static func venusLongitude(T: Double) -> Double {
        norm(181.9798 + 58517.8156 * T)
    }

    // Mars
    private static func marsLongitude(T: Double) -> Double {
        norm(355.4330 + 19140.2993 * T)
    }

    // Jupiter
    private static func jupiterLongitude(T: Double) -> Double {
        norm(34.3515 + 3034.9057 * T)
    }

    // Saturn
    private static func saturnLongitude(T: Double) -> Double {
        norm(50.0774 + 1222.1138 * T)
    }

    // Uranus
    private static func uranusLongitude(T: Double) -> Double {
        norm(314.0550 + 428.4882 * T)
    }

    // Neptune
    private static func neptuneLongitude(T: Double) -> Double {
        norm(304.3487 + 218.4862 * T)
    }

    // Pluto (mean, very approximate)
    private static func plutoLongitude(T: Double) -> Double {
        norm(238.9290 + 144.9600 * T)
    }

    // Simple retrograde estimate — planets are retrograde ~portion of their synodic period.
    // TODO: Replace with actual velocity sign check from SwissEphemeris.
    private static func isRetrograde(planet: Planet, T: Double) -> Bool {
        let jd = 2451545.0 + T * 36525.0
        let retrogradeFrequencyDays: Double
        switch planet {
        case .mercury: retrogradeFrequencyDays = 115.88  // synodic period
        case .venus:   retrogradeFrequencyDays = 583.92
        case .mars:    retrogradeFrequencyDays = 779.94
        case .jupiter: retrogradeFrequencyDays = 398.88
        case .saturn:  retrogradeFrequencyDays = 378.09
        case .uranus:  retrogradeFrequencyDays = 369.66
        case .neptune: retrogradeFrequencyDays = 367.49
        case .pluto:   retrogradeFrequencyDays = 366.72
        case .sun, .moon: return false
        }
        let phase = jd.truncatingRemainder(dividingBy: retrogradeFrequencyDays) / retrogradeFrequencyDays
        // Approximate: each planet spends ~20-25% of synodic period retrograde
        return phase > 0.55 && phase < 0.78
    }

    // MARK: - Private: Mock House Placement

    private static func mockHouseCusps(for positions: [(Planet, Double, Bool)]) -> [Int?] {
        // Simple distribution — spread 10 planets across 12 houses
        // TODO: Implement real Placidus house system via SwissEphemeris HouseCusps
        return positions.enumerated().map { i, _ in (i % 12) + 1 }
    }

    // MARK: - Private: Math Helpers

    private static func toRad(_ degrees: Double) -> Double { degrees * .pi / 180 }

    private static func norm(_ degrees: Double) -> Double {
        ((degrees.truncatingRemainder(dividingBy: 360)) + 360)
            .truncatingRemainder(dividingBy: 360)
    }

    // MARK: - Private: Julian Day to Date String

    static func jdToDateString(_ jd: Double) -> String {
        // Algorithm from Meeus Chapter 7
        let z = Int(jd + 0.5)
        let f = (jd + 0.5) - Double(z)
        _ = f
        let a: Int
        if z < 2299161 {
            a = z
        } else {
            let alpha = Int(Double(z - 1867216) / 36524.25)
            a = z + 1 + alpha - alpha / 4
        }
        let b = a + 1524
        let c = Int((Double(b) - 122.1) / 365.25)
        let d = Int(365.25 * Double(c))
        let e = Int(Double(b - d) / 30.6001)

        let day   = b - d - Int(30.6001 * Double(e))
        let month = e < 14 ? e - 1 : e - 13
        let year  = month > 2 ? c - 4716 : c - 4715

        return String(format: "%04d-%02d-%02d", year, month, day)
    }

    // MARK: - Private: Retrograde Baseline Data (2026)

    private struct RetrogradePeriodTemplate {
        let startDate: String
        let endDate: String
        let shadowStart: String
        let shadowEnd: String
        let zodiacSign: String
        let description: String
        let averageShiftPerYear: Double
    }

    private static func baselineRetrogradePeriods(planet: Planet) -> [RetrogradePeriodTemplate] {
        switch planet {
        case .mercury:
            // Mercury retrograde 2026 — matches hardcoded dates in NotificationService.swift
            return [
                RetrogradePeriodTemplate(
                    startDate: "2026-01-25", endDate: "2026-02-14",
                    shadowStart: "2026-01-08", shadowEnd: "2026-03-03",
                    zodiacSign: "Aquarius",
                    description: "Communication and technology glitches. Back up your data, reread before sending.",
                    averageShiftPerYear: 87.97
                ),
                RetrogradePeriodTemplate(
                    startDate: "2026-05-19", endDate: "2026-06-11",
                    shadowStart: "2026-05-03", shadowEnd: "2026-06-27",
                    zodiacSign: "Gemini",
                    description: "Ideas get scrambled and misunderstandings multiply. Perfect time to revisit, not start.",
                    averageShiftPerYear: 87.97
                ),
                RetrogradePeriodTemplate(
                    startDate: "2026-09-13", endDate: "2026-10-06",
                    shadowStart: "2026-08-28", shadowEnd: "2026-10-22",
                    zodiacSign: "Libra",
                    description: "Relationship conversations need extra clarity. Don't sign contracts.",
                    averageShiftPerYear: 87.97
                ),
            ]
        case .venus:
            return [
                RetrogradePeriodTemplate(
                    startDate: "2025-03-01", endDate: "2025-04-12",
                    shadowStart: "2025-01-20", shadowEnd: "2025-05-31",
                    zodiacSign: "Aries",
                    description: "Love, money, and self-worth under review. Not the time for big relationship moves.",
                    averageShiftPerYear: 584
                ),
            ]
        case .mars:
            return [
                RetrogradePeriodTemplate(
                    startDate: "2024-12-06", endDate: "2025-02-23",
                    shadowStart: "2024-10-06", shadowEnd: "2025-05-01",
                    zodiacSign: "Leo",
                    description: "Drive and ambition turn inward. Revisit goals rather than forcing new action.",
                    averageShiftPerYear: 780
                ),
            ]
        case .jupiter:
            return [
                RetrogradePeriodTemplate(
                    startDate: "2026-11-10", endDate: "2027-03-10",
                    shadowStart: "2026-08-01", shadowEnd: "2027-06-01",
                    zodiacSign: "Aries",
                    description: "Expansion turns inward. A time for philosophical and spiritual reflection.",
                    averageShiftPerYear: 399
                ),
            ]
        case .saturn:
            return [
                RetrogradePeriodTemplate(
                    startDate: "2026-06-13", endDate: "2026-10-28",
                    shadowStart: "2026-03-01", shadowEnd: "2027-01-15",
                    zodiacSign: "Aries",
                    description: "Karma and responsibility come back around. Review your structures and commitments.",
                    averageShiftPerYear: 378
                ),
            ]
        case .uranus:
            return [
                RetrogradePeriodTemplate(
                    startDate: "2025-09-06", endDate: "2026-01-30",
                    shadowStart: "2025-05-15", shadowEnd: "2026-05-10",
                    zodiacSign: "Gemini",
                    description: "Innovation and sudden change slow down. Internal revolutions brewing.",
                    averageShiftPerYear: 370
                ),
            ]
        case .neptune:
            return [
                RetrogradePeriodTemplate(
                    startDate: "2026-07-04", endDate: "2026-12-10",
                    shadowStart: "2026-04-01", shadowEnd: "2027-03-01",
                    zodiacSign: "Aries",
                    description: "Dreams and illusions dissolve. Excellent time for spiritual clarity.",
                    averageShiftPerYear: 367
                ),
            ]
        case .pluto:
            return [
                RetrogradePeriodTemplate(
                    startDate: "2026-05-04", endDate: "2026-10-13",
                    shadowStart: "2026-02-01", shadowEnd: "2027-01-01",
                    zodiacSign: "Aquarius",
                    description: "Transformation turns inward. Power dynamics and shadow work surface.",
                    averageShiftPerYear: 367
                ),
            ]
        case .sun, .moon:
            return []
        }
    }

    private static func shiftDateString(_ dateStr: String, days: Int) -> String {
        guard let (y, m, d) = dateStr.parseDate() else { return dateStr }
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        var comps = DateComponents()
        comps.year = y; comps.month = m; comps.day = d
        guard let date = cal.date(from: comps),
              let shifted = cal.date(byAdding: .day, value: days, to: date) else { return dateStr }
        let sc = cal.dateComponents([.year, .month, .day], from: shifted)
        return String(format: "%04d-%02d-%02d", sc.year!, sc.month!, sc.day!)
    }

    // MARK: - Private: Horoscope Text Templates

    private static func moodTagline(_ mood: String) -> String {
        switch mood {
        case "Powerful":   return "Main character energy"
        case "Dreamy":     return "Head in the clouds"
        case "Chill":      return "Go with the flow"
        case "Chaotic":    return "Expect the unexpected"
        case "Intense":    return "Feel it all"
        case "Playful":    return "Keep it light"
        case "Reflective": return "Look inward"
        case "Productive": return "Get things done"
        case "Romantic":   return "Heart-led decisions"
        case "Restless":   return "Channel the energy"
        default:           return "Trust the process"
        }
    }

    private static func horoscopeThemes(for sign: ZodiacSign) -> [String] {
        switch sign {
        case .aries:
            return [
                "Your boldness is your superpower today. Push past hesitation — the universe rewards those who move first. A new door is about to open if you stop staring at the closed one.",
                "Mars lights a fire under your ambitions. Channel that restless energy into something that actually matters to you. By evening, someone notices your drive.",
                "Conflict isn't always destructive — sometimes it's clarifying. Lean into a difficult conversation today. The truth on the other side is worth the discomfort.",
            ]
        case .taurus:
            return [
                "Slow is smooth, smooth is fast. Your patience pays dividends today while others rush toward mistakes. A financial insight arrives — trust your gut before anyone else's advice.",
                "Venus is blessing your senses. Treat yourself to something beautiful, even if it's just a good meal or a walk somewhere green. Beauty is not a luxury — it's maintenance.",
                "You're building something real. Don't let impatience or someone else's timeline derail you. The foundation you're laying now is exactly what 2027 you will thank you for.",
            ]
        case .gemini:
            return [
                "Your mind is electric today. Two conversations that seem unrelated will suddenly click into a brilliant idea. Write it down immediately — Gemini lightning rarely strikes twice.",
                "Social butterfly season. Your wit and curiosity are your calling cards. An unexpected connection forms somewhere you least expected to find it.",
                "Mercury sharpens your communication today. The email you've been putting off? Write it. The pitch you've been rehearsing? Give it. Words are your currency right now.",
            ]
        case .cancer:
            return [
                "Home is calling — not as an escape, but as a recharge. Something about your domestic space needs attention, and tending to it will release a creative block you've been feeling.",
                "Your intuition is practically psychic today. Before you second-guess that feeling, sit with it. The part of you that already knows the answer is worth listening to.",
                "Emotional honesty unlocks a door today. The person you've been vague with needs clarity — and giving it to them is a gift to both of you. Vulnerability is not weakness.",
            ]
        case .leo:
            return [
                "The spotlight finds you whether you sought it or not. Bring your whole self — the Sun is backing you today. Someone in your orbit is watching and will reach out soon.",
                "Creative energy is off the charts. Block out time for the project that makes your soul sing. Practical concerns can wait an hour — your muse cannot.",
                "Recognition you didn't ask for arrives. Accept it gracefully. Your natural generosity is one of your most magnetic qualities; let people appreciate it.",
            ]
        case .virgo:
            return [
                "Your eye for detail saves someone else's project today. Don't downplay that contribution — precision is rare and yours is exceptional. Invoice accordingly.",
                "Health routines need an audit, not an overhaul. One small adjustment creates outsized impact. Your body has been sending signals; today's the day to decode one of them.",
                "Analysis is useful until it becomes paralysis. You have enough information to make the decision. Trust the system you've already built — then execute.",
            ]
        case .libra:
            return [
                "Balance isn't a destination, it's a practice. Notice where you've been over-giving and let yourself receive something today without guilt or conditions.",
                "Aesthetic choices matter more than usual — your surroundings affect your mood in a very direct way right now. Small changes to your environment create big shifts in outlook.",
                "A relationship tension you've been gently avoiding needs a gentle conversation. Frame it as curiosity rather than confrontation and you'll be surprised how easily it resolves.",
            ]
        case .scorpio:
            return [
                "Transformation is uncomfortable by definition. The discomfort you're feeling is not a warning — it's a sign that the change is actually working. Keep going.",
                "Your research pays off. Something you've been quietly investigating behind the scenes is about to surface in a way that shifts the power dynamic. You were right to dig.",
                "Deep connections only. Shallow interactions leave you depleted right now. Give yourself permission to cancel what doesn't feed your soul and double down on what does.",
            ]
        case .sagittarius:
            return [
                "Adventure is a mindset, not just a plane ticket. Today's adventure might be a new idea, a random neighborhood, or a book that cracks your worldview open. Follow the thread.",
                "Your optimism is contagious in the best possible way. Share it — someone around you is about to give up on something that just needs one more push.",
                "Philosophy meets practicality today. The belief system you hold is being tested against reality. It's not a challenge — it's an invitation to refine your truth.",
            ]
        case .capricorn:
            return [
                "The grind is real, but so is the payoff. Today's steady effort compounds. What looks like slow progress is actually the foundation of something lasting. Stay the course.",
                "Authority comes naturally to you, but today it's the quiet kind — influence through example rather than instruction. Others are watching more than you realize.",
                "Rest is part of the strategy, not a deviation from it. The most disciplined thing you can do today might actually be to take the afternoon off.",
            ]
        case .aquarius:
            return [
                "Your unconventional idea is actually correct. Trust it. The reason it hasn't been done before is not because it's wrong — it's because the world hadn't caught up yet. It's catching up.",
                "Community over competition. The collaboration you've been considering will generate more impact than going alone. Reach out today while the energy is right.",
                "Detach from the outcome long enough to enjoy the process. The innovation you're chasing is already emerging — your job is to get out of your own way.",
            ]
        case .pisces:
            return [
                "Your imagination is your most valuable asset today. Let it run — then capture one concrete element before it dissolves. Art made from today's visions could be your best work.",
                "Boundaries aren't walls. They're the structure that lets your sensitivity be a gift rather than a liability. One gentle 'no' today protects ten future 'yeses'.",
                "Something you lost — an idea, a connection, a piece of yourself — is finding its way back. Pisces energy cycles beautifully when you stop forcing and start receiving.",
            ]
        }
    }
}

// MARK: - Result Types

struct MoonPhaseResult: Content {
    let phase: String
    let phaseEmoji: String
    let illuminationPercent: Double
    let moonSign: String
    let moonSignSymbol: String
    let nextFullMoon: String
    let nextNewMoon: String
    let cycleDay: Int
}

struct RetrogradePeriod: Content {
    let startDate: String
    let endDate: String
    let shadowStart: String
    let shadowEnd: String
    let zodiacSign: String
    let description: String
}

struct DailyHoroscopeResult: Content {
    let sign: String
    let signSymbol: String
    let date: String
    let horoscope: String
    let mood: String
    let moodTagline: String
    let luckyNumbers: [Int]
    let luckyColor: String
    let element: String
    let rulingPlanet: String
}
