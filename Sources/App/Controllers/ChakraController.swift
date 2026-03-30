import Vapor

/// GET /v1/chakras
///   Returns all 7 chakras.
///
/// GET /v1/chakras/:name
///   Path param: name — e.g. "root", "heart", "third-eye", or Sanskrit name e.g. "anahata"
///
/// GET /v1/chakras/:name/crystals
///   Returns crystals associated with the specified chakra.
///
/// GET /v1/chakras/:name/practices
///   Returns healing practices and affirmations for the specified chakra.
struct ChakraController {

    func listAll(req: Request) async throws -> [Chakra] {
        ChakraService.allChakras
    }

    func getOne(req: Request) async throws -> Chakra {
        guard let rawName = req.parameters.get("name") else {
            throw Abort(.badRequest, reason: "Missing chakra name in path.")
        }
        let name = rawName.replacingOccurrences(of: "-", with: " ")
        guard let chakra = ChakraService.chakra(named: name) else {
            let valid = ChakraService.allChakras.map { $0.name.lowercased() }.joined(separator: ", ")
            throw Abort(.notFound, reason: "Chakra '\(rawName)' not found. Valid names: \(valid)")
        }
        return chakra
    }

    func crystals(req: Request) async throws -> ChakraCrystalsResponse {
        guard let rawName = req.parameters.get("name") else {
            throw Abort(.badRequest, reason: "Missing chakra name in path.")
        }
        let name = rawName.replacingOccurrences(of: "-", with: " ")
        guard let chakra = ChakraService.chakra(named: name) else {
            let valid = ChakraService.allChakras.map { $0.name.lowercased() }.joined(separator: ", ")
            throw Abort(.notFound, reason: "Chakra '\(rawName)' not found. Valid names: \(valid)")
        }
        let crystalResults = ChakraService.crystals(forChakra: chakra)
        return ChakraCrystalsResponse(
            chakra: chakra.name,
            sanskritName: chakra.sanskritName,
            color: chakra.color,
            crystalNames: chakra.associatedCrystals,
            crystals: crystalResults
        )
    }

    func practices(req: Request) async throws -> ChakraPracticesResponse {
        guard let rawName = req.parameters.get("name") else {
            throw Abort(.badRequest, reason: "Missing chakra name in path.")
        }
        let name = rawName.replacingOccurrences(of: "-", with: " ")
        guard let chakra = ChakraService.chakra(named: name) else {
            let valid = ChakraService.allChakras.map { $0.name.lowercased() }.joined(separator: ", ")
            throw Abort(.notFound, reason: "Chakra '\(rawName)' not found. Valid names: \(valid)")
        }
        return ChakraPracticesResponse(
            chakra: chakra.name,
            sanskritName: chakra.sanskritName,
            purpose: chakra.purpose,
            healingPractices: chakra.healingPractices,
            affirmations: chakra.affirmations,
            foods: chakra.foods,
            balancedTraits: chakra.balancedTraits,
            imbalancedTraits: chakra.imbalancedTraits
        )
    }
}

struct ChakraCrystalsResponse: Content {
    let chakra: String
    let sanskritName: String
    let color: String
    let crystalNames: [String]
    let crystals: [Crystal]
}

struct ChakraPracticesResponse: Content {
    let chakra: String
    let sanskritName: String
    let purpose: String
    let healingPractices: [String]
    let affirmations: [String]
    let foods: [String]
    let balancedTraits: [String]
    let imbalancedTraits: [String]
}
