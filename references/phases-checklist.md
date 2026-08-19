# QRSPI Phase Validation Checklist

Use this quick checklist to ensure quality gates are met before advancing across QRSPI phases:

## Phase 1: Question
- [ ] Requirements explicitly divided into Functional (FR) and Non-Functional (NFR).
- [ ] Ambiguities resolved via proactive clarification.
- [ ] Success criteria and acceptance gates stated testably.

## Phase 2: Research
- [ ] Source files read and verified via tool calls (`view_file`, `grep_search`).
- [ ] Existing codebase conventions and idioms documented.
- [ ] Dependencies and toolchain versions confirmed.
- [ ] Blast radius and affected downstream components mapped.

## Phase 3: Structure
- [ ] Target file topology established (`CREATE`, `MODIFY`, `DEPRECATE`).
- [ ] Data contracts, types, and public interfaces declared.
- [ ] Trade-offs evaluated and architectural decisions justified.
- [ ] Error handling patterns and edge cases defined.

## Phase 4: Plan
- [ ] Step-by-step checklist decomposed into atomic changes.
- [ ] Automated verification command defined for each step.
- [ ] TDD/Test-first approach applied where feasible.
- [ ] Plan confirmed before writing production code.

## Phase 5: Implement
- [ ] Code modifications applied atomically.
- [ ] Existing code style, linter rules, and comments preserved.
- [ ] All verification commands executed and passing.
- [ ] Zero regressions against acceptance criteria.
