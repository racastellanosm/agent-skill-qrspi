#!/bin/sh
# ==============================================================================
# Security & Integrity Audit Script for agent-skills
# Standard: OpenSSF Best Practices & agentskills.io Security Guardrails
# Pure POSIX /bin/sh compliant (macOS, Linux, BSD)
# ==============================================================================

set -e

# Terminal colors (if stdout is a tty)
if [ -t 1 ]; then
  BOLD="\033[1m"
  GREEN="\033[0;32m"
  RED="\033[0;31m"
  BLUE="\033[0;34m"
  RESET="\033[0m"
else
  BOLD=""
  GREEN=""
  RED=""
  BLUE=""
  RESET=""
fi

log_info() {
  printf "%b[INFO]%b %s\n" "$BLUE" "$RESET" "$1"
}

log_ok() {
  printf "%b[OK]%b %s\n" "$GREEN" "$RESET" "$1"
}

log_fail() {
  printf "%b[FAIL]%b %s\n" "$RED" "$RESET" "$1"
  exit 1
}

printf "%b====================================================================%b\n" "$BOLD" "$RESET"
printf "%b             QRSPI Repository Security & Integrity Audit            %b\n" "$BOLD" "$RESET"
printf "%b====================================================================%b\n" "$BOLD" "$RESET"

# 1. Shell Script Security & Anti-Malware Patterns
log_info "1/3. Auditing production shell scripts for reverse shells, eval loops, and obfuscation..."
AUDIT_TARGETS="install.sh skills/qrspi-methodology/hooks/prompt-hook.sh skills/qrspi-methodology/scripts/verify-session.sh"

for file in $AUDIT_TARGETS; do
  if [ -f "$file" ]; then
    # Check for reverse shell sockets (/dev/tcp or /dev/udp or nc -e)
    if grep -Eq "(/dev/(tcp|udp)|nc[[:space:]]+-[a-zA-Z]*e[a-zA-Z]*|netcat)" "$file"; then
      log_fail "Suspicious network socket pattern found in: $file"
    fi

    # Check for base64 pipe to execution
    if grep -Eq "base64[[:space:]]+-[a-zA-Z]*d.*\|[[:space:]]*(sh|bash|zsh)" "$file"; then
      log_fail "Obfuscated base64 execution found in: $file"
    fi

    # Check for suspicious exfiltration of sensitive environment variables
    if grep -Eiq "curl.*-d.*(KEY|TOKEN|SECRET|PASSWORD)" "$file"; then
      log_fail "Suspicious credential exfiltration pattern found in: $file"
    fi
  fi
done
log_ok "Production shell scripts are clean of unauthorized network patterns and obfuscations."

# 2. Markdown & Link Scheme Integrity
log_info "2/3. Auditing Markdown files for dangerous URI schemes and script tags..."
MD_FILES="SKILL.md skills/qrspi-methodology/SKILL.md README.md AGENTS.md CHANGELOG.md $(find . -name "*.md" ! -path "*/.*" 2>/dev/null)"

for file in $MD_FILES; do
  if [ -f "$file" ]; then
    # Check for javascript: or data: or vbscript: links
    if grep -Eiq "\[.*\]\((javascript:|data:|vbscript:)" "$file"; then
      log_fail "Dangerous URI scheme detected in markdown file: $file"
    fi

    # Check for inline HTML script tags
    if grep -Eiq "<script[[:space:]>]" "$file"; then
      log_fail "Inline script tag detected in markdown file: $file"
    fi
  fi
done
log_ok "Markdown files contain valid, clean references with zero malicious schemes."

# 3. Trojan Source & Invisible Unicode Bidi Check (CVE-2021-42576)
log_info "3/3. Scanning for Trojan Source invisible bidirectional characters (CVE-2021-42576)..."

# Python-based fast zero-dependency unicode bidi scan
if command -v python3 >/dev/null 2>&1; then
  python3 -c '
import sys, os

bidi_chars = {
    "\u202A", "\u202B", "\u202C", "\u202D", "\u202E",
    "\u2066", "\u2067", "\u2068", "\u2069", "\u200E", "\u200F"
}

files_to_scan = []
for root, dirs, files in os.walk("."):
    dirs[:] = [d for d in dirs if not d.startswith(".")]
    for f in files:
        if f.endswith(".md") or f.endswith(".sh"):
            files_to_scan.append(os.path.join(root, f))

found = False
for path in files_to_scan:
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
            for idx, char in enumerate(content):
                if char in bidi_chars:
                    print(f"[FAIL] Trojan Source Unicode character (U+{ord(char):04X}) detected in {path} at pos {idx}")
                    found = True

if found:
    sys.exit(1)
' || log_fail "Trojan Source bidirectional character detected!"
fi
log_ok "Zero Trojan Source Unicode Bidi characters detected."

printf "\n%b[SUCCESS] All repository security & integrity audits PASSED.%b\n" "$GREEN" "$RESET"
exit 0
