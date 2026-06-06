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
  sudo install -m 0755 "$tmp"/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
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

# ── Symlink dotfiles ─────────────────────────────────────────────────────────
link_dotfiles() {
  info "Linking dotfiles..."
  link "$DOTFILES_DIR/zsh/.zshrc"      "$HOME/.zshrc"
  link "$DOTFILES_DIR/zsh/aliases.zsh" "$HOME/.config/zsh/aliases.zsh"
  link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
  link "$DOTFILES_DIR/nvim"            "$HOME/.config/nvim"
  ok "Dotfiles linked"
}

# ── Claude config ────────────────────────────────────────────────────────────
link_claude() {
  info "Linking Claude config..."
  link "$DOTFILES_DIR/claude/settings.json"  "$HOME/.claude/settings.json"
  link "$DOTFILES_DIR/claude/commands"       "$HOME/.claude/commands"
  link "$DOTFILES_DIR/claude/agents"         "$HOME/.claude/agents"

  # Hooks must be executable
  chmod +x "$DOTFILES_DIR/claude/hooks/"*.sh 2>/dev/null || true
  link "$DOTFILES_DIR/claude/hooks"          "$HOME/.claude/hooks"
  ok "Claude config linked"
}

# ── Set default shell ────────────────────────────────────────────────────────
set_shell() {
  if [ "$SHELL" != "$(which zsh)" ]; then
    info "Setting default shell to zsh..."
    chsh -s "$(which zsh)"
    ok "Default shell set to zsh (restart terminal)"
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
  install_claude
  link_dotfiles
  link_claude
  set_shell
  ok "Bootstrap complete! Start a new shell or run: exec zsh"
}

main "$@"
