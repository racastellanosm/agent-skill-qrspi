# Split Docker Compose Topologies

A major pitfall in containerized development is overloading a single `docker-compose.yml` file with development-only configurations (like binding local host source directories or hardcoding debug ports) that pollute production definitions.

---

## 🏛️ The Split Compose Strategy

We enforce a strict two-tier topology:

```
┌───────────────────────────────────────────────────────────┐
│ docker-compose.yml (Base Specification)                   │
│ - Defines service names, base images, networks, & volumes │
│ - Production-aligned defaults (no host path mounts)       │
│ - Used by: CI, staging, production builds                 │
└─────────────────────────────┬─────────────────────────────┘
                              │ + Overrides
                              ▼
┌───────────────────────────────────────────────────────────┐
│ docker-compose.dev.yml (Developer Overrides)              │
│ - Mounts local host directories for live hot-reload       │
│ - Exposes debug ports (e.g. 9003 for Xdebug, 9229 for V8) │
│ - Enables development environment variables               │
└───────────────────────────────────────────────────────────┘
```

---

## ⚙️ Orchestration Variables in Makefile

The `Makefile` merges these files deterministically using Docker Compose's `-f` multi-file support:

```makefile
COMPOSE     := docker compose -f docker-compose.yml
COMPOSE_DEV := docker compose -f docker-compose.yml -f docker-compose.dev.yml
```

* For local development: `$(COMPOSE_DEV) up`
* For headless test runs: `$(COMPOSE_DEV) run --rm --no-deps <service> <command>`
* For production validation: `$(COMPOSE) build`

---

## 💻 Concrete Topology Examples

### 1. `docker-compose.yml` (Base Specification)
```yaml
services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
      target: production
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: production
      PORT: 3000
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

### 2. `docker-compose.dev.yml` (Development Overrides)
```yaml
services:
  api:
    build:
      target: test
    environment:
      NODE_ENV: development
    volumes:
      # Mount host source code into container for live reload
      - ./:/app
      # Anonymous volume to protect container node_modules from host overwrite
      - /app/node_modules
    command: ["bun", "run", "dev"]
```

---

## 🛡️ Volume Mounting & Permission Guidelines

1. **Protect Container Dependencies**: When mounting the root workspace (`./:/app`), always create an anonymous volume for dependency folders (e.g. `/app/node_modules` or `/app/vendor`) so host files don't accidentally shadow the containerized binaries.
2. **Read-Only Code Mounts in CI**: In testing or CI environments, mount code as read-only (`./:/app:ro`) to guarantee that test executions cannot mutate tracked repository files.
3. **Database Data Persistence**: Always define named volumes for persistent state:
   ```yaml
   volumes:
     db_data:
       name: ${PROJECT_NAME:-app}_db_data
   ```
