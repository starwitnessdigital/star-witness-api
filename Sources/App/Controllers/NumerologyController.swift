import Vapor

/// GET /v1/numerology/life-path?birthdate=1995-03-15
///   Required: birthdate — YYYY-MM-DD
///
/// GET /v1/numerology/expression?name=John+Smith
///   Required: name — full birth name
///
/// GET /v1/numerology/soul-urge?name=John+Smith
///   Required: name — full birth name
///
/// GET /v1/numerology/personality?name=John+Smith
///   Required: name — full birth name
///
/// GET /v1/numerology/full-reading?name=John+Smith&birthdate=1995-03-15
///   At least one of name or birthdate required.
struct NumerologyController {

    func lifePath(req: Request) async throws -> NumerologyResult {
        guard let birthdate = req.query[String.self, at: "birthdate"] else {
            throw Abort(.badRequest, reason: "Missing required query parameter: birthdate (format: YYYY-MM-DD)")
        }
        guard let number = NumerologyService.lifePath(birthdate: birthdate) else {
            throw Abort(.badRequest, reason: "Invalid birthdate format. Use YYYY-MM-DD, e.g. birthdate=1990-06-21")
        }
        return NumerologyService.interpretation(for: number, type: "Life Path")
    }

    func expression(req: Request) async throws -> NumerologyResult {
        guard let name = req.query[String.self, at: "name"], !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw Abort(.badRequest, reason: "Missing required query parameter: name")
        }
        let number = NumerologyService.expression(name: name)
        return NumerologyService.interpretation(for: number, type: "Expression")
    }

    func soulUrge(req: Request) async throws -> NumerologyResult {
        guard let name = req.query[String.self, at: "name"], !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw Abort(.badRequest, reason: "Missing required query parameter: name")
        }
        let number = NumerologyService.soulUrge(name: name)
        return NumerologyService.interpretation(for: number, type: "Soul Urge")
    }

    func personality(req: Request) async throws -> NumerologyResult {
        guard let name = req.query[String.self, at: "name"], !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw Abort(.badRequest, reason: "Missing required query parameter: name")
        }
        let number = NumerologyService.personality(name: name)
        return NumerologyService.interpretation(for: number, type: "Personality")
    }

    func fullReading(req: Request) async throws -> FullNumerologyReading {
        let name = req.query[String.self, at: "name"]
        let birthdate = req.query[String.self, at: "birthdate"]

        guard name != nil || birthdate != nil else {
            throw Abort(.badRequest, reason: "Provide at least one of: name or birthdate")
        }

        var lifePathResult: NumerologyResult?
        var expressionResult: NumerologyResult?
        var soulUrgeResult: NumerologyResult?
        var personalityResult: NumerologyResult?

        if let bd = birthdate {
            if let number = NumerologyService.lifePath(birthdate: bd) {
                lifePathResult = NumerologyService.interpretation(for: number, type: "Life Path")
            } else {
                throw Abort(.badRequest, reason: "Invalid birthdate format. Use YYYY-MM-DD")
            }
        }

        if let n = name, !n.trimmingCharacters(in: .whitespaces).isEmpty {
            expressionResult = NumerologyService.interpretation(for: NumerologyService.expression(name: n), type: "Expression")
            soulUrgeResult = NumerologyService.interpretation(for: NumerologyService.soulUrge(name: n), type: "Soul Urge")
            personalityResult = NumerologyService.interpretation(for: NumerologyService.personality(name: n), type: "Personality")
        }

        var summaryParts: [String] = []
        if let lp = lifePathResult {
            summaryParts.append("Life Path \(lp.number) (\(lp.name)) shapes your soul's journey.")
        }
        if let ex = expressionResult {
            summaryParts.append("Expression \(ex.number) (\(ex.name)) reveals your natural gifts.")
        }
        if let su = soulUrgeResult {
            summaryParts.append("Soul Urge \(su.number) (\(su.name)) reflects your deepest desires.")
        }
        if let p = personalityResult {
            summaryParts.append("Personality \(p.number) (\(p.name)) is how the world sees you.")
        }
        let summary = summaryParts.joined(separator: " ")

        return FullNumerologyReading(
            inputName: name,
            inputBirthdate: birthdate,
            lifePath: lifePathResult,
            expression: expressionResult,
            soulUrge: soulUrgeResult,
            personality: personalityResult,
            summary: summary
        )
    }
}
