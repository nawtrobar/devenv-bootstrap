# ── Powerlevel10k instant prompt (must be at very top) ───────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── zsh-vi-mode config (must be set BEFORE the plugin loads) ─────────────────
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk        # jk exits insert mode
ZVM_CURSOR_STYLE_ENABLED=true          # beam in insert, block in normal
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT    # always start in insert mode
ZVM_LAZY_KEYBINDINGS=false

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  z
  fzf
  docker
  docker-compose
  npm
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)

source "$ZSH/oh-my-zsh.sh"

# ── zsh-vi-mode (must be sourced AFTER oh-my-zsh to override keybindings) ────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[[ -f "$ZSH_CUSTOM/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]] &&
  source "$ZSH_CUSTOM/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

# history-substring-search bindings via zvm_after_init so vi-mode doesn't clobber them
zvm_after_init_commands+=(
  'bindkey "^[[A" history-substring-search-up'
  'bindkey "^[[B" history-substring-search-down'
  'bindkey -M vicmd "k" history-substring-search-up'
  'bindkey -M vicmd "j" history-substring-search-down'
)

# ── Environment ───────────────────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export MANPAGER="nvim +Man!"

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

[ -s "$HOME/.nvm/nvm.sh" ] && source "$HOME/.nvm/nvm.sh"

# ── Classic dark: LS_COLORS (Catppuccin-toned) ────────────────────────────────
# di=dir  ln=symlink  ex=executable  so=socket  pi=pipe  bd/cd=device
export LS_COLORS='di=1;34:ln=1;36:so=1;32:pi=33:ex=1;32:bd=1;33:cd=1;33:or=1;31:mi=1;31:*.tar=31:*.gz=31:*.zip=31:*.jpg=35:*.png=35:*.mp4=35:*.mp3=36'

# ── Classic dark: zsh-syntax-highlighting colors ─────────────────────────────
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=2,bold'        # green, commands
ZSH_HIGHLIGHT_STYLES[alias]='fg=2,bold'          # green, aliases
ZSH_HIGHLIGHT_STYLES[builtin]='fg=4,bold'        # blue, builtins
ZSH_HIGHLIGHT_STYLES[function]='fg=2'            # green, functions
ZSH_HIGHLIGHT_STYLES[path]='fg=6'                # cyan, paths
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=6'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=3'            # yellow, globs
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=3'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=3'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=3'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=3'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=5' # magenta, $()
ZSH_HIGHLIGHT_STYLES[redirection]='fg=5'
ZSH_HIGHLIGHT_STYLES[comment]='fg=8'             # gray, comments
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=1,bold'  # red, errors

# ── History ───────────────────────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS SHARE_HISTORY INC_APPEND_HISTORY

# ── zsh-history-substring-search ─────────────────────────────────────────────
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=2,fg=0,bold'    # green match
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=1,fg=0,bold' # red no match
HISTORY_SUBSTRING_SEARCH_FUZZY=false     # exact prefix match (faster)

# ── zsh-autosuggestions ───────────────────────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585b70"   # Catppuccin surface2 (subtle gray)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^ ' autosuggest-accept              # Ctrl+Space accepts suggestion

# ── fzf: Catppuccin Mocha colors ─────────────────────────────────────────────
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="
  --height 40% --layout=reverse --border
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
"

# ── Aliases ───────────────────────────────────────────────────────────────────
[[ -f "$HOME/.config/zsh/aliases.zsh" ]] && source "$HOME/.config/zsh/aliases.zsh"

# ── Powerlevel10k config ─────────────────────────────────────────────────────
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
