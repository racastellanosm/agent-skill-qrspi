#!/bin/sh
# ==============================================================================
# QRSPI Session Directory & Artifact Validator
# Validates that a QRSPI session directory contains all 5 modular stage files
# and that required phase gates are verified.
# ==============================================================================

set -e

TARGET="$1"

if [ -z "$TARGET" ]; then
  echo "Usage: $(basename "$0") <path-to-session-dir-or-file>" >&2
  exit 1
fi

if [ ! -e "$TARGET" ]; then
  echo "Error: Target '$TARGET' does not exist." >&2
  exit 1
fi

ERRORS=0

validate_directory() {
  dir="$1"
  echo "Auditing Modular QRSPI Session Directory: $dir"
  echo "----------------------------------------------------"

  STAGES="1-question.md 2-research.md 3-structure.md 4-plan.md 5-implement.md"

  for stage_file in $STAGES; do
    full_path="${dir}/${stage_file}"
    if [ -f "$full_path" ]; then
      echo "[OK] Found stage file: ${stage_file}"
    else
      echo "[FAIL] Missing required stage file: ${stage_file}" >&2
      ERRORS=$((ERRORS + 1))
    fi
  done
}

validate_legacy_file() {
  file="$1"
  echo "Auditing Monolithic QRSPI Session Document: $file"
  echo "----------------------------------------------------"

  for pattern in "Question" "Research" "Structure" "Plan" "Implement"; do
    if grep -Eqi "##.*${pattern}" "$file"; then
      echo "[OK] Found section: $pattern"
    else
      echo "[FAIL] Missing section: $pattern" >&2
      ERRORS=$((ERRORS + 1))
    fi
  done
}

if [ -d "$TARGET" ]; then
  validate_directory "$TARGET"
else
  validate_legacy_file "$TARGET"
fi

echo "----------------------------------------------------"
if [ "$ERRORS" -gt 0 ]; then
  echo "Audit failed with $ERRORS missing stage(s) or file(s)." >&2
  exit 1
else
  echo "Audit PASSED: QRSPI modular structure is valid and complete."
  exit 0
fi
