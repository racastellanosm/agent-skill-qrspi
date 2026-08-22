# Docker & Orchestration Agent Skill

[![agentskills.io](https://img.shields.io/badge/spec-agentskills.io-blue.svg)](https://agentskills.io)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](../../LICENSE)

An open-standard engineering skill for AI coding assistants (Antigravity, Claude Code, Gemini CLI, Cursor, OpenAI Codex, OpenCode) that establishes a disciplined **"Zero Host Dependencies"** containerized development workflow using **Docker, Docker Compose, and Makefile orchestration**.

---

## 🎯 The Core Philosophy: Zero Host Dependencies

Developers and CI/CD environments frequently suffer from *"works on my machine"* syndrome caused by mismatched runtime versions, local global packages, or uncontained dependencies.

This skill establishes a strict invariant:
* **The host machine requires ONLY Docker (with Compose) and GNU Make.**
* No local installation of Node, Bun, PHP, Go, Python, Composer, or databases is allowed or assumed.
* All development servers, test suites, linters, static analyzers, and build tools execute inside deterministic containers.
* All actions are invoked through standardized, self-documenting `Makefile` targets.

---

## 📦 Universal Installation

Install this skill into your repository or globally on your system using `skills.sh`:

```bash
# Add to current workspace / project
npx skills add racastellanosm/agent-skills --skill docker-and-orchestration

# Or install globally for all projects
npx skills add racastellanosm/agent-skills --skill docker-and-orchestration -g
```

---

## 🧭 Key Architectural Guidelines

### 1. Makefile as the Universal Orchestrator
The `Makefile` serves as the deterministic interface for both human engineers and AI agents:
```bash
make help             # Self-documenting help menu
make install          # Containerized dependency installation
make dev              # Hot-reloading development environment (docker-compose)
make test             # Unit & integration tests via ephemeral container runners
make check            # Complete validation pipeline (typecheck + lint + audit + test)
make build            # Production multi-stage image build
```

### 2. Multi-Stage Hardened Dockerfiles
* **Stage 1 (Base/Deps):** Caches manifests, frozen lockfiles, and flags like `--ignore-scripts`.
* **Stage 2 (Test/Dev):** Equipped with developer tooling (e.g. Playwright, Chromium, Xdebug) and runs as a non-root user.
* **Stage 3 (Production):** Distroless or scratch base image, zero shell (`/bin/sh`), non-root `USER 1000:1000`, minimal attack surface.

### 3. Split Docker Compose Topology
* `docker-compose.yml`: Production-aligned baseline services, networking, and environment configurations.
* `docker-compose.dev.yml`: Development overrides (host volume mounts for hot-reload, debugging port mappings).

---

## 📂 Skill Architecture & Reference Guides

```text
skills/docker-and-orchestration/
├── SKILL.md                          # Open specification skill definition
├── README.md                         # Public documentation and usage guide
├── references/
│   ├── makefile-orchestration.md     # Targets contract, ephemeral runners, and examples (Bun, PHP, Go, Python)
│   ├── multi-stage-dockerfiles.md    # Multi-stage lifecycle, distroless selection, and hardening
│   ├── compose-topologies.md         # Split compose pattern (base vs dev overrides)
│   └── security-hardening.md         # Supply chain security, non-root user, and audit policies
└── scripts/
    └── verify-docker-stack.sh        # POSIX validation script for Makefiles & Dockerfiles
```

---

## 🧪 Verification Script

Run the built-in POSIX validator to check any project against this standard:

```bash
./skills/docker-and-orchestration/scripts/verify-docker-stack.sh <path-to-project>
```
