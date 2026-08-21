#!/bin/sh
# ==============================================================================
# Agent Hook: UserPromptSubmit (Claude Code / Antigravity / Gemini CLI)
# Intercepts user prompts before the agent executes.
# Injects QRSPI awareness and Dynamic Model Tiering guardrails based on session state.
# Standard: agentskills.io Open Specification
# ==============================================================================

# Read stdin to detect environment format (JSON PreInvocation vs CLI)
STDIN_DATA=""
if [ ! -t 0 ]; then
  STDIN_DATA="$(cat)"
fi

ACTIVE_STAGE="1 (Question)"
MODEL_WEIGHT="MEDIUM (Standard Reasoning)"
STAGE_GOAL="Deconstruct requirements, perform codebase pre-check, and stress-test failure vectors."

# Detect active session directory across supported candidate roots
LATEST_SESSION=""
for root in ".qrspi" ".docs" ".implementations" ".sessions" ".qrspi/sessions"; do
  if [ -d "$root" ]; then
    for dir in "$root"/*; do
      if [ -d "$dir" ] && { [ -f "$dir/1-question.md" ] || [ -f "$dir/2-research.md" ] || [ -f "$dir/3-structure.md" ] || [ -f "$dir/4-plan.md" ] || [ -f "$dir/5-implement.md" ]; }; then
        LATEST_SESSION="$dir"
      fi
    done
    if [ -n "$LATEST_SESSION" ]; then
      break
    fi
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

# Check if running in JSON input/output contract (Antigravity / Gemini CLI PreInvocation)
case "$STDIN_DATA" in
  *"conversationId"*|*"invocationNum"*|*"workspacePaths"*)
    cat <<EOF
{
  "injectSteps": [
    {
      "ephemeralMessage": "[SYSTEM DIRECTIVE: QRSPI METHODOLOGY & MANDATORY TURN TERMINATION]\n• Active Target Phase : Phase ${ACTIVE_STAGE}\n• Recommended Weight  : ${MODEL_WEIGHT}\n• Primary Objective   : ${STAGE_GOAL}\n--------------------------------------------------------------------------------\nYou MUST follow the 5-phase QRSPI engineering standard:\n1. QUESTION -> 2. RESEARCH -> 3. STRUCTURE -> 4. PLAN -> 5. IMPLEMENT\n\nNON-NEGOTIABLE EXECUTION INVARIANTS:\n1. EXACTLY ONE PHASE PER TURN: Execute only the current active phase (${ACTIVE_STAGE}).\n2. MANDATORY TURN TERMINATION: After persisting the stage document, you MUST STOP calling tools, output your summary/questions, and END YOUR TURN.\n3. USER SIGN-OFF GATE: Do NOT proceed to the next phase until the user explicitly reviews and confirms approval in their reply.\n4. Model Weight: Use Model=\"pro\" for Phases 2-4, Model=\"flash\" for Phase 5."
    }
  ]
}
EOF
    exit 0
    ;;
esac

# Plain text fallback (Claude Code UserPromptSubmit / CLI direct invocation)
cat <<EOF
[SYSTEM DIRECTIVE: QRSPI METHODOLOGY & MANDATORY TURN TERMINATION]
--------------------------------------------------------------------------------
💡 COGNITIVE LOAD & PHASE GATE GUARDRAIL:
• Active Target Phase : Phase ${ACTIVE_STAGE}
• Recommended Weight  : ${MODEL_WEIGHT}
• Primary Objective   : ${STAGE_GOAL}
--------------------------------------------------------------------------------
You MUST follow the 5-phase QRSPI engineering standard:
1. QUESTION  -> 2. RESEARCH -> 3. STRUCTURE -> 4. PLAN -> 5. IMPLEMENT

NON-NEGOTIABLE EXECUTION INVARIANTS:
1. EXACTLY ONE PHASE PER TURN: Execute only the current active phase (${ACTIVE_STAGE}).
2. MANDATORY TURN TERMINATION: After persisting the stage document, you MUST STOP calling tools, output your summary/questions to the user, and END YOUR TURN.
3. USER SIGN-OFF GATE: Do NOT proceed to the next phase until the user explicitly reviews and confirms approval in their reply.
4. Model Weight: Use Model="pro" for Phases 2-4, Model="flash" for Phase 5.
EOF

exit 0
