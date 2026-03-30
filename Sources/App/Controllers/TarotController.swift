import Vapor

/// GET /v1/tarot/cards
///   Returns all 78 tarot cards.
///
/// GET /v1/tarot/card/:name
///   Path param: name — card name, e.g. "the-fool" or "The Fool"
///
/// GET /v1/tarot/draw
///   Optional query param: count — number of cards to draw (default 1, max 78)
///
/// GET /v1/tarot/spreads
///   Returns all available spreads.
///
/// GET /v1/tarot/reading
///   Optional query param: spread — spread slug (default "three-card")
///   Available: single, three-card, celtic-cross, love, career, mind-body-spirit
struct TarotController {

    func listCards(req: Request) async throws -> [TarotCard] {
        TarotService.allCards
    }

    func getCard(req: Request) async throws -> TarotCard {
        guard let rawName = req.parameters.get("name") else {
            throw Abort(.badRequest, reason: "Missing card name in path.")
        }
        let name = rawName.replacingOccurrences(of: "-", with: " ")
        guard let card = TarotService.card(named: name) else {
            throw Abort(.notFound, reason: "Card '\(rawName)' not found. Use the card's name in lowercase with hyphens, e.g. 'the-fool' or 'ace-of-wands'.")
        }
        return card
    }

    func draw(req: Request) async throws -> TarotDrawResponse {
        let count = req.query[Int.self, at: "count"] ?? 1
        guard count >= 1 && count <= 78 else {
            throw Abort(.badRequest, reason: "count must be between 1 and 78.")
        }
        let cards = TarotService.draw(count: count)
        return TarotDrawResponse(count: cards.count, cards: cards)
    }

    func listSpreads(req: Request) async throws -> [TarotSpread] {
        TarotService.allSpreads
    }

    func reading(req: Request) async throws -> TarotReadingResponse {
        let slug = req.query[String.self, at: "spread"] ?? "three-card"
        guard let spread = TarotService.spread(slug: slug) else {
            let valid = TarotService.allSpreads.map { $0.slug }.joined(separator: ", ")
            throw Abort(.badRequest, reason: "Unknown spread '\(slug)'. Valid values: \(valid)")
        }
        return TarotService.reading(for: spread)
    }
}

struct TarotDrawResponse: Content {
    let count: Int
    let cards: [TarotCard]
}
