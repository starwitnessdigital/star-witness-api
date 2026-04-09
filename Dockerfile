# ─────────────────────────────────────────────────────────────────
# Stage 1: Build
# ─────────────────────────────────────────────────────────────────
FROM swift:6.0-jammy AS build

WORKDIR /build

# Copy package manifests first for layer caching
COPY Package.swift Package.resolved* ./
RUN swift package resolve

# Copy source
COPY Sources ./Sources
COPY Tests  ./Tests

# Build in release mode (no --static-swift-stdlib; runtime stage provides the Swift libs)
RUN swift build -c release

# ─────────────────────────────────────────────────────────────────
# Stage 2: Run
# ─────────────────────────────────────────────────────────────────
# swift:6.0-jammy-slim contains the Swift runtime libraries but not the compiler,
# so the binary runs without needing --static-swift-stdlib.
FROM swift:6.0-jammy-slim

WORKDIR /app

# Runtime dependencies (openssl for NIO/TLS, sqlite3 for Fluent, ca-certs for HTTPS)
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libsqlite3-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy compiled binary
COPY --from=build /build/.build/release/App ./App

# Copy static assets (landing page, etc.)
COPY Public ./Public

# Vapor listens on $PORT (Railway/Render/Fly.io all set this)
# Fall back to 8080 if not set
ENV PORT=8080
EXPOSE 8080

CMD ["sh", "-c", "./App serve --env production --hostname 0.0.0.0 --port ${PORT:-8080}"]
