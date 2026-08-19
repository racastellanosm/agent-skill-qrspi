# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.0] - 2026-08-19

### Added
- **Dynamic Model Tiering & Cognitive Load Routing**: Formally specified cognitive model weights per phase (MEDIUM for Question, HIGH for Research/Structure/Plan, LOW/FAST for Implement).
- **Subagent & Interactive Model Guardrails**: Instructed agents on programmatic subagent tier delegation (`Model: "pro"` vs `Model: "flash"`) and interactive CLI model switch notices.
- **Stage Templates & Quality Gates**: Added `Cognitive Load / Model Tier` metadata to `references/stage-templates/` (`1-question.md` through `5-implement.md`) and validation checks in `references/phases-checklist.md`.

## [1.3.0] - 2026-08-19

### Changed
- **Canonical Repository Renaming**: Renamed repository coordinates to `racastellanosm/agent-skill-qrspi` and updated skills.sh dynamic badge, documentation URLs, and Git remote references across all files.

## [1.2.0] - 2026-08-19

### Changed
- **Standardized Session Folder Naming Convention**: Updated the date-slug separator from underscore (`YYYY-MM-DD_<slug>`) to hyphen (`YYYY-MM-DD-<slug>`) across `SKILL.md`, `references/index-template.md`, `AGENTS.md`, and `README.md` for consistent kebab-case pathing.

## [1.1.0] - 2026-08-19

### Added
- **Socratic Stress-Testing in Phase 1 (Question)**: Integrated systematic interrogation patterns inspired by Matt Pocock's `grill-me` skill.
- **"Zero Lazy Questions" Rule**: Directs agents to autonomously explore the codebase (`grep_search`, `find_by_name`, `view_file`) before asking questions to eliminate redundant back-and-forth.
- **4 Failure Vectors Matrix**: Structured probing for failure modes, concurrency/idempotency, backward compatibility, and boundary limits in `references/stage-templates/1-question.md`.
- **Decision Tree & Trade-Off Branching**: Interactive branch-by-branch evaluation of architectural options.
- Enriched `references/phases-checklist.md` with Phase 1 stress-testing gates.

## [1.0.0] - 2026-08-19

### Added
- Canonical `SKILL.md` defining the 5-phase QRSPI engineering workflow compliant with the [agentskills.io](https://agentskills.io/specification) standard.
- Modular stage templates under `references/stage-templates/` (`1-question.md`, `2-research.md`, `3-structure.md`, `4-plan.md`, `5-implement.md`).
- Living Architecture Decision Record (ADR) index template (`references/index-template.md`).
- Phase-gate quality checklist (`references/phases-checklist.md`).
- Multi-harness interactive and unattended POSIX installer (`install.sh`) supporting Gemini, Claude, Codex, OpenCode, and standard agentskills roots.
- Agent Lifecycle prompt hook (`hooks/prompt-hook.sh`) to intercept complex tasks in Claude Code and Gemini CLI.
- POSIX-compliant modular session validator script (`scripts/verify-session.sh`).
- GitHub Actions CI workflow (`.github/workflows/ci.yml`) for YAML validation, shellcheck, and multi-harness installation tests.
- Repository governance policy (`AGENTS.md`) with trunk-based release protocol and user consent guardrails.
