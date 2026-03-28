import Vapor

public func routes(_ app: Application) throws {
    // MARK: - Landing page
    app.get { req async throws -> Response in
        let indexPath = app.directory.publicDirectory + "index.html"
        return req.fileio.streamFile(at: indexPath)
    }

    // MARK: - API v1 — protected by API key middleware
    let v1 = app.grouped("v1").grouped(APIKeyMiddleware())

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

    // MARK: - Health check (no auth required)
    app.get("health") { _ in ["status": "ok", "service": "star-witness-api"] }
}
