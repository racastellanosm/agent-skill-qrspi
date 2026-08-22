#!/bin/sh
# ==============================================================================
# verify-docker-stack.sh — POSIX Validator for Docker & Makefile Orchestration
# Rule: Pure POSIX /bin/sh compliant (Zero external dependencies)
# ==============================================================================

set -eu

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TARGET_DIR="${1:-.}"
ERRORS=0
WARNINGS=0

log_info() {
    printf "%b[INFO]%b %s\n" "${BLUE}" "${NC}" "$1"
}

log_pass() {
    printf "%b[PASS]%b %s\n" "${GREEN}" "${NC}" "$1"
}

log_warn() {
    printf "%b[WARN]%b %s\n" "${YELLOW}" "${NC}" "$1"
    WARNINGS=$((WARNINGS + 1))
}

log_fail() {
    printf "%b[FAIL]%b %s\n" "${RED}" "${NC}" "$1"
    ERRORS=$((ERRORS + 1))
}

printf "\n%b==============================================================================%b\n" "${BLUE}" "${NC}"
printf "%bDocker & Makefile Orchestration Stack Auditor%b\n" "${BLUE}" "${NC}"
printf "Target: %s\n" "${TARGET_DIR}"
printf "%b==============================================================================%b\n\n" "${BLUE}" "${NC}"

if [ "${TARGET_DIR}" = "--help" ] || [ "${TARGET_DIR}" = "-h" ]; then
    printf "Usage: %s [target-directory]\n" "$0"
    printf "Audits a project's Makefile, Dockerfiles, and Docker Compose configuration for compliance with the Zero-Host-Dependencies standard.\n"
    exit 0
fi

if [ ! -d "${TARGET_DIR}" ]; then
    log_fail "Target directory does not exist: ${TARGET_DIR}"
    exit 1
fi

# ------------------------------------------------------------------------------
# 1. Makefile Verification
# ------------------------------------------------------------------------------
MAKEFILE_PATH="${TARGET_DIR}/Makefile"

if [ -f "${MAKEFILE_PATH}" ]; then
    log_pass "Makefile found at ${MAKEFILE_PATH}"

    # Check for help target and self-documentation
    if grep -q "help:" "${MAKEFILE_PATH}"; then
        log_pass "Makefile defines 'help' target"
    else
        log_warn "Makefile is missing 'help' target"
    fi

    if grep -q "##" "${MAKEFILE_PATH}"; then
        log_pass "Makefile includes '##' self-documenting comments"
    else
        log_warn "Makefile is missing '##' documentation annotations"
    fi

    # Check for standard target taxonomy
    for target in install dev test build clean; do
        if grep -qE "^${target}:" "${MAKEFILE_PATH}"; then
            log_pass "Makefile target '${target}' is defined"
        else
            log_warn "Makefile is missing recommended target '${target}'"
        fi
    done
else
    log_fail "No Makefile found at ${MAKEFILE_PATH}"
fi

# ------------------------------------------------------------------------------
# 2. Dockerfile Verification
# ------------------------------------------------------------------------------
DOCKERFILES=$(find "${TARGET_DIR}" -name "Dockerfile*" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null || true)

if [ -n "${DOCKERFILES}" ]; then
    for df in ${DOCKERFILES}; do
        log_info "Auditing Dockerfile: ${df}"

        # Check for multi-stage build
        if grep -qiE "FROM .* AS " "${df}"; then
            log_pass "Multi-stage build pattern detected in ${df}"
        else
            log_warn "Single-stage build detected in ${df}. Consider multi-stage architecture."
        fi

        # Check for non-root user
        if grep -qiE "^USER " "${df}"; then
            log_pass "Non-root USER directive found in ${df}"
        else
            log_fail "No USER directive found in ${df} (Running as root is prohibited)"
        fi

        # Check for supply-chain safety flags if node/bun
        if grep -qiE "(bun install|npm install|yarn install|pnpm install)" "${df}"; then
            if grep -qiE "(--ignore-scripts|--frozen-lockfile|npm ci)" "${df}"; then
                log_pass "Supply-chain safety flags detected in ${df}"
            else
                log_warn "Missing supply-chain security flags (--ignore-scripts / --frozen-lockfile) in ${df}"
            fi
        fi
    done
else
    log_info "No Dockerfiles found in target directory (skipping Dockerfile checks)"
fi

# ------------------------------------------------------------------------------
# 3. Docker Compose Verification
# ------------------------------------------------------------------------------
COMPOSE_FILE="${TARGET_DIR}/docker-compose.yml"
COMPOSE_DEV_FILE="${TARGET_DIR}/docker-compose.dev.yml"

if [ -f "${COMPOSE_FILE}" ]; then
    log_pass "Baseline docker-compose.yml found"

    if [ -f "${COMPOSE_DEV_FILE}" ]; then
        log_pass "Split compose topology detected (docker-compose.dev.yml present)"
    else
        log_warn "Split compose file docker-compose.dev.yml not found. Consider separating dev overrides."
    fi
fi

# ------------------------------------------------------------------------------
# Final Summary
# ------------------------------------------------------------------------------
printf "\n%b------------------------------------------------------------------------------%b\n" "${BLUE}" "${NC}"
printf "Audit Completed: %b%d Errors%b, %b%d Warnings%b\n" \
    "${RED}" "${ERRORS}" "${NC}" \
    "${YELLOW}" "${WARNINGS}" "${NC}"
printf "%b------------------------------------------------------------------------------%b\n\n" "${BLUE}" "${NC}"

if [ "${ERRORS}" -gt 0 ]; then
    exit 1
fi

exit 0
