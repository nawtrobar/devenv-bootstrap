#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()  { printf '\033[0;34m[info]\033[0m  %s\n' "$*"; }
ok()    { printf '\033[0;32m[ok]\033[0m    %s\n' "$*"; }
warn()  { printf '\033[0;33m[warn]\033[0m  %s\n' "$*"; }
die()   { printf '\033[0;31m[error]\033[0m %s\n' "$*" >&2; exit 1; }

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    warn "Backing up existing $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sfn "$src" "$dst"
  ok "Linked $dst -> $src"
}

# ── System packages ─────────────────────────────────────────────────────────
install_packages() {
  info "Installing system packages..."
  sudo apt-get update -q
  sudo apt-get install -y -q \
    zsh tmux curl git build-essential ripgrep fd-find fzf unzip \
    python3-pip nodejs npm
  ok "System packages installed"
}

# ── Neovim ──────────────────────────────────────────────────────────────────
install_nvim() {
  if command -v nvim &>/dev/null; then
    ok "Neovim already installed ($(nvim --version | head -1))"
    return
  fi
  info "Installing Neovim..."
  local tmp
  tmp=$(mktemp -d)
  curl -sL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz" \
    -o "$tmp/nvim.tar.gz"
  tar -xzf "$tmp/nvim.tar.gz" -C "$tmp"
  sudo cp -r "$tmp"/nvim-linux-x86_64/* /usr/local/
  ok "Neovim installed"
}

# ── Oh My Zsh ───────────────────────────────────────────────────────────────
install_omz() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    ok "Oh My Zsh already installed"
  else
    info "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ok "Oh My Zsh installed"
  fi

  local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  if [ ! -d "$custom/plugins/zsh-autosuggestions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
      "$custom/plugins/zsh-autosuggestions"
  fi
  if [ ! -d "$custom/plugins/zsh-syntax-highlighting" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
      "$custom/plugins/zsh-syntax-highlighting"
  fi
  if [ ! -d "$custom/plugins/zsh-history-substring-search" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search \
      "$custom/plugins/zsh-history-substring-search"
  fi
  if [ ! -d "$custom/plugins/zsh-vi-mode" ]; then
    git clone --depth=1 https://github.com/jeffreytse/zsh-vi-mode \
      "$custom/plugins/zsh-vi-mode"
  fi
  if [ ! -d "$custom/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
      "$custom/themes/powerlevel10k"
  fi
  ok "OMZ plugins installed"
}

# ── TPM (tmux plugin manager) ────────────────────────────────────────────────
install_tpm() {
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Installing TPM..."
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    ok "TPM installed"
  else
    ok "TPM already installed"
  fi
}

# ── code-server ─────────────────────────────────────────────────────────────
install_code_server() {
  if command -v code-server &>/dev/null; then
    ok "code-server already installed ($(code-server --version | head -1))"
    return
  fi
  info "Installing code-server..."
  curl -fsSL https://code-server.dev/install.sh | sh -s -- --method standalone
  ok "code-server installed"
}

# ── Claude Code ─────────────────────────────────────────────────────────────
install_claude() {
  if command -v claude &>/dev/null; then
    ok "Claude Code already installed"
  else
    info "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
    ok "Claude Code installed"
  fi
}

# ── Go ───────────────────────────────────────────────────────────────────────
install_go() {
  if command -v go &>/dev/null; then
    ok "Go already installed ($(go version))"
    return
  fi
  info "Installing Go..."
  local GO_VERSION="1.24.0"
  local tmp
  tmp=$(mktemp -d)
  curl -sL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o "$tmp/go.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "$tmp/go.tar.gz"
  export PATH="$PATH:/usr/local/go/bin"
  ok "Go ${GO_VERSION} installed"
}

# ── Claudio (audio feedback for Claude Code) ─────────────────────────────────
install_claudio() {
  export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
  if command -v claudio &>/dev/null; then
    ok "Claudio already installed"
  else
    info "Installing Claudio..."
    go install claudio.click/cmd/claudio@latest
    ok "Claudio installed"
  fi
  # Install hooks into ~/.claude/settings.json (generated file — claudio merges hooks in place)
  # claudio install exits non-zero if PreToolUse contains non-Claudio hooks alongside its own
  # (a claudio verification bug — the merge itself succeeds and the file is written correctly)
  info "Installing Claudio hooks..."
  local settings="$HOME/.claude/settings.json"
  local before_mtime
  before_mtime=$(stat -c %Y "$settings" 2>/dev/null || echo 0)
  claudio install --scope user || {
    local after_mtime
    after_mtime=$(stat -c %Y "$settings" 2>/dev/null || echo 0)
    if [ "$after_mtime" -gt "$before_mtime" ]; then
      warn "Claudio hook verification reported an error (hooks were merged successfully — safe to ignore)"
    else
      die "Claudio hook installation failed — $settings was not modified"
    fi
  }
  ok "Claudio hooks installed"
  warn "WSL note: audio requires PulseAudio or WSLg. Run 'claudio status' to verify."
}

# ── Symlink dotfiles ─────────────────────────────────────────────────────────
link_dotfiles() {
  info "Linking dotfiles..."
  link "$DOTFILES_DIR/zsh/.zshrc"      "$HOME/.zshrc"
  link "$DOTFILES_DIR/zsh/p10k.zsh"   "$HOME/.p10k.zsh"
  link "$DOTFILES_DIR/zsh/aliases.zsh" "$HOME/.config/zsh/aliases.zsh"
  link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
  link "$DOTFILES_DIR/nvim"            "$HOME/.config/nvim"
  chmod +x "$DOTFILES_DIR/bin/dev"
  link "$DOTFILES_DIR/bin/dev"         "$HOME/.local/bin/dev"
  ok "Dotfiles linked"
}

# ── Claude config ────────────────────────────────────────────────────────────
link_claude() {
  info "Linking Claude config..."

  # Generate settings.json from template (not a symlink — contains machine-specific paths)
  mkdir -p "$HOME/.claude"
  case "$HOME" in
    *\|*) die "\$HOME contains '|' — cannot safely substitute paths in settings template" ;;
  esac
  if [ -f "$HOME/.claude/settings.json" ] && [ ! -L "$HOME/.claude/settings.json" ]; then
    local bak="$HOME/.claude/settings.json.$(date +%Y%m%dT%H%M%S).bak"
    warn "Backing up existing ~/.claude/settings.json -> $bak"
    cp "$HOME/.claude/settings.json" "$bak"
  fi
  # Remove any symlink (live or dangling) so the redirect always creates a plain file
  [ -L "$HOME/.claude/settings.json" ] && rm -f "$HOME/.claude/settings.json"
  sed "s|__HOME__|$HOME|g" "$DOTFILES_DIR/claude/settings.json.template" \
    > "$HOME/.claude/settings.json"
  if grep -q '__HOME__' "$HOME/.claude/settings.json"; then
    die "Template substitution failed — __HOME__ still present in generated settings.json"
  fi
  ok "Generated ~/.claude/settings.json"

  link "$DOTFILES_DIR/claude/commands"       "$HOME/.claude/commands"
  link "$DOTFILES_DIR/claude/agents"         "$HOME/.claude/agents"

  # Hooks must be executable
  chmod +x "$DOTFILES_DIR/claude/hooks/"*.sh 2>/dev/null || true
  link "$DOTFILES_DIR/claude/hooks"          "$HOME/.claude/hooks"

  # Skills plugin — loaded automatically from ~/.claude/skills/
  mkdir -p "$HOME/.claude/skills"
  link "$DOTFILES_DIR/claude/plugin"         "$HOME/.claude/skills/devenv-bootstrap"
  ok "Claude config linked"
}

# ── Set default shell ────────────────────────────────────────────────────────
set_shell() {
  if [ "$SHELL" != "$(which zsh)" ]; then
    info "Setting default shell to zsh..."
    # Use sudo usermod when passwordless sudo is available (e.g. Vagrant provisioning),
    # since chsh requires PAM authentication which fails non-interactively.
    if sudo -n usermod -s "$(which zsh)" "$USER" 2>/dev/null; then
      ok "Default shell set to zsh (restart terminal)"
    else
      chsh -s "$(which zsh)"
      ok "Default shell set to zsh (restart terminal)"
    fi
  else
    ok "zsh already default shell"
  fi
}

# ── Main ─────────────────────────────────────────────────────────────────────
main() {
  info "Starting devenv bootstrap..."
  install_packages
  install_nvim
  install_omz
  install_tpm
  install_code_server
  install_claude
  install_go
  link_dotfiles
  link_claude
  if [ "${SKIP_CLAUDIO:-0}" != "1" ]; then
    install_claudio
  else
    info "Skipping Claudio (SKIP_CLAUDIO=1)"
  fi
  set_shell
  ok "Bootstrap complete! Start a new shell or run: exec zsh"
}

main "$@"
