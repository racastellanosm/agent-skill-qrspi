#!/bin/sh
# ==============================================================================
# Agent Hook: UserPromptSubmit (Claude Code / Antigravity / Gemini CLI)
# Intercepts user prompts before the agent executes.
# Injects QRSPI awareness if intent matches complex engineering tasks.
# ==============================================================================

PROMPT_INPUT="$1"

# Trigger keywords that require QRSPI methodology
TRIGGERS="refactor|implement|migrate|redesign|fix.*bug|architecture|feature|build"

if echo "$PROMPT_INPUT" | grep -Eiq "$TRIGGERS"; then
  cat <<'EOF'
[SYSTEM DIRECTIVE: QRSPI ENFORCEMENT ACTIVE]
The user request involves architectural design, refactoring, or implementation.
You MUST strictly follow the 5-phase QRSPI methodology:
1. QUESTION  - Clarify ambiguities and establish acceptance criteria.
2. RESEARCH  - Verify codebase ground truth (read files/symbols, no assumptions).
3. STRUCTURE - Define data contracts, topologies, and error modes.
4. PLAN      - Formulate an atomic checklist with verification commands.
5. IMPLEMENT - Execute atomic steps with continuous verification.

Do NOT skip phases. Do NOT jump to writing code before completing Phases 1-4.
EOF
fi

exit 0
