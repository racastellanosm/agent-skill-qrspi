# My Everyday Engineering Agent Skills

[![agentskills.io](https://img.shields.io/badge/spec-agentskills.io-blue.svg)](https://agentskills.io)
[![skills.sh](https://skills.sh/b/racastellanosm/agent-skills)](https://skills.sh/racastellanosm/agent-skills)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A curated collection of open-standard, production-grade autonomous agent skills for AI coding assistants (Antigravity, Claude Code, Gemini CLI, Cursor, Codex, OpenCode, and 70+ supported harnesses).

Built and published in strict compliance with the [Agent Skills Open Specification](https://agentskills.io/specification) and distributed via [skills.sh](https://skills.sh).

---

## 🗂️ Skills Catalog

| Skill | Category | Description | Triggers / Activation | Documentation |
| :--- | :--- | :--- | :--- | :--- |
| [`qrspi-methodology`](skills/qrspi-methodology) | **Engineering Methodology** | Enforces the deterministic 5-phase engineering protocol (Question, Research, Structure, Plan, Implement) with turn-termination gates and living ADR. | Complex features, architectural refactors, multi-file bug investigations, system migrations. | [📖 User Guide](skills/qrspi-methodology/README.md) · [⚙️ Spec](skills/qrspi-methodology/SKILL.md) |
| [`docker-and-orchestration`](skills/docker-and-orchestration) | **DevOps & Containerization** | Enforces Zero-Host-Dependencies containerized workflows using Docker, split Compose topologies, and universal Makefile orchestration. | Setting up Docker/Makefiles, writing multi-stage Dockerfiles, configuring Compose, standardizing local dev commands. | [📖 User Guide](skills/docker-and-orchestration/README.md) · [⚙️ Spec](skills/docker-and-orchestration/SKILL.md) |

---

## 📦 Universal Installation

Install any skill directly into your project or globally on your system via the official `skills.sh` CLI:

```bash
# Add to current workspace / project
npx skills add racastellanosm/agent-skills

# Or install a specific skill
npx skills add racastellanosm/agent-skills --skill ${skill_name}

# Install globally for all projects on your machine
npx skills add racastellanosm/agent-skills -g

# Discover in interactive search
npx skills find qrspi
```

---

## 🤖 Multi-Harness Interoperability

Skills in this catalog are compatible with **77+ agent harnesses**, including:
* **Google Gemini & Antigravity** (`.gemini/skills/`, `.agents/skills/`)
* **Anthropic Claude Code** (`.claude/skills/`)
* **OpenAI Codex & CLI** (`.codex/skills/`)
* **Cursor & Cline** (`.cursor/skills/`, `.cline/skills/`)
* **OpenCode, Amp, Zed, Warp** (`.opencode/skills/`, `.agents/skills/`)

---

## 📂 Repository Architecture

```text
.
├── .github/                  # CI/CD workflows, CODEOWNERS, and security auditor
│   └── scripts/
│       └── verify-security.sh # POSIX security & integrity auditor
├── skills/
│   ├── qrspi-methodology/    # 📦 Canonical QRSPI Agent Skill Package
│   │   ├── SKILL.md          # Canonical Agent Skill specification & prompt rules
│   │   ├── README.md         # Detailed skill documentation & user guide
│   │   ├── hooks/
│   │   │   └── prompt-hook.sh # Agent Lifecycle Hook (Claude Code / Gemini CLI)
│   │   ├── references/
│   │   │   ├── stage-templates/ # Modular stage templates (1-question.md -> 5-implement.md)
│   │   │   │   ├── 1-question.md
│   │   │   │   ├── 2-research.md
│   │   │   │   ├── 3-structure.md
│   │   │   │   ├── 4-plan.md
│   │   │   │   └── 5-implement.md
│   │   │   ├── index-template.md # Template for living ADR
│   │   │   └── phases-checklist.md # Quick-reference phase gate checklist
│   │   └── scripts/
│   │       └── verify-session.sh  # Modular session validator
│   └── docker-and-orchestration/ # 📦 Canonical Docker & Orchestration Skill Package
│       ├── SKILL.md          # Canonical Agent Skill specification (agentskills.io)
│       ├── README.md         # Public documentation and usage guide
│       ├── references/
│       │   ├── makefile-orchestration.md # Targets contract, runners & examples
│       │   ├── multi-stage-dockerfiles.md # Multi-stage patterns, distroless & security
│       │   ├── compose-topologies.md # Split compose strategy (base vs dev)
│       │   └── security-hardening.md # Container security invariants & audit checks
│       └── scripts/
│           └── verify-docker-stack.sh # POSIX validator for Makefiles & Dockerfiles
├── AGENTS.md                 # Repository governance & agent directives
├── CHANGELOG.md              # Version history following Keep a Changelog
├── LICENSE                   # MIT License
├── README.md                 # Public documentation and catalog metadata
└── skills.sh.json            # skills.sh catalog grouping & metadata configuration
```

---

## 🛠️ Adding New Skills to this Catalog

This repository follows the **agentskills.io Open Monorepo Standard**. To contribute or add a new skill:

1. Create a new directory under `skills/<new-skill-slug>/`.
2. Add a compliant `SKILL.md` with YAML frontmatter (`name`, `description`, `version`, `allowed-tools`).
3. Add a human-readable `README.md` inside `skills/<new-skill-slug>/` documenting user workflows.
4. Add any reference templates or documentation inside `skills/<new-skill-slug>/references/`.
5. Register the new skill in `skills.sh.json` and the root `README.md` catalog table.

---

## 🔗 References & Ecosystem

- [Agent Skills Open Specification](https://agentskills.io/specification)
- [skills.sh Registry](https://skills.sh)

---

## 📄 License

Licensed under the [MIT License](LICENSE).
