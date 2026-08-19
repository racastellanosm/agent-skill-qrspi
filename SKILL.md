---
name: qrspi-methodology
description: Enforces the QRSPI (Question, Research, Structure, Plan, Implement) engineering methodology. Triggers whenever starting complex features, architectural refactors, multi-file bug investigations, system migrations, or new implementations to ensure zero hallucinations and deterministic software delivery.
version: 1.0.0
author: Platform Engineering
license: MIT
compatibility:
  - gemini-cli
  - antigravity
  - claude-code
  - codex-cli
  - opencode
metadata:
  standard: agentskills.io/v1
  category: engineering-methodology
  tags:
    - workflow
    - architecture
    - refactor
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

Every non-trivial engineering task **MUST** complete each phase sequentially before advancing to the next. Do not skip phases or jump straight to writing code.

---

## Phase 1: Question (Scope & Clarification)

### Goal
Eliminate requirements ambiguity, surface hidden constraints, and challenge implicit assumptions.

### Action Items
1. **Analyze User Intent**: Break down the prompt into functional requirements (FRs) and non-functional requirements (NFRs).
2. **Detect Incomplete Information**: Identify missing interfaces, environment expectations, backward-compatibility needs, and performance budgets.
3. **Ask Proactive Clarifications**: If critical ambiguities exist, ask concise, targeted questions before touching the codebase.
4. **Persist Stage 1**: Write `.qrspi/sessions/YYYY-MM-DD_<feature-slug>/1-question.md`.

### Hard Gate
> **Checkpoint:** Proceed to Phase 2 only when the problem statement and acceptance criteria are 100% deterministic and free of contradictions.

---

## Phase 2: Research (Deep Context & Codebase Discovery)

### Goal
Establish ground-truth facts about the current state of the codebase, dependencies, and execution environment. Never assume code structure from memory.

### Action Items
1. **Locate Existing Patterns**: Use ripgrep (`grep_search`), file finders (`find_by_name`), and AST/symbol tools to discover how similar features are implemented.
2. **Trace Data & Control Flow**: Read relevant source files end-to-end (`view_file`), mapping input entry points, transformers, and output boundaries.
3. **Verify Dependencies & Toolchains**: Inspect lockfiles, build configurations (`package.json`, `Cargo.toml`, `go.mod`, `pyproject.toml`), and runtime versions.
4. **Persist Stage 2**: Write `.qrspi/sessions/YYYY-MM-DD_<feature-slug>/2-research.md`.

### Hard Gate
> **Checkpoint:** Proceed to Phase 3 only with verifiable line-number references, interface definitions, and dependency confirmations documented.

---

## Phase 3: Structure (System & Architectural Design)

### Goal
Formulate the architectural blueprint, data structures, invariants, and interface contracts prior to code modification.

### Action Items
1. **Define Core Abstractions**: Model data contracts, types, schema updates, and public API boundaries.
2. **Evaluate Trade-offs**: Contrast 2+ technical approaches (e.g., performance vs. complexity, sync vs. async) and justify the chosen path.
3. **Map Error Handling & Invariants**: Enumerate error states, fallback behaviors, concurrency locks, and idempotency guarantees.
4. **Persist Stage 3 & Register ADR**: Write `.qrspi/sessions/YYYY-MM-DD_<feature-slug>/3-structure.md` and append the record to `.qrspi/INDEX.md`.

### Hard Gate
> **Checkpoint:** Proceed to Phase 4 only after the system design satisfies all Phase 1 requirements and Phase 2 codebase constraints.

---

## Phase 4: Plan (Atomic, Verifiable Execution Plan)

### Goal
Construct a deterministic, step-by-step checklist where each action has a corresponding validation step.

### Action Items
1. **Break Down Tasks Atomically**: Each step must represent a single logical change (e.g., 1 type definition, 1 test suite, 1 module update).
2. **Define Test Strategy**: Formulate unit tests, integration tests, or end-to-end verification commands for each step.
3. **Establish Rollback/Checkpoints**: Ensure each phase leaves the repository in a compilable/testable state.
4. **Persist Stage 4**: Write `.qrspi/sessions/YYYY-MM-DD_<feature-slug>/4-plan.md`.

### Hard Gate
> **Checkpoint:** `4-plan.md` must be instantiated and confirmed prior to modifying source code.

---

## Phase 5: Implement (Strict Execution & Verification)

### Goal
Execute the plan with zero regressions, strict test coverage, and continuous validation.

### Action Items
1. **Atomic Code Changes**: Follow the checklist sequentially using targeted edit tools (`replace_file_content` / `write_to_file`). Avoid sweeping unstaged rewrites.
2. **Preserve Code Quality & Style**: Strictly match existing idioms, linter rules, typing standards, and comments/docstrings.
3. **Execute Automated Verification**: Run compilers, linters, and test suites after every logical step (`rtk` or native test runner).
4. **Persist Stage 5 & Update ADR**: Write `.qrspi/sessions/YYYY-MM-DD_<feature-slug>/5-implement.md` and update status in `.qrspi/INDEX.md`.
5. **Final Regression Sweep**: Verify edge cases, error conditions, and user acceptance criteria against `1-question.md`.

---

## Modular Artifact Storage & Memory Handoff Protocol

To prevent oversized documents, maintain token-efficient context, and enable frictionless team and cross-agent handoffs:

```
.qrspi/
├── INDEX.md                                    # Master Registry & Living ADR
└── sessions/
    └── YYYY-MM-DD_<feature-slug>/             # Dedicated session directory per feature
        ├── 1-question.md                      # Scope, requirements & acceptance criteria
        ├── 2-research.md                      # Codebase ground truth, paths & blast radius
        ├── 3-structure.md                     # Contracts, schema updates & architecture decisions
        ├── 4-plan.md                          # Step-by-step checklist with verification commands
        └── 5-implement.md                     # Execution log, test results & handoff sign-off
```

### Handoff Mechanics:
- **Subagent / Resumed Task**: An implementer agent only needs to read `3-structure.md` and `4-plan.md` to start working immediately, saving up to 80% context tokens compared to monolithic files.
- **Design Review / PR Review**: Reviewers can review `3-structure.md` for architectural approval and `5-implement.md` for verification proof in Pull Requests.

---

## References & Templates
- [Stage 1: Question Template](references/stage-templates/1-question.md)
- [Stage 2: Research Template](references/stage-templates/2-research.md)
- [Stage 3: Structure Template](references/stage-templates/3-structure.md)
- [Stage 4: Plan Template](references/stage-templates/4-plan.md)
- [Stage 5: Implement Template](references/stage-templates/5-implement.md)
- [Living ADR Index Template](references/index-template.md)
- [Phase Validation Checklist](references/phases-checklist.md)
