import Vapor

public func routes(_ app: Application) throws {
    // MARK: - Landing page
    app.get { req async throws -> Response in
        let indexPath = app.directory.publicDirectory + "index.html"
        return req.fileio.streamFile(at: indexPath)
    }

    // MARK: - API v1 — protected by API key middleware
    let v1 = app.grouped("v1").grouped(APIKeyMiddleware())

    // MARK: Astrology endpoints
    let birthChart = BirthChartController()
    let compatibility = CompatibilityController()
    let horoscope = HoroscopeController()
    let transits = TransitsController()
    let moonPhase = MoonPhaseController()
    let retrograde = RetrogradeController()

    v1.get("birth-chart", use: birthChart.index)
    v1.get("compatibility", use: compatibility.index)
    v1.get("daily-horoscope", use: horoscope.index)
    v1.get("transits", use: transits.index)
    v1.get("moon-phase", use: moonPhase.index)
    v1.get("retrograde", use: retrograde.index)

    // MARK: Tarot endpoints
    let tarot = TarotController()
    let tarotGroup = v1.grouped("tarot")
    tarotGroup.get("cards", use: tarot.listCards)
    tarotGroup.get("card", ":name", use: tarot.getCard)
    tarotGroup.get("draw", use: tarot.draw)
    tarotGroup.get("spreads", use: tarot.listSpreads)
    tarotGroup.get("reading", use: tarot.reading)

    // MARK: Numerology endpoints
    let numerology = NumerologyController()
    let numerologyGroup = v1.grouped("numerology")
    numerologyGroup.get("life-path", use: numerology.lifePath)
    numerologyGroup.get("expression", use: numerology.expression)
    numerologyGroup.get("soul-urge", use: numerology.soulUrge)
    numerologyGroup.get("personality", use: numerology.personality)
    numerologyGroup.get("full-reading", use: numerology.fullReading)

    // MARK: Crystal endpoints
    let crystal = CrystalController()
    let crystalGroup = v1.grouped("crystals")
    crystalGroup.get(use: crystal.listAll)
    crystalGroup.get("by-chakra", ":chakra", use: crystal.byChakra)
    crystalGroup.get("by-zodiac", ":sign", use: crystal.byZodiac)
    crystalGroup.get("random", use: crystal.random)
    crystalGroup.get(":name", use: crystal.getOne)

    // MARK: Chakra endpoints
    let chakra = ChakraController()
    let chakraGroup = v1.grouped("chakras")
    chakraGroup.get(use: chakra.listAll)
    chakraGroup.get(":name", use: chakra.getOne)
    chakraGroup.get(":name", "crystals", use: chakra.crystals)
    chakraGroup.get(":name", "practices", use: chakra.practices)

    // MARK: - Health check (no auth required)
    app.get("health") { _ in ["status": "ok", "service": "star-witness-api"] }
}
