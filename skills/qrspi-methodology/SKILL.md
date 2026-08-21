---
name: qrspi-methodology
description: Enforces the QRSPI (Question, Research, Structure, Plan, Implement) engineering methodology. Triggers whenever starting complex features, architectural refactors, multi-file bug investigations, system migrations, or new implementations to ensure zero hallucinations and deterministic software delivery.
version: 1.12.3
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
  - workflow
  - architecture
  - quality-assurance
allowed-tools:
  - view_file
  - grep_search
  - find_by_name
  - list_dir
  - run_command
  - write_to_file
  - replace_file_content
  - ask_question
---

# QRSPI Methodology: Engineering Workflow Guide

The **QRSPI** methodology is an agentic engineering protocol designed to guarantee deterministic, high-quality, and regression-free software outcomes across 5 sequential phases:

```
[ 1. QUESTION ] ➔ [ 2. RESEARCH ] ➔ [ 3. STRUCTURE ] ➔ [ 4. PLAN ] ➔ [ 5. IMPLEMENT ]
```

## 🎯 What is QRSPI?

QRSPI enforces a strict phase-gated engineering process to eliminate hallucinations, prevent regressions, and enforce architectural integrity:

1. **Question**: Socratic stress-testing, failure-mode probing, and zero lazy questions (codebase pre-checked).
2. **Research**: Discover codebase ground truth, dependencies, and blast radius before modifying files.
3. **Structure**: Define architectural contracts, invariants, types, and trade-offs.
4. **Plan**: Formulate an atomic step-by-step checklist with verifiable commands.
5. **Implement**: Execute sequentially with automated lint/test validation.

> 🛑 **Invariant: Exactly One Phase per Turn.**  
> The agent pauses execution and ends its turn at every single phase, presenting its findings, questions, or plan for explicit user approval before advancing.

---

## 🛑 Non-Negotiable Invariant: Mandatory Turn Termination & User Sign-Off

> [!IMPORTANT]
> **STRICT EXECUTION GATE: EXACTLY ONE PHASE PER TURN.**  
> AI Agents **MUST NEVER** execute multiple QRSPI phases in a single continuous turn. At the completion of **EVERY SINGLE PHASE** (after persisting the stage artifact), the agent **MUST STOP CALLING TOOLS, OUTPUT ITS SUMMARY AND QUESTIONS TO THE USER, AND END ITS TURN**.  
> The agent is **STRICTLY PROHIBITED** from advancing to the subsequent phase until the user explicitly reviews, debugs, and confirms approval in their response.

---

## ⚠️ Anti-Triggers (When NOT to trigger QRSPI)

Do **NOT** trigger the 5-phase QRSPI workflow for:
1. **Trivial 1-2 Line Edits & Typos**: Simple spelling corrections, formatting fixes, or single-line syntax adjustments.
2. **Pure Informational Lookups**: Answering user questions about code behavior, architecture explanation, or file navigation without modifications.
3. **Direct Version Control & Release Commands**: Branching, tagging, pushing, or opening PRs upon explicit user command.
4. **Ad-hoc Scratch Tasks**: Running one-off debugging scripts or exploratory CLI inspections.

---

## Session Directory Protocol & Persistence

QRSPI persists session records directly under the configured session root:
- Master ADR registry: `<session-root>/INDEX.md`
- Active session files: `<session-root>/YYYY-MM-DD-<slug>/1-question.md` through `5-implement.md`

### 🔍 Automated Discovery & Zero-Overhead Persistence Rule:
1. **Existing Repository Scan (Zero Lazy Questions):** Before prompting the user, the agent checks if any session root or `INDEX.md` already exists (`.qrspi/`, `.docs/`, `.implementations/`, `.sessions/`) or if `AGENTS.md` defines a preferred root. If found, the agent **automatically adopts that root without re-asking**.
2. **Fresh Repository Setup (First-Time Interrogation):** If no session root or `INDEX.md` exists anywhere in the repository, the agent **MUST include the session destination as Pillar 5 in the Phase 1 Foundation Interrogation Matrix**:
   - **`.qrspi/`** *(Default / Recommended - Isolated hidden folder)*
   - **`.docs/`** *(Standard visible project documentation)*
   - **`.implementations/`** *(Dedicated architecture and delivery records)*
   - **`.sessions/`** *(Permanent or temporal session directory)*
   - **Custom Path** *(User-specified directory)*
3. **Persistent ADR Anchor:** Upon user confirmation, the agent creates `<chosen-root>/INDEX.md` with `**Configured Session Root:** <path>`, guaranteeing that all subsequent feature sessions automatically persist in that directory.

---

## Phase 1: Question (Scope, Socratic Stress-Testing & Alignment)

### Goal
Eliminate requirements ambiguity, challenge implicit assumptions, stress-test design branches, and establish shared technical alignment before modifying code.

### Action Items
1. **Autonomous Codebase Pre-Check ("Zero Lazy Questions" Rule)**: Before asking the user any question, actively explore the workspace (`grep_search`, `view_file`, `find_by_name`) to answer questions where codebase context is already available. Never ask what the repository already tells you.
2. **Mandatory Foundation Interrogation ("Zero Assumptions" Rule)**: If the workspace or prompt leaves foundational design dimensions underspecified, the agent **MUST NOT ASSUME**. It MUST proactively interrogate the user across 5 foundational pillars:
   - **1. Stack & Ecosystem:** Target programming language, runtime version, allowed external dependencies vs zero-dependency standard library.
   - **2. Architectural Paradigm:** Design methodology (Domain-Driven Design / DDD, Clean Architecture / Hexagonal, OOP vs Functional, Modular Monolith).
   - **3. Quality & Testing Methodology:** Testing strategy (Test-Driven Development / TDD, unit vs integration, mock strategy, property testing).
   - **4. Concurrency & State Invariants:** Thread safety, sync vs async, in-memory vs persistent storage, error modeling (Result types, exceptions, error codes).
   - **5. Session Persistence Root:** If no prior session root exists, confirm where QRSPI sessions & `INDEX.md` should live (`.qrspi/`, `.docs/`, `.implementations/`, `.sessions/`, or custom).
3. **Deconstruct Requirements**: Break down the user prompt into explicit Functional Requirements (FRs) and Non-Functional Requirements (NFRs).
4. **Socratic Stress-Testing (4 Failure Vectors)**: Proactively probe and stress-test the proposal across:
   - **Failure Modes & Resilience**: Downstream outages, network timeouts, fallback behaviors.
   - **Concurrency & Idempotency**: Race conditions, parallel mutations, duplicate submissions.
   - **Backward Compatibility & Migrations**: Breaking API contracts, legacy schema conversions.
   - **Boundary Conditions & Limits**: Empty collections, null states, extreme payload sizes.
5. **Walk Decision Trees Branch-by-Branch**: When multiple architectural paths exist, present 2-3 structured options with trade-offs and validate interactively with the user (`ask_question` / prompt).
6. **Persist Stage 1**: Write `<session-root>/YYYY-MM-DD-<feature-slug>/1-question.md` (e.g. `.qrspi/YYYY-MM-DD-<feature-slug>/1-question.md`).

### Mandatory Hard Stop (Turn Termination)
> 🛑 **MANDATORY GATE:** Output the foundational questions (stack, architecture, TDD/methodology, session root), failure vectors, and requirements breakdown to the user. **STOP calling tools and END YOUR TURN.** Do NOT proceed to Phase 2 until the user reviews and confirms approval.

---

## Phase 2: Research (Deep Context & Codebase Discovery)

### Goal
Establish ground-truth facts about the current state of the codebase, dependencies, and execution environment. Never assume code structure from memory.

### Action Items
1. **Locate Existing Patterns**: Use ripgrep (`grep_search`), file finders (`find_by_name`), and AST/symbol tools to discover how similar features are implemented.
2. **Trace Data & Control Flow**: Read relevant source files end-to-end (`view_file`), mapping input entry points, transformers, and output boundaries.
3. **Verify Dependencies & Toolchains**: Inspect lockfiles, build configurations (`package.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`), and runtime versions.
4. **Persist Stage 2**: Write `<session-root>/YYYY-MM-DD-<feature-slug>/2-research.md`.

### Mandatory Hard Stop (Turn Termination)
> 🛑 **MANDATORY GATE:** Output verifiable line-number references, interface findings, and dependency confirmations to the user. **STOP calling tools and END YOUR TURN.** Do NOT proceed to Phase 3 until the user reviews and confirms approval.

---

## Phase 3: Structure (System & Architectural Design)

### Goal
Formulate the architectural blueprint, data structures, invariants, and interface contracts prior to code modification.

### Action Items
1. **Define Core Abstractions**: Model data contracts, types, schema updates, and public API boundaries.
2. **Evaluate Trade-offs**: Contrast 2+ technical approaches (e.g., performance vs. complexity, sync vs. async) and justify the chosen path.
3. **Map Error Handling & Invariants**: Enumerate error states, fallback behaviors, concurrency locks, and idempotency guarantees.
4. **Persist Stage 3 & Register ADR**: Write `<session-root>/YYYY-MM-DD-<feature-slug>/3-structure.md` and append the record to `<session-root>/INDEX.md`.

### Mandatory Hard Stop (Turn Termination)
> 🛑 **MANDATORY GATE:** Output the architecture design, types, and trade-offs to the user. **STOP calling tools and END YOUR TURN.** Do NOT proceed to Phase 4 until the user reviews and approves the design.

---

## Phase 4: Plan (Atomic, Verifiable Execution Plan)

### Goal
Construct a deterministic, step-by-step checklist where each action has a corresponding validation step.

### Action Items
1. **Break Down Tasks Atomically**: Each step must represent a single logical change (e.g., 1 type definition, 1 test suite, 1 module update).
2. **Define Test Strategy**: Formulate unit tests, integration tests, or end-to-end verification commands for each step.
3. **Establish Rollback/Checkpoints**: Ensure each phase leaves the repository in a compilable/testable state.
4. **Persist Stage 4**: Write `<session-root>/YYYY-MM-DD-<feature-slug>/4-plan.md`.

### Mandatory Hard Stop (Turn Termination)
> 🛑 **MANDATORY GATE:** Output the step-by-step checklist and automated verification commands to the user. **STOP calling tools and END YOUR TURN.** Do NOT modify source code or start Phase 5 until the user gives explicit approval.

---

## Phase 5: Implement (Strict Execution & Verification)

### Goal
Execute the plan with zero regressions, strict test coverage, and continuous validation.

### Action Items
1. **Atomic Code Changes**: Follow the checklist sequentially using targeted edit tools (`replace_file_content` / `write_to_file`). Avoid sweeping unstaged rewrites.
2. **Preserve Code Quality & Style**: Strictly match existing idioms, linter rules, typing standards, and comments/docstrings.
3. **Execute Automated Verification**: Run compilers, linters, and test suites after every logical step (`rtk` or native test runner).
4. **Persist Stage 5 & Update ADR**: Write `<session-root>/YYYY-MM-DD-<feature-slug>/5-implement.md` and update status in `<session-root>/INDEX.md`.
5. **Final Regression Sweep**: Verify edge cases, error conditions, and user acceptance criteria against `1-question.md`.

### Final Sign-Off & Verification Proof
> 🛑 **MANDATORY GATE:** Output the execution summary, test suite results, and proof of verification to the user and request final acceptance.

---

## Modular Artifact Storage & Memory Handoff Protocol

To prevent oversized documents, maintain token-efficient context, and enable frictionless team and cross-agent handoffs:

```
<session-root>/ (e.g. .qrspi/, .docs/, .implementations/, .sessions/)
├── INDEX.md                                    # Master Registry & Living ADR
└── YYYY-MM-DD-<feature-slug>/                  # Dedicated session directory per feature
    ├── 1-question.md                           # Scope, requirements & acceptance criteria
    ├── 2-research.md                           # Codebase ground truth, paths & blast radius
    ├── 3-structure.md                          # Contracts, schema updates & architecture decisions
    ├── 4-plan.md                               # Step-by-step checklist with verification commands
    └── 5-implement.md                          # Execution log, test results & handoff sign-off
```

### Handoff Mechanics:
- **Subagent / Resumed Task**: An implementer agent only needs to read `3-structure.md` and `4-plan.md` to start working immediately, saving up to 80% context tokens compared to monolithic files.
- **Design Review / PR Review**: Reviewers can review `3-structure.md` for architectural approval and `5-implement.md` for verification proof in Pull Requests.

---

## Dynamic Model Tiering & Cognitive Load Routing

To balance cost, speed, and reasoning depth, QRSPI enforces cognitive tiering across phases:

| Phase | Cognitive Load | Recommended Model Tier | Execution Strategy |
| :--- | :---: | :--- | :--- |
| **1. Question** | **MEDIUM** | Standard Reasoning (`Gemini 3.7 Flash` / `Claude 3.7 Sonnet` / `GPT-4o`) | Fast interactive clarification, ambiguity detection. |
| **2. Research** | **HIGH** | Deep Reasoning / Thinking (`Gemini 3.1 Pro` / `Claude 3.7 Sonnet-Thinking` / `o3-mini`) | Codebase AST discovery, deep dependency graphs, blast radius. |
| **3. Structure** | **HIGH** | Deep Reasoning / Thinking (`Gemini 3.1 Pro` / `Claude 3.7 Sonnet-Thinking` / `o1`) | Architectural invariant design, interface contracts, trade-offs. |
| **4. Plan** | **HIGH** | Deep Reasoning / Thinking (`Gemini 3.1 Pro` / `Claude 3.7 Sonnet-Thinking`) | Atomic task breakdown, test strategy formulation. |
| **5. Implement** | **LOW / FAST** | Fast Code Execution (`Gemini 3.7 Flash` / `Claude 3.5 Haiku` / `GPT-4o-mini`) | Atomic file edits, test runner execution, linter verification. |

### Harness Enforcement Rules:
1. **Subagent Delegation Mode (`invoke_subagent`)**:
   - For **Research, Structure, and Plan**, invoke subagents with `Model: "pro"`.
   - For **Implement**, invoke subagents with `Model: "flash"` or `Model: "flash_lite"`.
2. **Single-Agent / Interactive Mode**:
   - The agent MUST emit a **Model Tier Guardrail Notice** at phase boundaries whenever switching between High-reasoning and Fast-execution phases (e.g., *"💡 [QRSPI Guardrail]: Transitioning to Phase 3 (Structure). Recommended model weight: HIGH / Thinking"*).

---

## References & Templates
- [Stage 1: Question Template](references/stage-templates/1-question.md)
- [Stage 2: Research Template](references/stage-templates/2-research.md)
- [Stage 3: Structure Template](references/stage-templates/3-structure.md)
- [Stage 4: Plan Template](references/stage-templates/4-plan.md)
- [Stage 5: Implement Template](references/stage-templates/5-implement.md)
- [Living ADR Index Template](references/index-template.md)
- [Phase Validation Checklist](references/phases-checklist.md)
