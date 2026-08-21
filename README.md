# Agent Skills Catalog (`racastellanosm/agent-skills`)

[![agentskills.io](https://img.shields.io/badge/spec-agentskills.io-blue.svg)](https://agentskills.io)
[![skills.sh](https://skills.sh/b/racastellanosm/agent-skills)](https://skills.sh/racastellanosm/agent-skills)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A curated collection of open-standard, production-grade autonomous agent skills for AI coding assistants (Antigravity, Claude Code, Gemini CLI, Cursor, Codex, OpenCode, and 70+ supported harnesses).

Built and published in strict compliance with the [Agent Skills Open Specification](https://agentskills.io/specification) and distributed via [skills.sh](https://skills.sh).

---

## 🗂️ Skills Catalog

| Skill | Category | Description | Triggers / Activation | Documentation |
| :--- | :--- | :--- | :--- | :--- |
| [`qrspi-methodology`](skills/qrspi-methodology) | **Engineering Methodology** | Enforces the deterministic 5-phase engineering protocol (Question, Research, Structure, Plan, Implement) with turn-termination gates and living ADR. | Complex features, architectural refactors, multi-file bug investigations, system migrations. | [Read Specification](skills/qrspi-methodology/SKILL.md) |

---

## 📦 Universal Installation

Install any skill directly into your project or globally on your system via the official `skills.sh` CLI:

```bash
# Add to current workspace / project
npx skills add racastellanosm/agent-skills

# Install globally for all projects on your machine
npx skills add racastellanosm/agent-skills -g

# Discover in interactive search
npx skills find qrspi
```

### 🤖 Multi-Harness Interoperability
Skills in this catalog are compatible with **77+ agent harnesses**, including:
* **Google Gemini & Antigravity** (`.gemini/skills/`, `.agents/skills/`)
* **Anthropic Claude Code** (`.claude/skills/`)
* **OpenAI Codex & CLI** (`.codex/skills/`)
* **Cursor & Cline** (`.cursor/skills/`, `.cline/skills/`)
* **OpenCode, Amp, Zed, Warp** (`.opencode/skills/`, `.agents/skills/`)

---

## 🌟 Featured Skill: QRSPI Methodology (`qrspi-methodology`)

The **QRSPI** engineering methodology is a deterministic 5-phase workflow designed to eliminate LLM hallucinations, prevent silent regressions, and guarantee architectural alignment:

```
[ 1. QUESTION ] ➔ [ 2. RESEARCH ] ➔ [ 3. STRUCTURE ] ➔ [ 4. PLAN ] ➔ [ 5. IMPLEMENT ]
```

### 🛑 Non-Negotiable Invariant: Mandatory Turn Termination
* **One Phase per Turn:** The agent is strictly prohibited from running multiple phases in a continuous unmonitored loop.
* **User Sign-Off Gates:** After persisting each phase artifact, the agent stops execution, outputs its findings/questions, and waits for explicit user review before advancing.
* **4-Pillar Interrogation Matrix:** In Phase 1, the agent proactively interrogates Stack, Architecture (DDD), Testing (TDD), and Concurrency invariants before proposing implementation.

### 🧠 Modular Memory & Living ADR
Each feature lifecycle is organized into a dedicated session folder with one document per stage:
```text
my-project/
└── .qrspi/                                         # Configurable root (.qrspi/, .docs/, .implementations/, .sessions/)
    ├── INDEX.md                                    # Master registry & living ADR
    └── 2026-08-21-auth-v2-migration/               # Dedicated feature session directory directly under root
        ├── 1-question.md                           # Scope, requirements (FR/NFR), and acceptance criteria
        ├── 2-research.md                           # Codebase discoveries, dependencies, and blast radius
        ├── 3-structure.md                          # Contracts, types, and architectural decisions
        ├── 4-plan.md                               # Atomic step-by-step checklist with test commands
        └── 5-implement.md                          # Step execution log, test results, and final sign-off
```

### ⚡ Dynamic Model Tiering & Cognitive Load Routing
| Phase | Cognitive Weight | Target Model Category | Function |
| :--- | :---: | :--- | :--- |
| **1. Question** | **MEDIUM** | Standard Reasoning (`Gemini 3.7 Flash` / `Claude 3.7 Sonnet` / `GPT-4o`) | Proactive Socratic probing, ambiguity clarification. |
| **2. Research** | **HIGH** | Deep Reasoning (`Gemini 3.1 Pro` / `Claude 3.7 Sonnet-Thinking` / `o3-mini`) | Codebase traversal, AST mapping, blast radius analysis. |
| **3. Structure** | **HIGH** | Deep Reasoning (`Gemini 3.1 Pro` / `Claude 3.7 Sonnet-Thinking` / `o1`) | Contract design, architectural invariants, trade-offs. |
| **4. Plan** | **HIGH** | Deep Reasoning (`Gemini 3.1 Pro` / `Claude 3.7 Sonnet-Thinking`) | Atomic task breakdown, test-first strategy. |
| **5. Implement** | **LOW / FAST** | Fast Execution (`Gemini 3.7 Flash` / `Claude 3.5 Haiku` / `GPT-4o-mini`) | Atomic file edits, test runner execution, linting. |

---

## 📂 Repository Architecture

```text
.
├── .github/                  # CI/CD workflows, CODEOWNERS, and security auditor
│   └── scripts/
│       └── verify-security.sh # POSIX security & integrity auditor
├── skills/
│   └── qrspi-methodology/    # 📦 Canonical QRSPI Agent Skill Package
│       ├── SKILL.md          # Canonical Agent Skill specification & prompt rules
│       ├── hooks/
│       │   └── prompt-hook.sh # Agent Lifecycle Hook (Claude Code / Gemini CLI)
│       ├── references/
│       │   ├── stage-templates/ # Modular stage templates (1-question.md -> 5-implement.md)
│       │   │   ├── 1-question.md
│       │   │   ├── 2-research.md
│       │   │   ├── 3-structure.md
│       │   │   ├── 4-plan.md
│       │   │   └── 5-implement.md
│       │   ├── index-template.md # Template for living ADR
│       │   └── phases-checklist.md # Quick-reference phase gate checklist
│       └── scripts/
│           └── verify-session.sh  # Modular session validator
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
3. Add any reference templates or documentation inside `skills/<new-skill-slug>/references/`.
4. Register the new skill in `skills.sh.json` under the appropriate grouping.

---

## 🔗 References & Ecosystem

- [Agent Skills Open Specification](https://agentskills.io/specification)
- [skills.sh Registry](https://skills.sh)
- [Everything We Got Wrong About Research-Plan-Implement](https://www.youtube.com/watch?v=YwZR6tc7qYg) by [Dexter Horthy](https://github.com/dexhorthy)
- [From RPI to QRSPI: Rebuilding Structured Workflows for Coding Agents](https://alexlavaee.me/blog/from-rpi-to-qrspi/) by [Alex Lavaee](https://github.com/lavaman131)
- [Harness Engineering for Coding Agents](https://www.humanlayer.dev/blog/skill-issue-harness-engineering-for-coding-agents) by [HumanLayer](https://www.humanlayer.dev/)
- [grill-me: Relentless Interviewing Skill for Coding Agents](https://skills.sh/mattpocock/skills/grill-me) by [Matt Pocock](https://github.com/mattpocock)

---

## 📄 License

Licensed under the [MIT License](LICENSE).
