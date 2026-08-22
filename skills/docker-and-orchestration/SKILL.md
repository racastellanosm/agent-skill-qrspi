---
name: docker-and-orchestration
description: Enforces the Zero-Host-Dependencies engineering philosophy using Docker, Docker Compose, and a unified Makefile orchestration layer. Triggers when creating, refactoring, or containerizing applications, writing multi-stage Dockerfiles (Distroless/Scratch/Alpine), setting up split Compose topologies (base + dev overrides), or standardizing development workflows with deterministic Makefile targets.
version: 1.0.0
author: Raul Castellanos
license: MIT
compatibility:
  - gemini-cli
  - antigravity
  - claude-code
  - codex
  - cursor
  - opencode
categories:
  - devops
  - containerization
  - workflow
  - architecture
allowed-tools:
  - view_file
  - grep_search
  - find_by_name
  - list_dir
  - run_command
  - write_to_file
  - replace_file_content
---

# Docker & Orchestration Engineering Skill

This skill guides AI agents and engineers to build, standardize, and maintain containerized software environments following the **Zero Host Dependencies** philosophy:

> 🛡️ **Zero Host Dependencies Invariant:**  
> The host machine requires **only Docker (with Compose) and GNU Make**.  
> All runtimes (Bun, Node, PHP, Go, Python), package managers, linters, test runners, and database CLIs MUST execute inside isolated, ephemeral containers.

---

## 🧭 Core Architectural Pillars

```
[ Makefile Orchestrator ] ➔ [ Split Compose Layer ] ➔ [ Multi-Stage Container ]
       (make <target>)         (base vs .dev.yml)        (deps ➔ test ➔ distroless)
```

1. **Deterministic Makefile Contract**: Every development, testing, linting, and build workflow is invoked via standard Makefile targets (`make dev`, `make test`, `make check`, `make build`). Never execute raw ad-hoc host runtime commands.
2. **Split Docker Compose Topology**: Clean separation between baseline service definitions (`docker-compose.yml`) and local developer convenience overrides (`docker-compose.dev.yml`) for live code-mounting and hot-reload.
3. **Multi-Stage & Hardened Container Architecture**:
   - `Stage 1 (Base & Deps)`: Caching manifests with deterministic lockfiles and `--ignore-scripts`.
   - `Stage 2 (Test & Dev)`: Test runners and tooling with non-root privileges.
   - `Stage 3 (Production)`: Distroless, scratch, or minimal alpine runtime without shell access or dev dependencies.
4. **Ephemeral Test Runners**: Use `DOCKER_RUN := $(COMPOSE_DEV) run --rm --no-deps` to run unit tests and linters in ephemeral containers without side effects or orphaned resources.
5. **Supply Chain & Security Hardening**: Non-root execution (`USER 1000:1000`), read-only root filesystems, and strict audit checks.

---

## 📚 Deep-Dive References (On-Demand Retrieval)

When designing or modifying Dockerfiles, Compose setups, or Makefiles, load the specific reference guides:

* **[Makefile Orchestration Standards](references/makefile-orchestration.md)**: Universal target contract, self-documenting help menu, ephemeral runner pattern, and stack-specific examples (Bun, PHP, Go, Python).
* **[Multi-Stage Dockerfile Guidelines](references/multi-stage-dockerfiles.md)**: 3-stage pattern (Base ➔ Test/Dev ➔ Distroless Production), image selection matrix, and technology-specific patterns.
* **[Split Compose Topologies](references/compose-topologies.md)**: Structuring `docker-compose.yml` vs `docker-compose.dev.yml`, volume mounts, networking, and secret handling.
* **[Container Security Hardening](references/security-hardening.md)**: Non-root user policies, supply chain integrity, minimal attack surface, and security audits.

---

## 🛠️ Verification Command

Audit any project's Makefile and Docker configuration for compliance with this standard:

```bash
./skills/docker-and-orchestration/scripts/verify-docker-stack.sh <target-directory>
```
