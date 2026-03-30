import Vapor

/// GET /v1/crystals
///   Returns all crystals.
///
/// GET /v1/crystals/:name
///   Path param: name — crystal name, e.g. "amethyst" or "rose-quartz"
///
/// GET /v1/crystals/by-chakra/:chakra
///   Path param: chakra — e.g. "root", "heart", "third-eye"
///
/// GET /v1/crystals/by-zodiac/:sign
///   Path param: sign — e.g. "aries", "pisces"
///
/// GET /v1/crystals/random
///   Returns a random crystal.
struct CrystalController {

    func listAll(req: Request) async throws -> [Crystal] {
        CrystalService.allCrystals
    }

    func getOne(req: Request) async throws -> Crystal {
        guard let rawName = req.parameters.get("name") else {
            throw Abort(.badRequest, reason: "Missing crystal name in path.")
        }
        let name = rawName.replacingOccurrences(of: "-", with: " ")
        guard let crystal = CrystalService.crystal(named: name) else {
            let available = CrystalService.allCrystals.map { $0.name.lowercased().replacingOccurrences(of: " ", with: "-") }.joined(separator: ", ")
            throw Abort(.notFound, reason: "Crystal '\(rawName)' not found. Available: \(available)")
        }
        return crystal
    }

    func byChakra(req: Request) async throws -> CrystalFilterResponse {
        guard let rawChakra = req.parameters.get("chakra") else {
            throw Abort(.badRequest, reason: "Missing chakra in path.")
        }
        let chakra = rawChakra.replacingOccurrences(of: "-", with: " ")
        let results = CrystalService.crystals(forChakra: chakra)
        if results.isEmpty {
            let validChakras = ["root", "sacral", "solar-plexus", "heart", "throat", "third-eye", "crown"]
            throw Abort(.notFound, reason: "No crystals found for chakra '\(rawChakra)'. Valid chakras: \(validChakras.joined(separator: ", "))")
        }
        return CrystalFilterResponse(filter: "chakra", filterValue: chakra.capitalized, count: results.count, crystals: results)
    }

    func byZodiac(req: Request) async throws -> CrystalFilterResponse {
        guard let rawSign = req.parameters.get("sign") else {
            throw Abort(.badRequest, reason: "Missing zodiac sign in path.")
        }
        let sign = rawSign.lowercased()
        let results = CrystalService.crystals(forZodiac: sign)
        if results.isEmpty {
            let validSigns = ZodiacSign.allCases.map { $0.rawValue.lowercased() }.joined(separator: ", ")
            throw Abort(.notFound, reason: "No crystals found for sign '\(rawSign)'. Valid signs: \(validSigns)")
        }
        return CrystalFilterResponse(filter: "zodiac", filterValue: sign.capitalized, count: results.count, crystals: results)
    }

    func random(req: Request) async throws -> Crystal {
        CrystalService.random()
    }
}

struct CrystalFilterResponse: Content {
    let filter: String
    let filterValue: String
    let count: Int
    let crystals: [Crystal]
}
