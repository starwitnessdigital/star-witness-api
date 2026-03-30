# Star Witness API — AI Agent Integration Guide

The Star Witness API is designed for native consumption by AI agents. This document covers
everything needed to integrate it into Claude, GPT-4, Gemini, or any agent that supports
function calling or tool use.

## Quick links

| Resource | URL |
|---|---|
| OpenAPI spec (YAML) | `GET https://star-witness-api-production.up.railway.app/v1/openapi` |
| OpenAPI spec (static) | `https://star-witness-api-production.up.railway.app/openapi.yaml` |
| Landing page | `https://star-witness-api-production.up.railway.app` |
| Get an API key | `admin@hintofintellect.com` |

---

## 1. How AI agents discover and use this API

### Auto-discovery
Agents that support OpenAPI / Plugin manifests can import the spec directly:

```
https://star-witness-api-production.up.railway.app/v1/openapi
```

The spec describes every endpoint, all parameters, response schemas, and the API key
authentication scheme. An agent that reads this spec can immediately call any endpoint
without further documentation.

### Example prompts that trigger API use

> "What's my horoscope today? I'm a Scorpio."
> → Agent calls `GET /v1/daily-horoscope?sign=scorpio`

> "Do a tarot reading for me using the Celtic Cross spread."
> → Agent calls `GET /v1/tarot/reading?spread=celtic-cross`

> "What crystals are good for my heart chakra?"
> → Agent calls `GET /v1/chakras/heart/crystals` or `GET /v1/crystals/by-chakra/heart`

> "Calculate my life path number. My birthday is June 21, 1990."
> → Agent calls `GET /v1/numerology/life-path?birthdate=1990-06-21`

> "Is Mercury in retrograde right now?"
> → Agent calls `GET /v1/retrograde?planet=mercury`

> "Draw me three tarot cards."
> → Agent calls `GET /v1/tarot/draw?count=3`

> "What's the current moon phase?"
> → Agent calls `GET /v1/moon-phase`

> "How compatible are two people born on April 15, 1990 in New York and November 8, 1992 in Los Angeles?"
> → Agent calls `GET /v1/compatibility` with all eight birth data params

---

## 2. Anthropic / Claude function-calling schemas

Paste these into your Claude API calls as `tools`:

```json
[
  {
    "name": "get_daily_horoscope",
    "description": "Get a daily horoscope for a zodiac sign. Use when the user asks for their horoscope, star sign reading, or daily astrology.",
    "input_schema": {
      "type": "object",
      "properties": {
        "sign": {
          "type": "string",
          "enum": ["aries","taurus","gemini","cancer","leo","virgo","libra","scorpio","sagittarius","capricorn","aquarius","pisces"],
          "description": "The zodiac sign to get a horoscope for"
        },
        "date": {
          "type": "string",
          "description": "Date in YYYY-MM-DD format (optional, defaults to today)"
        }
      },
      "required": ["sign"]
    }
  },
  {
    "name": "get_birth_chart",
    "description": "Calculate a complete natal birth chart including Sun/Moon/Rising signs, planetary positions, houses, and aspects. Requires exact birth date, time, and location.",
    "input_schema": {
      "type": "object",
      "properties": {
        "date":      { "type": "string", "description": "Birth date in YYYY-MM-DD format" },
        "time":      { "type": "string", "description": "Birth time in HH:MM (24-hour) format" },
        "latitude":  { "type": "number", "description": "Birth location latitude in decimal degrees" },
        "longitude": { "type": "number", "description": "Birth location longitude in decimal degrees" },
        "timezone":  { "type": "number", "description": "UTC offset in hours (e.g. -5 for EST). Defaults to 0." }
      },
      "required": ["date", "time", "latitude", "longitude"]
    }
  },
  {
    "name": "get_compatibility",
    "description": "Calculate astrological compatibility between two people. Returns overall score, breakdown by Sun/Moon/Venus/Mars, element harmony, and synastry highlights.",
    "input_schema": {
      "type": "object",
      "properties": {
        "person1_date": { "type": "string", "description": "Person 1 birth date (YYYY-MM-DD)" },
        "person1_time": { "type": "string", "description": "Person 1 birth time (HH:MM)" },
        "person1_lat":  { "type": "number", "description": "Person 1 birth latitude" },
        "person1_lon":  { "type": "number", "description": "Person 1 birth longitude" },
        "person2_date": { "type": "string", "description": "Person 2 birth date (YYYY-MM-DD)" },
        "person2_time": { "type": "string", "description": "Person 2 birth time (HH:MM)" },
        "person2_lat":  { "type": "number", "description": "Person 2 birth latitude" },
        "person2_lon":  { "type": "number", "description": "Person 2 birth longitude" },
        "timezone":     { "type": "number", "description": "UTC offset in hours (optional, applies to both)" }
      },
      "required": ["person1_date","person1_time","person1_lat","person1_lon","person2_date","person2_time","person2_lat","person2_lon"]
    }
  },
  {
    "name": "get_tarot_reading",
    "description": "Perform a tarot card reading using a specific spread. Returns drawn cards with interpretations and an overall reading.",
    "input_schema": {
      "type": "object",
      "properties": {
        "spread": {
          "type": "string",
          "enum": ["single","three-card","celtic-cross","love","career","mind-body-spirit"],
          "description": "The spread layout to use (defaults to three-card)"
        }
      },
      "required": []
    }
  },
  {
    "name": "draw_tarot_cards",
    "description": "Draw a specified number of random tarot cards from a shuffled deck.",
    "input_schema": {
      "type": "object",
      "properties": {
        "count": {
          "type": "integer",
          "minimum": 1,
          "maximum": 78,
          "description": "Number of cards to draw (default 1)"
        }
      },
      "required": []
    }
  },
  {
    "name": "get_numerology_life_path",
    "description": "Calculate a person's Life Path number from their birth date. The Life Path is the most important number in numerology.",
    "input_schema": {
      "type": "object",
      "properties": {
        "birthdate": { "type": "string", "description": "Birth date in YYYY-MM-DD format" }
      },
      "required": ["birthdate"]
    }
  },
  {
    "name": "get_full_numerology_reading",
    "description": "Get a complete numerology reading including Life Path, Expression, Soul Urge, and Personality numbers.",
    "input_schema": {
      "type": "object",
      "properties": {
        "name":      { "type": "string", "description": "Full birth name (for Expression, Soul Urge, Personality numbers)" },
        "birthdate": { "type": "string", "description": "Birth date in YYYY-MM-DD (for Life Path number)" }
      },
      "required": []
    }
  },
  {
    "name": "get_moon_phase",
    "description": "Get the current or a specific date's moon phase, including illumination, moon sign, ritual suggestion, and next full/new moon dates.",
    "input_schema": {
      "type": "object",
      "properties": {
        "date": { "type": "string", "description": "Date in YYYY-MM-DD format (optional, defaults to today)" }
      },
      "required": []
    }
  },
  {
    "name": "get_retrograde",
    "description": "Get retrograde periods for a planet in a given year, including whether it is currently retrograde and what that means.",
    "input_schema": {
      "type": "object",
      "properties": {
        "planet": {
          "type": "string",
          "enum": ["mercury","venus","mars","jupiter","saturn","uranus","neptune","pluto"],
          "description": "Planet to check (default: mercury)"
        },
        "year": { "type": "integer", "description": "Year to query (default: current year)" }
      },
      "required": []
    }
  },
  {
    "name": "get_crystals_for_chakra",
    "description": "Get crystals associated with a specific chakra for healing and meditation.",
    "input_schema": {
      "type": "object",
      "properties": {
        "chakra": {
          "type": "string",
          "enum": ["root","sacral","solar-plexus","heart","throat","third-eye","crown"],
          "description": "The chakra to find crystals for"
        }
      },
      "required": ["chakra"]
    }
  },
  {
    "name": "get_crystals_for_zodiac",
    "description": "Get crystals associated with a specific zodiac sign.",
    "input_schema": {
      "type": "object",
      "properties": {
        "sign": {
          "type": "string",
          "enum": ["aries","taurus","gemini","cancer","leo","virgo","libra","scorpio","sagittarius","capricorn","aquarius","pisces"],
          "description": "The zodiac sign to find crystals for"
        }
      },
      "required": ["sign"]
    }
  },
  {
    "name": "get_chakra_practices",
    "description": "Get healing practices, affirmations, and dietary recommendations for a specific chakra.",
    "input_schema": {
      "type": "object",
      "properties": {
        "chakra": {
          "type": "string",
          "description": "Chakra name in English (root, sacral, solar-plexus, heart, throat, third-eye, crown) or Sanskrit"
        }
      },
      "required": ["chakra"]
    }
  }
]
```

### Mapping tool calls to API requests

When a tool is called, make the corresponding HTTP request:

```python
import httpx

BASE_URL = "https://star-witness-api-production.up.railway.app"
HEADERS  = {"X-API-Key": "YOUR_API_KEY"}

tool_to_endpoint = {
    "get_daily_horoscope":        ("GET", "/v1/daily-horoscope"),
    "get_birth_chart":            ("GET", "/v1/birth-chart"),
    "get_compatibility":          ("GET", "/v1/compatibility"),
    "get_tarot_reading":          ("GET", "/v1/tarot/reading"),
    "draw_tarot_cards":           ("GET", "/v1/tarot/draw"),
    "get_numerology_life_path":   ("GET", "/v1/numerology/life-path"),
    "get_full_numerology_reading":("GET", "/v1/numerology/full-reading"),
    "get_moon_phase":             ("GET", "/v1/moon-phase"),
    "get_retrograde":             ("GET", "/v1/retrograde"),
    "get_crystals_for_chakra":    ("GET", "/v1/crystals/by-chakra/{chakra}"),
    "get_crystals_for_zodiac":    ("GET", "/v1/crystals/by-zodiac/{sign}"),
    "get_chakra_practices":       ("GET", "/v1/chakras/{chakra}/practices"),
}

def call_tool(tool_name: str, tool_input: dict) -> dict:
    method, path_template = tool_to_endpoint[tool_name]
    # Substitute path params; remaining keys become query params
    path = path_template
    query = {}
    for k, v in tool_input.items():
        placeholder = "{" + k + "}"
        if placeholder in path:
            path = path.replace(placeholder, str(v))
        else:
            query[k] = v
    resp = httpx.request(method, BASE_URL + path, params=query, headers=HEADERS)
    resp.raise_for_status()
    return resp.json()
```

---

## 3. OpenAI function-calling schemas

For GPT-4 / GPT-4o, use the same structure with `"type": "function"` wrappers:

```json
{
  "type": "function",
  "function": {
    "name": "get_daily_horoscope",
    "description": "Get a daily horoscope for a zodiac sign.",
    "parameters": {
      "type": "object",
      "properties": {
        "sign": {
          "type": "string",
          "enum": ["aries","taurus","gemini","cancer","leo","virgo","libra","scorpio","sagittarius","capricorn","aquarius","pisces"]
        },
        "date": { "type": "string", "description": "YYYY-MM-DD (optional)" }
      },
      "required": ["sign"]
    }
  }
}
```

Apply the same wrapper to all schemas listed in section 2.

---

## 4. MCP (Model Context Protocol) integration

[MCP](https://modelcontextprotocol.io) lets you expose the Star Witness API as tools
in Claude Desktop, Cursor, and other MCP-compatible hosts.

### Option A — Use the `mcp-server-fetch` bridge (zero code)

Any HTTP API can be wrapped with the generic fetch MCP server:

```json
// claude_desktop_config.json
{
  "mcpServers": {
    "star-witness": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"],
      "env": {
        "FETCH_DEFAULT_HEADERS": "{\"X-API-Key\": \"YOUR_API_KEY\"}"
      }
    }
  }
}
```

Then tell Claude: *"Fetch https://star-witness-api-production.up.railway.app/v1/daily-horoscope?sign=scorpio"*

### Option B — Dedicated MCP server (recommended for production)

Create a thin Node.js MCP server using the [MCP TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk):

```typescript
// star-witness-mcp/index.ts
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { CallToolRequestSchema, ListToolsRequestSchema } from "@modelcontextprotocol/sdk/types.js";

const BASE = "https://star-witness-api-production.up.railway.app";
const KEY  = process.env.STAR_WITNESS_API_KEY!;

const server = new Server(
  { name: "star-witness", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: "daily_horoscope",
      description: "Get a daily horoscope for a zodiac sign",
      inputSchema: {
        type: "object",
        properties: {
          sign: { type: "string", enum: ["aries","taurus","gemini","cancer","leo","virgo","libra","scorpio","sagittarius","capricorn","aquarius","pisces"] },
          date: { type: "string", description: "YYYY-MM-DD (optional)" }
        },
        required: ["sign"]
      }
    },
    {
      name: "tarot_reading",
      description: "Perform a tarot reading",
      inputSchema: {
        type: "object",
        properties: {
          spread: { type: "string", enum: ["single","three-card","celtic-cross","love","career","mind-body-spirit"] }
        }
      }
    },
    {
      name: "moon_phase",
      description: "Get the current moon phase",
      inputSchema: {
        type: "object",
        properties: {
          date: { type: "string", description: "YYYY-MM-DD (optional)" }
        }
      }
    }
    // Add remaining tools following the same pattern
  ]
}));

server.setRequestHandler(CallToolRequestSchema, async (req) => {
  const { name, arguments: args } = req.params;
  const params = new URLSearchParams(args as Record<string, string>);

  const pathMap: Record<string, string> = {
    daily_horoscope:  "/v1/daily-horoscope",
    tarot_reading:    "/v1/tarot/reading",
    moon_phase:       "/v1/moon-phase",
  };

  const res = await fetch(`${BASE}${pathMap[name]}?${params}`, {
    headers: { "X-API-Key": KEY }
  });
  const data = await res.json();

  return {
    content: [{ type: "text", text: JSON.stringify(data, null, 2) }]
  };
});

const transport = new StdioServerTransport();
await server.connect(transport);
```

Add to Claude Desktop config:

```json
{
  "mcpServers": {
    "star-witness": {
      "command": "node",
      "args": ["/path/to/star-witness-mcp/dist/index.js"],
      "env": { "STAR_WITNESS_API_KEY": "YOUR_API_KEY" }
    }
  }
}
```

---

## 5. LangChain / LlamaIndex tool wrapping

```python
from langchain.tools import Tool
import httpx

BASE = "https://star-witness-api-production.up.railway.app"
HEADERS = {"X-API-Key": "YOUR_API_KEY"}

def horoscope(sign: str) -> str:
    r = httpx.get(f"{BASE}/v1/daily-horoscope", params={"sign": sign}, headers=HEADERS)
    d = r.json()
    return f"{d['sign']} ({d['date']}): {d['horoscope']} Mood: {d['mood']}. Lucky numbers: {d['luckyNumbers']}."

def tarot_reading(spread: str = "three-card") -> str:
    r = httpx.get(f"{BASE}/v1/tarot/reading", params={"spread": spread}, headers=HEADERS)
    d = r.json()
    lines = [f"**{d['spread']['name']}**\n", d['overallInterpretation'], ""]
    for c in d['cards']:
        rev = " (Reversed)" if c['isReversed'] else ""
        lines.append(f"• {c['position']}: {c['card']['name']}{rev} — {c['interpretation']}")
    return "\n".join(lines)

star_witness_tools = [
    Tool(name="DailyHoroscope", func=horoscope,
         description="Get a daily horoscope. Input: zodiac sign name."),
    Tool(name="TarotReading", func=tarot_reading,
         description="Perform a tarot reading. Input: spread name (single, three-card, celtic-cross, love, career, mind-body-spirit)."),
]
```

---

## 6. Endpoints reference (summary)

| Endpoint | Auth | Key Params |
|---|---|---|
| `GET /v1/birth-chart` | Required | `date`, `time`, `latitude`, `longitude`, `timezone` |
| `GET /v1/compatibility` | Required | 8× birth data params for two people |
| `GET /v1/daily-horoscope` | Required | `sign` (required), `date` |
| `GET /v1/transits` | Required | `date`, `latitude`, `longitude` |
| `GET /v1/moon-phase` | Required | `date` |
| `GET /v1/retrograde` | Required | `planet`, `year` |
| `GET /v1/tarot/cards` | Required | — |
| `GET /v1/tarot/card/:name` | Required | path: card name |
| `GET /v1/tarot/draw` | Required | `count` (1–78) |
| `GET /v1/tarot/spreads` | Required | — |
| `GET /v1/tarot/reading` | Required | `spread` |
| `GET /v1/numerology/life-path` | Required | `birthdate` |
| `GET /v1/numerology/expression` | Required | `name` |
| `GET /v1/numerology/soul-urge` | Required | `name` |
| `GET /v1/numerology/personality` | Required | `name` |
| `GET /v1/numerology/full-reading` | Required | `name` and/or `birthdate` |
| `GET /v1/crystals` | Required | — |
| `GET /v1/crystals/:name` | Required | path: crystal name |
| `GET /v1/crystals/by-chakra/:chakra` | Required | path: chakra name |
| `GET /v1/crystals/by-zodiac/:sign` | Required | path: zodiac sign |
| `GET /v1/crystals/random` | Required | — |
| `GET /v1/chakras` | Required | — |
| `GET /v1/chakras/:name` | Required | path: chakra name |
| `GET /v1/chakras/:name/crystals` | Required | path: chakra name |
| `GET /v1/chakras/:name/practices` | Required | path: chakra name |
| `GET /v1/openapi` | None | — (OpenAPI spec) |
| `GET /health` | None | — |

Full parameter details and response schemas: `GET /v1/openapi`
