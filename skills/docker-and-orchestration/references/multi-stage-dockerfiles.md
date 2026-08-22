# Multi-Stage Dockerfile Guidelines

Writing production-grade Dockerfiles requires balancing build reproducibility, fast developer iteration, and hardened, minimal production runtime images.

---

## 🏛️ The Canonical 3-Stage Lifecycle Pattern

Every containerized application should structure its Dockerfile across three dedicated stages:

```
┌─────────────────────────────────────────────────────────────┐
│ Stage 1: BASE / BUILDER                                     │
│ - Minimal base OS (Alpine / Debian Slim)                    │
│ - Copies package manifests ONLY (package.json, go.mod, etc.)│
│ - Runs deterministic install (--frozen-lockfile, no-scripts)│
│ - Compiles application artifacts / assets                   │
└──────────────────────────────┬──────────────────────────────┘
                               │
               ┌───────────────┴───────────────┐
               ▼                               ▼
┌──────────────────────────────┐ ┌──────────────────────────────┐
│ Stage 2: TEST & DEV RUNNER   │ │ Stage 3: PRODUCTION RUNTIME  │
│ - Inherits from Base         │ │ - Distroless / Scratch / Slim│
│ - Test tooling installed     │ │ - Copies ONLY built artifacts│
│   (Chromium, Xdebug, Pytest) │ │ - Zero shell (/bin/sh absent)│
│ - User: non-root (bun / 1000)│ │ - User: non-root (1000:1000) │
│ - Target for local hot-reload│ │ - Read-only rootfs ready     │
└──────────────────────────────┘ └──────────────────────────────┘
```

---

## 🎯 Base Image Selection Matrix

Choose the most secure, minimal runtime image for the production stage based on the language/runtime:

| Technology | Recommended Prod Base | Why? | Dev/Test Base |
| :--- | :--- | :--- | :--- |
| **Bun** | `oven/bun:<version>-distroless` | Eliminates shell/OS packages; runs pure JS/TS bundle directly. | `oven/bun:<version>-alpine` |
| **Node.js** | `gcr.io/distroless/nodejs22-debian12` | Zero shell, zero package manager, minimal CVE footprint. | `node:22-alpine` |
| **Go** | `scratch` or `gcr.io/distroless/static-debian12` | Statically linked binary (`CGO_ENABLED=0`) needs zero OS layers. | `golang:1.24-alpine` |
| **PHP** | Minimal Alpine + RoadRunner / PHP-FPM | Extreme lightness (~30MB) with strict extension compilation. | Alpine + Xdebug / Chromium |
| **Python** | `gcr.io/distroless/python3-debian12` | Copies virtualenv from builder stage; no build tools in prod. | `python:3.12-slim` |

---

## 🔒 Security Best Practices & Hardening Rules

1. **Manifest Layer Caching**: Always copy lockfiles (`bun.lock`, `package-lock.json`, `composer.lock`, `go.sum`) before copying application source code to maximize Docker layer cache hits.
2. **Never Run as Root in Production**:
   * Always set `USER 1000:1000` or `USER nonroot` before `ENTRYPOINT`.
   * For Distroless: `USER nonroot:nonroot` or `USER 65532:65532`.
   * For Alpine: `USER 1000:1000` or create a dedicated application user.
3. **Supply Chain Protection**:
   * Node/Bun: Always pass `--ignore-scripts` during install to avoid arbitrary malicious postinstall scripts.
   * Lockfiles: Always enforce `--frozen-lockfile` (Bun/pnpm/yarn) or `npm ci` / `composer install --no-interaction`.
4. **Deterministic Entrypoints**: Use JSON array syntax for `ENTRYPOINT` and `CMD` (`["executable", "param1"]`) rather than string syntax to ensure signal handling (`SIGTERM`) works properly.

---

## 💡 Practical Guideline: Blueprints + On-The-Spot Research

> [!TIP]
> **Adaptive Engineering Principle:**  
> The examples provided below are **reference blueprints and foundational guides**, not rigid, one-size-fits-all templates.  
> Whenever containerizing a new project or updating an existing one, AI agents and engineers should use these patterns as a foundation **combined with on-the-spot research** into the project's specific stack requirements, latest base image digests, official security advisories, and framework-specific caching mechanisms. This ensures every Dockerfile is strictly optimized, well-formed, and securely tailored to the ground truth of the target repository.

---

## 💻 Concrete Multi-Stage Reference Examples

### 1. Bun + Playwright (Test Stage) + Distroless (Prod Stage)
```dockerfile
# Stage 1: Base & Dependencies Builder
FROM oven/bun:1.4-alpine AS base
WORKDIR /app

# Copy dependency manifests
COPY package.json bun.lock* ./
RUN bun install --frozen-lockfile --ignore-scripts

COPY . .

# Stage 2: Test & Development Environment (with Headless Chromium for E2E)
FROM base AS test
RUN apk add --no-cache chromium ffmpeg ca-certificates
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium

USER bun
EXPOSE 3000
CMD ["bun", "run", "dev"]

# Stage 3: Production Distroless Runtime (Zero OS Shell)
FROM oven/bun:1.4-distroless AS production
WORKDIR /app
COPY --from=base --chown=1000:1000 /app /app

USER 1000:1000
EXPOSE 3000
ENTRYPOINT ["bun", "run", "src/index.ts"]
```

---

### 2. Go Static Binary (Scratch Base)
```dockerfile
# Stage 1: Builder
FROM golang:1.24-alpine AS builder
WORKDIR /src

RUN apk add --no-cache ca-certificates tzdata

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w -extldflags '-static'" -o /bin/app main.go

# Stage 2: Production (Scratch - Zero MB OS)
FROM scratch AS production
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /bin/app /bin/app

USER 1000:1000
ENTRYPOINT ["/bin/app"]
```

---

### 3. PHP RoadRunner / Static Production
```dockerfile
# Stage 1: Composer & Dependencies
FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader --ignore-platform-reqs

# Stage 2: Production Runtime
FROM php:8.4-cli-alpine AS production
WORKDIR /app

RUN docker-php-ext-install opcache pdo_mysql

COPY --from=vendor /app/vendor ./vendor
COPY . .

USER 1000:1000
EXPOSE 8080
ENTRYPOINT ["./rr", "serve", "-c", ".rr.yaml"]
```
