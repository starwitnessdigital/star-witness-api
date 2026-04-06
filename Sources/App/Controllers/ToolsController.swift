import Vapor
#if canImport(FoundationXML)
import FoundationXML
#endif

/// Utility tool endpoints for AI agents and automation workflows.
///
/// Fully implemented:
///   GET /v1/tools/validate-email?email=user@example.com
///   GET /v1/tools/dns?domain=example.com
///
/// Stub endpoints (require browser runtime — see selfHostingGuide):
///   GET  /v1/tools/screenshot?url=...
///   GET  /v1/tools/pdf?url=...
///   POST /v1/tools/html-to-pdf
struct ToolsController {

    // MARK: - Screenshot (stub — requires Playwright sidecar)

    func screenshot(req: Request) async throws -> Response {
        return browserRuntimeRequired(
            req: req,
            message: "Screenshot capture requires a headless browser runtime (Playwright/Puppeteer). This feature is not available in the current serverless deployment.",
            guide: "Deploy with a Playwright sidecar container to enable screenshots. See AGENTS.md for Docker Compose configuration and self-hosting instructions."
        )
    }

    // MARK: - URL to PDF (stub — requires Playwright sidecar)

    func urlToPDF(req: Request) async throws -> Response {
        return browserRuntimeRequired(
            req: req,
            message: "URL to PDF conversion requires a headless browser runtime (Playwright/Puppeteer). This feature is not available in the current serverless deployment.",
            guide: "Deploy with a Playwright sidecar container to enable PDF generation. See AGENTS.md for Docker Compose configuration and self-hosting instructions."
        )
    }

    // MARK: - HTML to PDF (stub — requires wkhtmltopdf or browser runtime)

    func htmlToPDF(req: Request) async throws -> Response {
        return browserRuntimeRequired(
            req: req,
            message: "HTML to PDF conversion requires wkhtmltopdf or a headless browser runtime. This feature is not available in the current serverless deployment.",
            guide: "Deploy with wkhtmltopdf installed, or use a Playwright sidecar container. See AGENTS.md for Docker Compose configuration and self-hosting instructions."
        )
    }

    // MARK: - Email Validation (fully implemented)

    func validateEmail(req: Request) async throws -> EmailValidationResponse {
        guard let email = req.query[String.self, at: "email"], !email.isEmpty else {
            throw Abort(.badRequest, reason: "Missing required query parameter: email. Example: ?email=user@example.com")
        }

        let formatValid = isValidEmailFormat(email)
        let parts = email.components(separatedBy: "@")
        let domain = parts.count == 2 ? parts[1].lowercased() : ""

        guard formatValid, !domain.isEmpty else {
            return EmailValidationResponse(
                email: email,
                valid: false,
                reason: "Invalid email format",
                formatValid: false,
                disposable: false,
                mxRecords: false,
                domain: domain
            )
        }

        let isDisposable = disposableDomains.contains(domain)
        let hasMX = await checkMXRecords(domain: domain, client: req.client)

        let valid = !isDisposable && hasMX
        let reason: String
        if isDisposable {
            reason = "Disposable/temporary email domain"
        } else if !hasMX {
            reason = "No MX records found — domain cannot receive email"
        } else {
            reason = "Email address appears valid"
        }

        return EmailValidationResponse(
            email: email,
            valid: valid,
            reason: reason,
            formatValid: true,
            disposable: isDisposable,
            mxRecords: hasMX,
            domain: domain
        )
    }

    // MARK: - DNS Lookup (fully implemented via Cloudflare DoH)

    func dnsLookup(req: Request) async throws -> DNSLookupResponse {
        guard let domain = req.query[String.self, at: "domain"], !domain.isEmpty else {
            throw Abort(.badRequest, reason: "Missing required query parameter: domain. Example: ?domain=example.com")
        }

        // Strip accidental protocol/trailing slash
        let cleanDomain = domain
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            .lowercased()

        async let aFetch  = queryDNS(domain: cleanDomain, type: "A",  client: req.client)
        async let mxFetch = queryDNS(domain: cleanDomain, type: "MX", client: req.client)
        async let txtFetch = queryDNS(domain: cleanDomain, type: "TXT", client: req.client)
        async let nsFetch = queryDNS(domain: cleanDomain, type: "NS", client: req.client)

        let (a, mx, txt, ns) = await (aFetch, mxFetch, txtFetch, nsFetch)

        return DNSLookupResponse(
            domain: cleanDomain,
            a: a,
            mx: mx,
            txt: txt,
            ns: ns,
            queriedAt: ISO8601DateFormatter().string(from: Date())
        )
    }

    // MARK: - Private helpers

    private func browserRuntimeRequired(req: Request, message: String, guide: String) -> Response {
        let body = BrowserRequiredResponse(
            error: true,
            code: "BROWSER_RUNTIME_REQUIRED",
            message: message,
            selfHostingGuide: guide
        )
        let response = Response(status: .notImplemented)
        try? response.content.encode(body, as: .json)
        return response
    }

    private func isValidEmailFormat(_ email: String) -> Bool {
        let pattern = #"^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    private func checkMXRecords(domain: String, client: Client) async -> Bool {
        let records = await queryDNS(domain: domain, type: "MX", client: client)
        return !records.isEmpty
    }

    private func queryDNS(domain: String, type: String, client: Client) async -> [DNSRecord] {
        guard let encodedDomain = domain.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return []
        }
        let uri = URI(string: "https://cloudflare-dns.com/dns-query?name=\(encodedDomain)&type=\(type)")
        do {
            var headers = HTTPHeaders()
            headers.add(name: "Accept", value: "application/dns-json")
            let response = try await client.get(uri, headers: headers)

            guard var body = response.body else { return [] }
            let data = body.readData(length: body.readableBytes) ?? Data()
            let doh = try JSONDecoder().decode(DoHResponse.self, from: data)

            return (doh.Answer ?? []).map { answer in
                let priority = type == "MX" ? parseMXPriority(answer.data) : nil
                return DNSRecord(
                    type: dnsTypeName(answer.type),
                    value: answer.data,
                    ttl: answer.TTL,
                    priority: priority
                )
            }
        } catch {
            return []
        }
    }

    private func dnsTypeName(_ type: Int) -> String {
        switch type {
        case 1:  return "A"
        case 2:  return "NS"
        case 5:  return "CNAME"
        case 15: return "MX"
        case 16: return "TXT"
        case 28: return "AAAA"
        default: return "TYPE\(type)"
        }
    }

    private func parseMXPriority(_ data: String) -> Int? {
        let parts = data.split(separator: " ")
        guard let first = parts.first else { return nil }
        return Int(first)
    }

    // Curated list of known disposable/temporary email domains
    private let disposableDomains: Set<String> = [
        "mailinator.com", "guerrillamail.com", "guerrillamail.info", "guerrillamail.biz",
        "guerrillamail.de", "guerrillamail.net", "guerrillamail.org", "guerrillamailblock.com",
        "grr.la", "sharklasers.com", "spam4.me", "tempmail.com", "throwaway.email",
        "yopmail.com", "trashmail.com", "trashmail.me", "trashmail.at", "trashmail.io",
        "dispostable.com", "maildrop.cc", "mailnull.com", "spamgourmet.com",
        "getairmail.com", "fakeinbox.com", "filzmail.com", "spambog.com",
        "emailondeck.com", "10minutemail.com", "10minutemail.net", "10minemail.com",
        "tempinbox.com", "disposablemail.com", "spamfree24.org", "mohmal.com",
        "discard.email", "rcpt.at", "noclickemail.com", "tempr.email",
        "discardmail.com", "discardmail.de", "spamcon.org", "mailnew.com",
        "einrot.com", "armyspy.com", "cuvox.de", "dayrep.com", "einrot.de",
        "fleckens.hu", "gustr.com", "jourrapide.com", "rhyta.com", "superrito.com",
        "teleworm.us", "binkmail.com", "bobmail.info", "chammy.info",
        "devnullmail.com", "donemail.ru", "dontreg.com", "dontsendmespam.de",
        "dump-email.info", "emailias.com", "fakedemail.com", "jetable.fr.nf",
        "mailtemporar.ro", "spamgourmet.net", "spamgourmet.org",
    ]
}
