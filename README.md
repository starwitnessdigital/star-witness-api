# Star Witness API

A Vapor (Swift) REST API wrapping the Star Witness astrology calculation engine.
Returns birth charts, daily horoscopes, moon phases, retrograde periods, and
compatibility scores as clean JSON.

---

## Run Locally

```bash
cd star-witness-api

# Demo mode — no API key required (great for local dev)
STAR_WITNESS_DEMO_MODE=1 swift run

# Server starts at http://localhost:8080
```

> First run will fetch Vapor from SwiftPM and compile (~1–2 min). Subsequent runs
> are fast.

---

## API Endpoints

All endpoints live under `/v1/` and require an `X-API-Key` header.
In demo mode (`STAR_WITNESS_DEMO_MODE=1`) the header is optional.

**Demo keys for testing:**
| Key | Tier |
|---|---|
| `sw_free_demo_key_123` | Free (100/day) |
| `sw_starter_demo_key_456` | Starter (1k/day) |
| `sw_pro_demo_key_789` | Pro (10k/day) |
| `sw_enterprise_demo_key_000` | Enterprise (unlimited) |

---

### GET /v1/birth-chart

Returns a complete natal birth chart.

**Required params:**
| Param | Format | Example |
|---|---|---|
| `date` | YYYY-MM-DD | `1990-04-15` |
| `time` | HH:MM (24h) | `14:30` |
| `latitude` | decimal, N positive | `40.7128` |
| `longitude` | decimal, E positive | `-74.0060` |

**Optional params:**
| Param | Default | Description |
|---|---|---|
| `timezone` | `0` | UTC offset in hours, e.g. `-5` for EST |

**Example:**
```bash
curl -H "X-API-Key: sw_free_demo_key_123" \
  "http://localhost:8080/v1/birth-chart?date=1990-04-15&time=14:30&latitude=40.7128&longitude=-74.0060&timezone=-5"
```

**Response:**
```json
{
  "sunSign":   { "name": "Aries",  "symbol": "♈", "element": "Fire",  "modality": "Cardinal", "rulingPlanet": "Mars" },
  "moonSign":  { "name": "Cancer", "symbol": "♋", "element": "Water", "modality": "Cardinal", "rulingPlanet": "Moon" },
  "risingSign":{ "name": "Leo",    "symbol": "♌", "element": "Fire",  "modality": "Fixed",    "rulingPlanet": "Sun"  },
  "planets": [
    { "planet": "Sun", "symbol": "☉", "sign": "Aries", "signSymbol": "♈", "element": "Fire",
      "degrees": 25.4, "house": 9, "isRetrograde": false },
    ...
  ],
  "houses": [
    { "house": 1, "sign": "Leo", "signSymbol": "♌", "degrees": 12.3 },
    ...
  ],
  "aspects": [
    { "planet1": "Sun", "planet1Symbol": "☉", "planet2": "Moon", "planet2Symbol": "☽",
      "aspect": "Square", "aspectSymbol": "□", "nature": "Challenging",
      "orb": 2.1, "description": "Tension that drives action", "isApplying": false },
    ...
  ]
}
```

---

### GET /v1/compatibility

Synastry compatibility between two people.

**Required params:**
`person1_date`, `person1_time`, `person1_lat`, `person1_lon`
`person2_date`, `person2_time`, `person2_lat`, `person2_lon`

**Optional:** `timezone` (UTC offset, applies to both)

**Example:**
```bash
curl -H "X-API-Key: sw_free_demo_key_123" \
  "http://localhost:8080/v1/compatibility?person1_date=1990-04-15&person1_time=14:30&person1_lat=40.71&person1_lon=-74.00&person2_date=1992-11-08&person2_time=09:15&person2_lat=34.05&person2_lon=-118.24"
```

**Response:**
```json
{
  "overallScore": 82,
  "overallRating": "Strong Connection 💫",
  "breakdown": {
    "sunCompatibility": 88,
    "moonCompatibility": 75,
    "venusCompatibility": 85,
    "marsCompatibility": 70,
    "attractionScore": 79
  },
  "elementHarmony": "Fire and Water — contrasting energies that create fascinating tension.",
  "synastryHighlights": [
    "Strong Sun-Moon connection...",
    "Venus harmony — shared values..."
  ]
}
```

---

### GET /v1/daily-horoscope

Daily horoscope for a zodiac sign.

**Required params:**
| Param | Values |
|---|---|
| `sign` | `aries`, `taurus`, `gemini`, `cancer`, `leo`, `virgo`, `libra`, `scorpio`, `sagittarius`, `capricorn`, `aquarius`, `pisces` |

**Optional:** `date` (YYYY-MM-DD, defaults to today UTC)

**Example:**
```bash
curl -H "X-API-Key: sw_free_demo_key_123" \
  "http://localhost:8080/v1/daily-horoscope?sign=scorpio&date=2026-03-27"
```

**Response:**
```json
{
  "sign": "Scorpio",
  "signSymbol": "♏",
  "date": "2026-03-27",
  "horoscope": "Your research pays off. Something you've been quietly investigating...",
  "mood": "Intense",
  "moodTagline": "Feel it all",
  "luckyNumbers": [8, 17, 26],
  "luckyColor": "Crimson",
  "element": "Water",
  "rulingPlanet": "Pluto"
}
```

---

### GET /v1/transits

Current planetary positions and active aspects in the sky.

**Optional params:** `date` (YYYY-MM-DD), `latitude`, `longitude`, `timezone`

**Example:**
```bash
curl -H "X-API-Key: sw_free_demo_key_123" \
  "http://localhost:8080/v1/transits"
```

---

### GET /v1/moon-phase

Moon phase for a given date.

**Optional params:** `date` (YYYY-MM-DD, defaults to today)

**Example:**
```bash
curl -H "X-API-Key: sw_free_demo_key_123" \
  "http://localhost:8080/v1/moon-phase?date=2026-04-01"
```

**Response:**
```json
{
  "phase": "Waxing Gibbous",
  "phaseEmoji": "🌔",
  "illuminationPercent": 78.4,
  "cycleDay": 13,
  "moonSign": "Leo",
  "moonSignSymbol": "♌",
  "nextFullMoon": "2026-04-03",
  "nextNewMoon": "2026-04-17",
  "ritualSuggestion": "Refine and perfect. The full manifestation is close.",
  "energyDescription": "Building intensity. Refinement and perseverance pay off now."
}
```

---

### GET /v1/retrograde

Retrograde periods for any planet in a given year.

**Optional params:**
| Param | Default | Values |
|---|---|---|
| `planet` | `mercury` | mercury, venus, mars, jupiter, saturn, uranus, neptune, pluto |
| `year` | current year | any 4-digit year |

**Example:**
```bash
curl -H "X-API-Key: sw_free_demo_key_123" \
  "http://localhost:8080/v1/retrograde?planet=mercury&year=2026"
```

---

## Error Responses

All errors return a consistent shape:
```json
{ "error": true, "reason": "Missing required query parameter: date", "code": "MISSING_PARAM" }
```

HTTP status codes: `400` (bad params), `401` (bad key), `429` (rate limit exceeded).

---

## Pricing Tiers

| Tier | Price | Requests/day |
|---|---|---|
| Free | $0/mo | 100 |
| Starter | $9/mo | 1,000 |
| Pro | $29/mo | 10,000 |
| Enterprise | $99/mo | Unlimited |

---

## Deployment

### Railway (recommended, cheapest — ~$5/mo)
```bash
# Install Railway CLI
brew install railway

railway login
railway init
railway up
```

### Render
1. Push to GitHub
2. New Web Service → select repo → Environment: Docker
3. Set `STAR_WITNESS_DEMO_MODE=0` in env vars

### Fly.io
```bash
fly launch   # detects Dockerfile automatically
fly deploy
```

### Docker (any VPS)
```bash
docker build -t star-witness-api .
docker run -p 8080:8080 -e STAR_WITNESS_DEMO_MODE=0 star-witness-api
```

---

## Integrating Real Swiss Ephemeris Calculations

The current calculations use simplified mean longitude approximations (Meeus
"Astronomical Algorithms"). Accuracy: ~1° for inner planets, ~2–5° for outer.

To get sub-arc-minute precision (same as the Star Witness iOS app):

1. **Add the SwissEphemeris package** to `Package.swift`:
   ```swift
   .package(url: "https://github.com/ncreated/SwissEphemeris", from: "1.0.0")
   ```

2. **Copy ephemeris data files** from the iOS app's bundle into `Sources/App/Resources/`
   (the JPL DE431 `.se1` files).

3. **Call `JPLFileManager.setEphemerisPath()`** in `configure.swift`.

4. **Replace stub methods** in `AstrologyCalculationService.swift` — each method
   has a `// TODO:` comment with the exact SwissEphemeris API call to use,
   mirroring `SwissEphemerisCalculator.swift` from the Star Witness iOS app.

---

## Project Structure

```
star-witness-api/
├── Sources/App/
│   ├── entrypoint.swift          # @main entry point
│   ├── configure.swift           # Vapor config, CORS, middleware
│   ├── routes.swift              # Route registration
│   ├── Models/
│   │   └── AstrologyModels.swift # ZodiacSign, Planet, PlanetaryPosition, Aspect DTOs
│   ├── Controllers/
│   │   ├── BirthChartController.swift
│   │   ├── CompatibilityController.swift
│   │   ├── HoroscopeController.swift
│   │   ├── TransitsController.swift
│   │   ├── MoonPhaseController.swift
│   │   └── RetrogradeController.swift
│   ├── Middleware/
│   │   └── APIKeyMiddleware.swift # API key auth + in-memory rate limiter
│   └── Services/
│       └── AstrologyCalculationService.swift  # All calc logic + Swiss Ephemeris TODOs
├── Public/
│   └── index.html                # Dark-theme landing page
├── Dockerfile
└── README.md
```
