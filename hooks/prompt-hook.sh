#!/bin/sh
# ==============================================================================
# Agent Hook: UserPromptSubmit (Claude Code / Antigravity / Gemini CLI)
# Intercepts user prompts before the agent executes.
# Injects QRSPI awareness and Dynamic Model Tiering guardrails based on session state.
# Standard: agentskills.io Open Specification
# ==============================================================================

PROMPT_INPUT="$1"

# Trigger keywords that require QRSPI methodology
TRIGGERS="refactor|implement|migrate|redesign|fix.*bug|architecture|feature|build|qrspi"

if echo "$PROMPT_INPUT" | grep -Eiq "$TRIGGERS"; then
  ACTIVE_STAGE="1 (Question)"
  MODEL_WEIGHT="MEDIUM (Standard Reasoning)"
  STAGE_GOAL="Deconstruct requirements, perform codebase pre-check, and stress-test failure vectors."

  # Detect active session directory under .qrspi/sessions/
  if [ -d ".qrspi/sessions" ]; then
    # Find latest session directory in POSIX-compliant manner
    LATEST_SESSION=""
    for dir in .qrspi/sessions/*; do
      if [ -d "$dir" ]; then
        LATEST_SESSION="$dir"
      fi
    done

    if [ -n "$LATEST_SESSION" ] && [ -d "$LATEST_SESSION" ]; then
      if [ ! -f "$LATEST_SESSION/1-question.md" ]; then
        ACTIVE_STAGE="1 (Question)"
        MODEL_WEIGHT="MEDIUM (Standard Reasoning)"
        STAGE_GOAL="Clarify ambiguities, zero lazy questions, and failure mode analysis."
      elif [ ! -f "$LATEST_SESSION/2-research.md" ]; then
        ACTIVE_STAGE="2 (Research)"
        MODEL_WEIGHT="HIGH (Deep Reasoning / Extended Thinking)"
        STAGE_GOAL="Verify codebase ground truth, AST structures, dependencies, and blast radius."
      elif [ ! -f "$LATEST_SESSION/3-structure.md" ]; then
        ACTIVE_STAGE="3 (Structure)"
        MODEL_WEIGHT="HIGH (Deep Reasoning / Extended Thinking)"
        STAGE_GOAL="Define data contracts, types, architectural invariants, and trade-offs."
      elif [ ! -f "$LATEST_SESSION/4-plan.md" ]; then
        ACTIVE_STAGE="4 (Plan)"
        MODEL_WEIGHT="HIGH (Deep Reasoning / Extended Thinking)"
        STAGE_GOAL="Construct atomic step-by-step checklist with test/verification commands."
      else
        ACTIVE_STAGE="5 (Implement)"
        MODEL_WEIGHT="LOW / FAST (Atomic Code Execution)"
        STAGE_GOAL="Execute checklist sequentially with test verification and zero regressions."
      fi
    fi
  fi

  cat <<EOF
[SYSTEM DIRECTIVE: QRSPI METHODOLOGY & MODEL TIER GUARDRAIL]
--------------------------------------------------------------------------------
💡 COGNITIVE LOAD & MODEL WEIGHT GUARDRAIL:
• Active Target Phase : Phase ${ACTIVE_STAGE}
• Recommended Weight  : ${MODEL_WEIGHT}
• Primary Objective   : ${STAGE_GOAL}
--------------------------------------------------------------------------------
You MUST follow the 5-phase QRSPI engineering standard:
1. QUESTION  -> 2. RESEARCH -> 3. STRUCTURE -> 4. PLAN -> 5. IMPLEMENT

Rules:
- If delegating via subagents (invoke_subagent): Use Model="pro" for Phases 2-4, Model="flash" for Phase 5.
- If in interactive mode: Remind the user if a model weight switch improves reasoning or saves tokens.
- Do NOT jump to writing code before completing and persisting Phases 1 through 4.
EOF
fi

exit 0
