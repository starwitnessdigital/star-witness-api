import Vapor

// MARK: - Browser Runtime Required (stub response for screenshot/PDF endpoints)

struct BrowserRequiredResponse: Content {
    let error: Bool
    let code: String
    let message: String
    let selfHostingGuide: String
}

// MARK: - Email Validation

struct EmailValidationResponse: Content {
    let email: String
    let valid: Bool
    let reason: String
    let formatValid: Bool
    let disposable: Bool
    let mxRecords: Bool
    let domain: String
}

// MARK: - DNS Lookup

struct DNSRecord: Content {
    let type: String
    let value: String
    let ttl: Int?
    let priority: Int?  // MX records only
}

struct DNSLookupResponse: Content {
    let domain: String
    let a: [DNSRecord]
    let mx: [DNSRecord]
    let txt: [DNSRecord]
    let ns: [DNSRecord]
    let queriedAt: String
}

// MARK: - Cloudflare DoH wire types (internal)

struct DoHResponse: Decodable {
    let Status: Int
    let Answer: [DoHAnswer]?
}

struct DoHAnswer: Decodable {
    let name: String
    let type: Int
    let TTL: Int
    let data: String
}
