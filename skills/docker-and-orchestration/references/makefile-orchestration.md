# Makefile Orchestration Guidelines

The `Makefile` serves as the universal, deterministic contract between developers, CI/CD pipelines, and AI coding assistants. By funneling all actions through standardized Makefile targets, we eliminate ambient host dependency assumptions and guarantee reproducible execution.

---

## 🏛️ Core Principles

1. **Host Purity (Zero Host Dependencies)**: Never assume runtimes (Bun, Node, PHP, Go, Python) exist on the host. Every target that executes code must invoke Docker or Docker Compose.
2. **Self-Documenting Help**: The default target (`.DEFAULT_GOAL := help`) must parse double-hash comments (`##`) to display a formatted, colorful menu of all available commands.
3. **Deterministic Variable Conventions**:
   * `COMPOSE := docker compose -f docker-compose.yml`
   * `COMPOSE_DEV := docker compose -f docker-compose.yml -f docker-compose.dev.yml`
   * `DOCKER_RUN := $(COMPOSE_DEV) run --rm --no-deps`
4. **Ephemeral Container Runners**: For tasks like `lint`, `typecheck`, `test-unit`, and `audit`, use `$(DOCKER_RUN) <service> <command>` to spin up an isolated container that terminates immediately without leaving dangling processes or containers.

---

## 📋 Universal Targets Contract Taxonomy

> [!TIP]
> **Adaptive Engineering Principle:**  
> This taxonomy is a **normative guidance catalog**, not a rigid mandate that every single project must blindly replicate.  
> Target selection must adapt to the **ground truth, architecture, and specific technologies of the application being developed**:
> - A lightweight CLI or static library may only require `help`, `build`, `test`, and `clean`.
> - A complex full-stack web application with databases, queues, and frontends may require the complete suite (`dev`, `test-unit`, `test-e2e`, `db-migrate`, `audit-image`).  
> AI agents and engineers should tailor the target set to what genuinely delivers value and ergonomics for the target codebase.

| Target Category | Standard Target | Description | Example Command Pattern |
| :--- | :--- | :--- | :--- |
| **Discovery** | `help` | Default goal. Formats and prints all targets with descriptions. | `grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST)` |
| **Setup** | `install` | Installs dependencies into mounted volume or syncs to host for IDE LSP. | `docker run --rm -v $$(pwd):/app -w /app <image> <pkg-manager> install` |
| **Development** | `dev` | Starts local development stack with live reload in the foreground. | `$(COMPOSE_DEV) up` |
| **Testing** | `test` | Runs default test suite (unit + integration). | `$(DOCKER_RUN) <service> <test-cmd>` |
| | `test-unit` | Runs fast unit test suite with coverage report. | `$(DOCKER_RUN) <service> <unit-cmd>` |
| | `test-integration` | Runs integration tests against real containerized dependencies (DB/Cache). | `$(DOCKER_RUN) <service> <int-cmd>` |
| | `test-coverage` | Runs full test suites and produces coverage reports in `.build/`. | `@rm -rf .build && $(DOCKER_RUN) ...` |
| | `test-e2e` | Starts stack and runs end-to-end browser/API tests (e.g. Playwright). | `@$(MAKE) start && $(COMPOSE_DEV) exec ... && @$(MAKE) stop` |
| **Static Quality** | `typecheck` | Validates static types (TypeScript, PHPStan, Go Vet, Mypy). | `$(DOCKER_RUN) <service> <typecheck-cmd>` |
| | `lint` | Runs linters and style checkers (ESLint, Pint, GolangCI-Lint, Ruff). | `$(DOCKER_RUN) <service> <lint-cmd>` |
| | `audit` | Audits dependency supply chain for vulnerabilities / untrusted scripts. | `$(DOCKER_RUN) <service> <audit-cmd>` |
| | `check` | Complete pre-commit/CI pipeline (`typecheck` + `lint` + `audit` + `test`). | Runs all verification targets sequentially. |
| **Lifecycle** | `start` | Starts services in the background (detached mode). | `$(COMPOSE_DEV) up -d` |
| | `stop` | Stops background services cleanly. | `$(COMPOSE_DEV) down` |
| | `restart` | Restarts all active containers. | `$(COMPOSE_DEV) restart` |
| | `logs` | Streams live logs from all services or a specific service. | `$(COMPOSE_DEV) logs -f $(service)` |
| **Build & Release** | `build` | Builds application binaries and artifacts inside container. | `docker build -t <tag> -f <Dockerfile> .` |
| | `clean` | Stops containers, removes orphaned networks and cleans build caches. | `$(COMPOSE_DEV) down --remove-orphans -v` |

---

## 🛠️ Stack Implementation Patterns & Examples

### 1. Bun / TypeScript Monorepo Pattern
```makefile
# ==============================================================================
# Makefile — Bun/TypeScript Monorepo
# ==============================================================================
.DEFAULT_GOAL := help
.PHONY: help install dev test test-unit test-integration test-e2e typecheck lint audit check build start stop restart logs clean

COMPOSE     := docker compose -f docker-compose.yml
COMPOSE_DEV := docker compose -f docker-compose.yml -f docker-compose.dev.yml
DOCKER_RUN  := $(COMPOSE_DEV) run --rm --no-deps

BLUE  := \033[0;34m
GREEN := \033[0;32m
NC    := \033[0m

help: ## Displays this help menu
	@echo "\n$(BLUE)Available development commands (100% Containerized):$(NC)\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""

install: ## Installs monorepo dependencies inside Docker container
	@echo "$(BLUE)==> [Docker] Installing dependencies with Bun...$(NC)"
	docker run --rm -v $$(pwd):/app -w /app oven/bun:1.4-alpine bun install --frozen-lockfile --ignore-scripts

dev: ## Starts all services with live reload
	$(COMPOSE_DEV) up

test: ## Runs unit and integration test suites
	$(DOCKER_RUN) api bun run test

typecheck: ## Validates TypeScript static types across all packages
	$(DOCKER_RUN) api bun run typecheck

lint: ## Runs linters across the codebase
	$(DOCKER_RUN) api bun run lint

audit: ## Audits dependency supply chain
	$(DOCKER_RUN) api bun pm untrusted

check: ## Runs full verification pipeline (typecheck + lint + audit + test)
	$(MAKE) typecheck
	$(MAKE) lint
	$(MAKE) audit
	$(MAKE) test

start: ## Starts stack in background
	$(COMPOSE_DEV) up -d

stop: ## Stops stack
	$(COMPOSE_DEV) down

clean: ## Removes containers, networks, and build caches
	$(COMPOSE_DEV) down --remove-orphans -v
```

---

### 2. PHP / Symfony / RoadRunner Pattern
```makefile
# ==============================================================================
# Makefile — PHP / RoadRunner Application
# ==============================================================================
.DEFAULT_GOAL := help
.PHONY: help install dev test test-unit test-integration lint check start stop clean

COMPOSE     := docker compose -f docker-compose.yml
COMPOSE_DEV := docker compose -f docker-compose.yml -f docker-compose.dev.yml
DOCKER_RUN  := $(COMPOSE_DEV) run --rm --no-deps app

help: ## Displays this help menu
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[0;32m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Installs Composer dependencies in container
	$(DOCKER_RUN) composer install --no-interaction --prefer-dist

dev: ## Starts full stack (PHP + Database + Cache) with hot-reload
	$(COMPOSE_DEV) up

test-unit: ## Runs unit tests with PHPUnit
	$(DOCKER_RUN) vendor/bin/phpunit --testsuite unit

test-integration: ## Runs integration tests against running test DB
	$(MAKE) start
	$(DOCKER_RUN) vendor/bin/phpunit --testsuite integration
	$(MAKE) stop

lint: ## Runs PHPStan and PHP-CS-Fixer
	$(DOCKER_RUN) vendor/bin/phpstan analyse -l 8 src

check: lint test-unit ## Runs full pre-commit pipeline

clean: ## Stops and removes all containers and volumes
	$(COMPOSE_DEV) down --remove-orphans -v
```

---

### 3. Go CLI & Microservices Pattern
```makefile
# ==============================================================================
# Makefile — Go Application
# ==============================================================================
.DEFAULT_GOAL := help
.PHONY: help dev test lint build clean

APP_NAME   := my-service
DOCKER_RUN := docker run --rm -v $$(pwd):/app -w /app golang:1.24-alpine

help: ## Displays this help menu
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[0;32m%-20s\033[0m %s\n", $$1, $$2}'

test: ## Runs tests inside Go container
	$(DOCKER_RUN) go test -v -race -cover ./...

lint: ## Runs golangci-lint inside container
	docker run --rm -v $$(pwd):/app -w /app golangci/golangci-lint:latest golangci-lint run

build: ## Compiles static binary for Linux
	$(DOCKER_RUN) env CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o bin/$(APP_NAME) main.go

clean: ## Cleans build artifacts
	rm -rf bin/ coverage.txt
```
