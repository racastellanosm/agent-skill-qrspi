# QRSPI Agent Skill (`qrspi-methodology`)

[![agentskills.io](https://img.shields.io/badge/spec-agentskills.io-blue.svg)](https://agentskills.io)
[![skills.sh](https://skills.sh/b/racastellanosm/agent-skill-qrspi)](https://skills.sh/racastellanosm/agent-skill-qrspi)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)


An agentic engineering methodology skill implementing the 5-phase **QRSPI** standard (**Q**uestion, **R**esearch, **S**tructure, **P**lan, **I**mplement) for AI coding assistants.

Adheres strictly to the [Agent Skills Open Specification](https://agentskills.io/specification).

---

## 🎯 What is QRSPI?

QRSPI enforces a strict phase-gated engineering process to eliminate hallucinations, prevent regressions, and enforce architectural integrity:

1. **Question**: Socratic stress-testing, failure-mode probing, and zero lazy questions (codebase pre-checked).
2. **Research**: Discover codebase ground truth, dependencies, and blast radius before modifying files.
3. **Structure**: Define architectural contracts, invariants, types, and trade-offs.
4. **Plan**: Formulate an atomic step-by-step checklist with verifiable commands.
5. **Implement**: Execute sequentially with automated lint/test validation.

---

## 📦 Installation

### 1. Via `skills.sh` / Vercel Labs CLI
```bash
# Add directly to your project workspace
npx skills add https://github.com/racastellanosm/agent-skill-qrspi

# Or search via find-skills
npx skills find qrspi
```

### 2. Via Quick One-Liner (POSIX curl)
```bash
# Install locally in current workspace (e.g. for Google Gemini / Antigravity)
curl -sSL https://raw.githubusercontent.com/racastellanosm/agent-skill-qrspi/main/install.sh | sh -s -- --local --harness=gemini

# Install locally for all supported harnesses
curl -sSL https://raw.githubusercontent.com/racastellanosm/agent-skill-qrspi/main/install.sh | sh -s -- --local --harness=all

# Or install globally for current user
curl -sSL https://raw.githubusercontent.com/racastellanosm/agent-skill-qrspi/main/install.sh | sh -s -- --global --harness=gemini
```

### 3. Via Repository Clone & Interactive Installer
```bash
git clone https://github.com/racastellanosm/agent-skill-qrspi.git
cd agent-skill-qrspi
./install.sh
```

### 4. Manual Installation
Copy the directory contents to your target harness path:

| Harness | Global Path | Workspace / Local Path |
| :--- | :--- | :--- |
| **Standard (agentskills.io)** | `~/.agents/skills/qrspi-methodology` | `.agents/skills/qrspi-methodology` |
| **Google Gemini** | `~/.gemini/skills/qrspi-methodology` | `.gemini/skills/qrspi-methodology` |
| **Anthropic Claude** | `~/.claude/skills/qrspi-methodology` | `.claude/skills/qrspi-methodology` |
| **OpenAI Codex** | `~/.codex/skills/qrspi-methodology` | `.codex/skills/qrspi-methodology` |
| **OpenCode** | `~/.opencode/skills/qrspi-methodology` | `.opencode/skills/qrspi-methodology` |

---

## 📂 Repository Layout

```
.
├── .github/                  # CI/CD workflows and CODEOWNERS
├── skills/
│   └── qrspi-methodology/    # 📦 Pure Agent Skill Package (agentskills.io / skills.sh)
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
│       │   ├── index-template.md # Template for .qrspi/INDEX.md living ADR
│       │   └── phases-checklist.md # Quick-reference phase gate checklist
│       └── scripts/
│           ├── verify-security.sh # POSIX security & integrity auditor
│           └── verify-session.sh  # Modular session validator
├── AGENTS.md                 # Repository governance & agent directives
├── CHANGELOG.md              # Version history following Keep a Changelog
├── install.sh                # Zero-dependency POSIX installation script
├── LICENSE                   # MIT License
└── README.md                 # Public documentation and discovery metadata
```

---

## 🧠 Memory, Modular Persistence & Team Handoffs

To eliminate gigantic monolithic documents and optimize token usage, each feature session is organized into a modular folder with 1 Markdown document per QRSPI stage:

```
my-project/
└── .qrspi/
    ├── INDEX.md                                    # Master registry & living ADR
    └── sessions/
        └── 2026-08-19-auth-v2-migration/          # Dedicated feature session directory
            ├── 1-question.md                      # Scope, requirements (FR/NFR), and acceptance criteria
            ├── 2-research.md                      # Codebase discoveries, dependencies, and blast radius
            ├── 3-structure.md                     # Contracts, types, and architectural decisions
            ├── 4-plan.md                          # Atomic step-by-step checklist with test commands
            └── 5-implement.md                     # Step execution log, test results, and final sign-off
```

### ⚡ Advantages of the Modular Architecture:
1. **Up to 80% Token Savings:** An implementation subagent only loads `3-structure.md` and `4-plan.md` into context, rather than carrying the entire verbose research history.
2. **Efficient Human Review:** 
   - **Design Review:** Architects and tech leads only review `3-structure.md`.
   - **Pull Request Review:** The team reviews `5-implement.md` to verify test execution and linter output.
3. **Living ADR (`.qrspi/INDEX.md`):** Maintains the centralized index of architectural decisions with direct relative links to each feature folder.

---

## ⚡ Dynamic Model Tiering & Cognitive Load Routing

QRSPI dynamically matches task complexity with the appropriate AI model weight to balance cost, token efficiency, and architectural reasoning:

| Phase | Cognitive Weight | Target Model Category | Function |
| :--- | :---: | :--- | :--- |
| **1. Question** | **MEDIUM** | Standard Reasoning (`Gemini 3.7 Flash` / `Claude 3.7 Sonnet` / `GPT-4o`) | Proactive Socratic probing, ambiguity clarification. |
| **2. Research** | **HIGH** | Deep Reasoning (`Gemini 3.1 Pro` / `Claude 3.7 Sonnet-Thinking` / `o3-mini`) | Codebase traversal, AST mapping, blast radius analysis. |
| **3. Structure** | **HIGH** | Deep Reasoning (`Gemini 3.1 Pro` / `Claude 3.7 Sonnet-Thinking` / `o1`) | Contract design, architectural invariants, trade-offs. |
| **4. Plan** | **HIGH** | Deep Reasoning (`Gemini 3.1 Pro` / `Claude 3.7 Sonnet-Thinking`) | Atomic task breakdown, test-first strategy. |
| **5. Implement** | **LOW / FAST** | Fast Execution (`Gemini 3.7 Flash` / `Claude 3.5 Haiku` / `GPT-4o-mini`) | Atomic file edits, test runner execution, linting. |

---

## 🔗 References & Further Reading

- [Everything We Got Wrong About Research-Plan-Implement](https://www.youtube.com/watch?v=YwZR6tc7qYg) by [Dexter Horthy](https://github.com/dexhorthy)
- [From RPI to QRSPI: Rebuilding the First Structured Workflow for Coding Agents](https://alexlavaee.me/blog/from-rpi-to-qrspi/) by [Alex Lavaee](https://github.com/lavaman131)
- [Harness Engineering for Coding Agents](https://www.humanlayer.dev/blog/skill-issue-harness-engineering-for-coding-agents) by [HumanLayer](https://www.humanlayer.dev/)
- [grill-me: Relentless Interviewing Skill for Coding Agents](https://skills.sh/mattpocock/skills/grill-me) by [Matt Pocock](https://github.com/mattpocock)

---

## 📄 License

Licensed under the [MIT License](LICENSE).
