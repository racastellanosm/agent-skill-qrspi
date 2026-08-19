# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
