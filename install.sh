#!/bin/sh
# ==============================================================================
# QRSPI Agent Skill - Universal POSIX Installer
# Specification: agentskills.io & skills.sh compatible
# Supported Harnesses: Google Gemini, Anthropic Claude, OpenAI Codex, OpenCode
# ==============================================================================

set -e

# ANSI Color Codes (disabled when non-interactive or NO_COLOR set)
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  BOLD="\033[1m"
  GREEN="\033[0;32m"
  BLUE="\033[0;34m"
  YELLOW="\033[1;33m"
  RED="\033[0;31m"
  RESET="\033[0m"
else
  BOLD=""
  GREEN=""
  BLUE=""
  YELLOW=""
  RED=""
  RESET=""
fi

SKILL_NAME="qrspi-methodology"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -d "${SCRIPT_DIR}/skills/${SKILL_NAME}" ]; then
  SOURCE_DIR="${SCRIPT_DIR}/skills/${SKILL_NAME}"
else
  SOURCE_DIR="${SCRIPT_DIR}"
fi

# Defaults
SCOPE=""
HARNESS=""
FORCE=0
CUSTOM_DIR=""

log_info() {
  printf "%b[INFO]%b %s\n" "$BLUE" "$RESET" "$1"
}

log_success() {
  printf "%b[SUCCESS]%b %s\n" "$GREEN" "$RESET" "$1"
}

log_warn() {
  printf "%b[WARN]%b %s\n" "$YELLOW" "$RESET" "$1"
}

log_error() {
  printf "%b[ERROR]%b %s\n" "$RED" "$RESET" "$1" >&2
}

print_banner() {
  printf "%b====================================================================%b\n" "$BOLD" "$RESET"
  printf "%b         QRSPI Methodology - Agent Skill & Hook Installer           %b\n" "$BOLD" "$RESET"
  printf "%b   Standard: agentskills.io | Cross-Harness Interoperability        %b\n" "$BOLD" "$RESET"
  printf "%b====================================================================%b\n\n" "$BOLD" "$RESET"
}

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -g, --global          Install globally for the current user (~/.<harness>/skills)
  -l, --local           Install locally into current workspace (./.<harness>/skills)
  -h, --harness <name>  Target harness: gemini, claude, codex, opencode, standard, all
  -d, --dest <path>     Custom destination directory
  -f, --force           Overwrite existing installation without prompting
  --help                Show this help message

Examples:
  ./install.sh --global --harness=all
  ./install.sh --local --harness=gemini
  ./install.sh --dest=~/.config/custom/skills/qrspi-methodology
EOF
  exit 0
}

# Parse CLI Arguments
while [ $# -gt 0 ]; do
  case "$1" in
    -g|--global)
      SCOPE="global"
      shift
      ;;
    -l|--local)
      SCOPE="local"
      shift
      ;;
    -h|--harness)
      HARNESS="$2"
      shift 2
      ;;
    --harness=*)
      HARNESS="${1#*=}"
      shift
      ;;
    -d|--dest)
      CUSTOM_DIR="$2"
      shift 2
      ;;
    --dest=*)
      CUSTOM_DIR="${1#*=}"
      shift
      ;;
    -f|--force)
      FORCE=1
      shift
      ;;
    --help)
      usage
      ;;
    *)
      log_error "Unknown option: $1"
      usage
      ;;
  esac
done

# Interactive Scope Selection
select_scope() {
  if [ -n "$SCOPE" ]; then return; fi
  printf "%bSelect Installation Scope:%b\n" "$BOLD" "$RESET"
  printf "  1) Global (Current User - \$HOME)\n"
  printf "  2) Local  (Current Workspace / Project Directory)\n"
  printf "Enter choice [1-2] (default: 1): "
  read -r scope_choice
  case "$scope_choice" in
    2) SCOPE="local" ;;
    *) SCOPE="global" ;;
  esac
  printf "\n"
}

# Interactive Harness Selection
select_harness() {
  if [ -n "$HARNESS" ]; then return; fi
  printf "%bSelect Target AI Agent Harness:%b\n" "$BOLD" "$RESET"
  printf "  1) Google Gemini (CLI / Antigravity / Studio)\n"
  printf "  2) Anthropic Claude (Claude Code / Desktop)\n"
  printf "  3) OpenAI Codex / CLI\n"
  printf "  4) OpenCode\n"
  printf "  5) Standard agentskills.io root (.agents/skills)\n"
  printf "  6) All Harnesses\n"
  printf "Enter choice [1-6] (default: 1): "
  read -r harness_choice
  case "$harness_choice" in
    2) HARNESS="claude" ;;
    3) HARNESS="codex" ;;
    4) HARNESS="opencode" ;;
    5) HARNESS="standard" ;;
    6) HARNESS="all" ;;
    *) HARNESS="gemini" ;;
  esac
  printf "\n"
}

# Determine Destination Directories
get_target_dirs() {
  target_harness="$1"
  target_scope="$2"
  
  if [ "$target_scope" = "global" ]; then
    base_prefix="$HOME"
  else
    base_prefix="."
  fi

  case "$target_harness" in
    gemini)
      echo "${base_prefix}/.gemini/skills/${SKILL_NAME}"
      ;;
    claude)
      echo "${base_prefix}/.claude/skills/${SKILL_NAME}"
      ;;
    codex)
      echo "${base_prefix}/.codex/skills/${SKILL_NAME}"
      ;;
    opencode)
      echo "${base_prefix}/.opencode/skills/${SKILL_NAME}"
      ;;
    standard)
      echo "${base_prefix}/.agents/skills/${SKILL_NAME}"
      ;;
  esac
}

install_agent_hooks() {
  target_harness="$1"
  target_scope="$2"

  if [ "$target_scope" = "global" ]; then
    base_prefix="$HOME"
  else
    base_prefix="."
  fi

  case "$target_harness" in
    claude)
      hook_dir="${base_prefix}/.claude/hooks"
      mkdir -p "$hook_dir"
      if [ -f "${SOURCE_DIR}/hooks/prompt-hook.sh" ]; then
        cp "${SOURCE_DIR}/hooks/prompt-hook.sh" "${hook_dir}/qrspi-prompt-hook.sh"
        chmod 755 "${hook_dir}/qrspi-prompt-hook.sh"
        log_info "Installed Claude Code Agent Hook: ${hook_dir}/qrspi-prompt-hook.sh"

        # Register hook in Claude settings.json if not present
        settings_file="${base_prefix}/.claude/settings.json"
        if [ ! -f "$settings_file" ]; then
          cat <<EOF > "$settings_file"
{
  "hooks": {
    "UserPromptSubmit": "${hook_dir}/qrspi-prompt-hook.sh"
  }
}
EOF
          log_info "Generated Claude Hook Configuration: ${settings_file}"
        fi
      fi
      ;;
    gemini)
      hook_dir="${base_prefix}/.gemini/hooks"
      mkdir -p "$hook_dir"
      if [ -f "${SOURCE_DIR}/hooks/prompt-hook.sh" ]; then
        cp "${SOURCE_DIR}/hooks/prompt-hook.sh" "${hook_dir}/qrspi-prompt-hook.sh"
        chmod 755 "${hook_dir}/qrspi-prompt-hook.sh"
        log_info "Installed Gemini/Antigravity Agent Hook: ${hook_dir}/qrspi-prompt-hook.sh"

        # Generate hooks.json for Antigravity & Gemini runtime discovery
        hook_cmd="${hook_dir}/qrspi-prompt-hook.sh"
        if [ "$target_scope" = "local" ]; then
          hook_cmd="./.gemini/hooks/qrspi-prompt-hook.sh"
        fi

        hooks_config="${base_prefix}/.gemini/hooks.json"
        if [ ! -f "$hooks_config" ]; then
          cat <<EOF > "$hooks_config"
{
  "qrspi-prompt-guardrail": {
    "PreInvocation": [
      {
        "type": "command",
        "command": "${hook_cmd}"
      }
    ]
  }
}
EOF
          log_info "Generated Antigravity/Gemini Hook Configuration: ${hooks_config}"
        fi
      fi
      ;;
    standard)
      hook_dir="${base_prefix}/.agents/hooks"
      mkdir -p "$hook_dir"
      if [ -f "${SOURCE_DIR}/hooks/prompt-hook.sh" ]; then
        cp "${SOURCE_DIR}/hooks/prompt-hook.sh" "${hook_dir}/qrspi-prompt-hook.sh"
        chmod 755 "${hook_dir}/qrspi-prompt-hook.sh"
        log_info "Installed Standard Agents Hook: ${hook_dir}/qrspi-prompt-hook.sh"

        hook_cmd="${hook_dir}/qrspi-prompt-hook.sh"
        if [ "$target_scope" = "local" ]; then
          hook_cmd="./.agents/hooks/qrspi-prompt-hook.sh"
        fi

        hooks_config="${base_prefix}/.agents/hooks.json"
        if [ ! -f "$hooks_config" ]; then
          cat <<EOF > "$hooks_config"
{
  "qrspi-prompt-guardrail": {
    "PreInvocation": [
      {
        "type": "command",
        "command": "${hook_cmd}"
      }
    ]
  }
}
EOF
          log_info "Generated Standard Agents Hook Configuration: ${hooks_config}"
        fi
      fi
      ;;
    *)
      # No dedicated lifecycle hooks configured for codex / opencode
      ;;
  esac
}

install_to_path() {
  dest_path="$1"
  log_info "Deploying QRSPI skill to: ${dest_path}"

  if [ -d "$dest_path" ]; then
    if [ "$FORCE" -ne 1 ]; then
      log_warn "Destination directory already exists: ${dest_path}"
      printf "Overwrite existing installation? [y/N]: "
      read -r confirm
      case "$confirm" in
        [yY]|[yY][eE][sS]) ;;
        *)
          log_info "Skipping ${dest_path}"
          return 0
          ;;
      esac
    fi
    rm -rf "$dest_path"
  fi

  mkdir -p "$dest_path"
  mkdir -p "$dest_path/references"

  # Copy core specification
  if [ -f "${SOURCE_DIR}/SKILL.md" ]; then
    cp "${SOURCE_DIR}/SKILL.md" "${dest_path}/SKILL.md"
    chmod 644 "${dest_path}/SKILL.md"
  else
    log_error "Source SKILL.md not found in ${SOURCE_DIR}"
    exit 1
  fi

  # Copy references
  if [ -d "${SOURCE_DIR}/references" ]; then
    cp -R "${SOURCE_DIR}/references/"* "${dest_path}/references/" 2>/dev/null || true
    find "${dest_path}/references" -type d -exec chmod 755 {} + 2>/dev/null || true
    find "${dest_path}/references" -type f -exec chmod 644 {} + 2>/dev/null || true
  fi

  # Copy scripts if any
  if [ -d "${SOURCE_DIR}/scripts" ]; then
    mkdir -p "${dest_path}/scripts"
    cp -R "${SOURCE_DIR}/scripts/"* "${dest_path}/scripts/" 2>/dev/null || true
    find "${dest_path}/scripts" -type d -exec chmod 755 {} + 2>/dev/null || true
    find "${dest_path}/scripts" -type f -exec chmod 755 {} + 2>/dev/null || true
  fi

  # Copy assets if any
  if [ -d "${SOURCE_DIR}/assets" ]; then
    mkdir -p "${dest_path}/assets"
    cp -R "${SOURCE_DIR}/assets/"* "${dest_path}/assets/" 2>/dev/null || true
    find "${dest_path}/assets" -type d -exec chmod 755 {} + 2>/dev/null || true
    find "${dest_path}/assets" -type f -exec chmod 644 {} + 2>/dev/null || true
  fi

  # Copy hooks if any
  if [ -d "${SOURCE_DIR}/hooks" ]; then
    mkdir -p "${dest_path}/hooks"
    cp -R "${SOURCE_DIR}/hooks/"* "${dest_path}/hooks/" 2>/dev/null || true
    find "${dest_path}/hooks" -type d -exec chmod 755 {} + 2>/dev/null || true
    find "${dest_path}/hooks" -type f -exec chmod 755 {} + 2>/dev/null || true
  fi

  chmod 755 "$dest_path"
  log_success "Successfully installed at: ${dest_path}"
}

# Main Execution Flow
main() {
  print_banner

  # Resolve source directory: Local clone vs Remote curl | sh stream
  if [ ! -f "${SOURCE_DIR}/SKILL.md" ]; then
    log_info "Running in remote installer mode. Fetching QRSPI package from GitHub..."
    TMP_SRC_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t 'qrspi-install')"
    trap 'rm -rf "$TMP_SRC_DIR"' EXIT HUP INT TERM

    if command -v curl >/dev/null 2>&1 && command -v tar >/dev/null 2>&1; then
      curl -sSL https://github.com/racastellanosm/agent-skill-qrspi/archive/refs/heads/main.tar.gz | tar -xz -C "$TMP_SRC_DIR" --strip-components=1
    elif command -v git >/dev/null 2>&1; then
      git clone --depth=1 https://github.com/racastellanosm/agent-skill-qrspi.git "$TMP_SRC_DIR" >/dev/null 2>&1
    else
      log_error "Cannot fetch QRSPI package: curl+tar or git required."
      exit 1
    fi

    if [ -d "$TMP_SRC_DIR/skills/${SKILL_NAME}" ]; then
      SOURCE_DIR="$TMP_SRC_DIR/skills/${SKILL_NAME}"
    else
      SOURCE_DIR="$TMP_SRC_DIR"
    fi
  fi

  # Final source verification
  if [ ! -f "${SOURCE_DIR}/SKILL.md" ]; then
    log_error "Failed to locate SKILL.md in source package (${SOURCE_DIR})."
    exit 1
  fi

  if [ -n "$CUSTOM_DIR" ]; then
    install_to_path "$CUSTOM_DIR"
    exit 0
  fi

  select_scope
  select_harness

  log_info "Configuration: Scope=${SCOPE}, Harness=${HARNESS}"

  if [ "$HARNESS" = "all" ]; then
    for h in gemini claude codex opencode standard; do
      target_dir=$(get_target_dirs "$h" "$SCOPE")
      install_to_path "$target_dir"
      install_agent_hooks "$h" "$SCOPE"
    done
  else
    target_dir=$(get_target_dirs "$HARNESS" "$SCOPE")
    install_to_path "$target_dir"
    install_agent_hooks "$HARNESS" "$SCOPE"
  fi

  printf "\n"
  log_success "QRSPI Skill & Agent Hooks installation complete!"
  printf "%bVerification Hint:%b Start a prompt with 'Refactor module X' to verify automatic QRSPI hook trigger.\n\n" "$BOLD" "$RESET"
}

main
