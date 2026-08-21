# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.11.0] - 2026-08-21

### Added
- **Mandatory Turn Termination Invariant**: Enforced strict one-phase-per-turn execution across all 5 QRSPI phases. The AI agent MUST stop calling tools, persist the stage artifact, present findings/questions, and end its turn at every single phase, waiting for explicit user sign-off before proceeding.
- **Phase-Gate Approval Checkpoints in Templates**: Added explicit `User Approval & Sign-Off Gate` sections across all 5 stage templates (`1-question.md` through `5-implement.md`).
- **Enhanced Lifecycle Hook Directives**: Updated `prompt-hook.sh` to inject strict turn termination and one-phase-per-turn constraints directly into the agent runtime context.

## [1.10.0] - 2026-08-20

### Added
- **Configurable Session Destination**: Added native support for configurable session roots (`.qrspi/`, `.docs/`, `.implementations/`, `.sessions/`) defined via project `AGENTS.md` or user preference, with dynamic multi-root discovery in `prompt-hook.sh`.
- **Explicit Anti-Triggers**: Defined clear operational boundaries in `SKILL.md` (when NOT to trigger full QRSPI workflow: 1-2 line typo edits, read-only queries, git releases, scratch tasks).

### Security
- **GitHub Actions Pinning**: Pinned all GitHub Actions across CI workflows to immutable commit SHAs for supply chain zero-trust assurance.

## [1.9.3] - 2026-08-20

### Security & Hardening
- **Strict Supply-Chain & Scanner Remediation**:
  - Removed `curl | sh` instructions from `README.md` to eliminate remote code execution warnings (`Snyk E005 / W012`).
  - Hardened `install.sh` to operate strictly as an offline/deterministic local installer without unpinned mutable branch downloads (`Socket Security Alert`).
  - Cleaned `prompt-hook.sh` stdin inspection to prevent unnecessary prompt reflection warnings (`Snyk W011`).

## [1.9.2] - 2026-08-20

### Added
- **Repository Customization for `skills.sh`**: Added `skills.sh.json` repository manifest to define curated groupings, title, and rich description for the public directory on `skills.sh`.

## [1.9.1] - 2026-08-20

### Fixed
- **Supply Chain Security & False Positive Resolution**: Moved the internal security auditor (`verify-security.sh`) out of the distributable skill directory to `.github/scripts/verify-security.sh`, ensuring the distributed package is 100% clean and preventing false-positive malware/exfiltration alerts in automated security scanners (Socket, Snyk, and Gen).

## [1.9.0] - 2026-08-20

### Changed
- **Canonical `skills/<skill-name>/` Architecture**: Migrated repository layout to the canonical standard (`skills/qrspi-methodology/`) containing `SKILL.md`, `references/`, `scripts/`, and `hooks/`.
- **Pure `npx skills add` Packaging**: Installing via `skills.sh` / `npx skills add` now packages and copies exclusively the skill directory, completely eliminating unwanted root repository files (`.github`, `AGENTS.md`, `README.md`, etc.).
- **Updated Tooling & CI/CD**: Updated `install.sh`, `.github/workflows/ci.yml`, `scripts/verify-security.sh`, and documentation to transparently support the new structure.

## [1.8.2] - 2026-08-20

### Changed
- **Author Metadata Alignment**: Updated author metadata in `SKILL.md` frontmatter to `Raul Castellanos` to maintain consistency across repository license, ownership, and specification definitions.

## [1.8.1] - 2026-08-19

### Fixed
- **Strict Harness Isolation**: `install.sh` now enforces complete directory and hook isolation per target harness (e.g. `--harness=gemini` exclusively generates `.gemini/`, `--harness=standard` generates `.agents/`), preventing inadvertent creation of extraneous directories.
- **Interactive Default Update**: Updated interactive installer prompt default to option `1` (Google Gemini) for safer, single-harness installations.

## [1.8.0] - 2026-08-19

### Added
- **Automated Lifecycle Hook Wire-Up**: `install.sh` now automatically generates and configures `hooks.json` for Antigravity & Gemini CLI (attaching `PreInvocation` to `./.gemini/hooks/qrspi-prompt-hook.sh`) and `settings.json` for Claude Code (`UserPromptSubmit`).
- **Antigravity Protojson Contract Support**: Upgraded `hooks/prompt-hook.sh` with dual output mode, delivering structured `injectSteps` with ephemeral system messages on `PreInvocation` and plain text on standard CLI streams.

## [1.7.0] - 2026-08-19

### Fixed
- **Seamless Remote Installer (`curl | sh`)**: Added automatic GitHub archive stream extraction in `install.sh` when executed via standard input pipes in external directories where local `SKILL.md` is absent.

## [1.6.0] - 2026-08-19

### Added
- **Automated Security Pipeline (`.github/workflows/security.yml`)**: Integrated `gitleaks/gitleaks-action` for continuous secret and API key detection on push and PRs.
- **Repository Security Auditor (`scripts/verify-security.sh`)**: Added POSIX auditor verifying Trojan Source bidirectional Unicode characters (CVE-2021-42576), reverse shells, base64 eval loops, and suspicious credential exfiltration.
- **Least-Privilege CI Hardening**: Enforced `permissions: contents: read` across all GitHub Actions workflows to protect repository tokens.
- **Mandatory Code Ownership (`.github/CODEOWNERS`)**: Locked down all security scripts, CI workflows, and skills to require explicit repository owner review for any external contributions.

## [1.5.0] - 2026-08-19

### Added
- **Session-Aware Dynamic Model Tiering Hook**: Upgraded `hooks/prompt-hook.sh` to automatically detect the active session state and latest completed stage in `.qrspi/sessions/` upon prompt trigger.
- **Proactive Token-Savings Guardrail**: Injects immediate, real-time Model Tier recommendations (`MEDIUM`, `HIGH`, or `LOW/FAST`) directly into the agent prompt stream before response execution to save tokens and optimize reasoning depth.

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
