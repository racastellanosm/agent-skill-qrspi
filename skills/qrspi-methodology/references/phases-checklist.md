# QRSPI Phase Validation Checklist

Use this checklist to ensure phase-gates and user sign-offs are strictly completed before advancing across QRSPI phases. **Invariant:** Exactly one phase executed per turn.

## Phase 1: Question
- [ ] Autonomous pre-check executed ("Zero Lazy Questions" rule: code explored before asking).
- [ ] Foundational interrogation completed across 5 pillars (Stack, Architecture/DDD, TDD/Testing, Concurrency, Session Destination).
- [ ] Requirements explicitly divided into Functional (FR) and Non-Functional (NFR).
- [ ] Socratic stress-testing applied across 4 failure vectors (failure modes, concurrency, migration, boundaries).
- [ ] Decision trees walked branch-by-branch and structured options formulated with trade-offs.
- [ ] `1-question.md` written to configured session folder.
- [ ] **MANDATORY HARD STOP:** Agent ended turn, presented questions, and received explicit user approval.

## Phase 2: Research
- [ ] Cognitive tier alignment: HIGH (Deep Reasoning / Extended Thinking).
- [ ] Source files read and verified via tool calls (`view_file`, `grep_search`).
- [ ] Existing codebase conventions and idioms documented.
- [ ] Dependencies and toolchain versions confirmed.
- [ ] Blast radius and affected downstream components mapped.
- [ ] `2-research.md` written to session folder.
- [ ] **MANDATORY HARD STOP:** Agent ended turn, presented findings, and received explicit user approval.

## Phase 3: Structure
- [ ] Cognitive tier alignment: HIGH (Deep Reasoning / Architecture).
- [ ] Target file topology established (`CREATE`, `MODIFY`, `DEPRECATE`).
- [ ] Data contracts, types, and public interfaces declared.
- [ ] Trade-offs evaluated and architectural decisions justified.
- [ ] Error handling patterns and edge cases defined.
- [ ] `3-structure.md` and `INDEX.md` written.
- [ ] **MANDATORY HARD STOP:** Agent ended turn, presented design, and received explicit user approval.

## Phase 4: Plan
- [ ] Cognitive tier alignment: HIGH (Task Breakdown).
- [ ] Step-by-step checklist decomposed into atomic changes.
- [ ] Automated verification command defined for each step.
- [ ] TDD/Test-first approach applied where feasible.
- [ ] `4-plan.md` written to session folder.
- [ ] **MANDATORY HARD STOP:** Agent ended turn, presented plan, and received explicit user approval before modifying code.

## Phase 5: Implement
- [ ] Cognitive tier alignment: LOW / FAST (Atomic Coder / Execution Engine).
- [ ] Code modifications applied atomically according to `4-plan.md`.
- [ ] Existing code style, linter rules, and comments preserved.
- [ ] All verification commands executed and passing.
- [ ] Zero regressions against acceptance criteria.
- [ ] `5-implement.md` and `INDEX.md` written.
- [ ] **MANDATORY HARD STOP:** Agent ended turn, presented verification proof, and requested final user acceptance.
