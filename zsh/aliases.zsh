# ── Navigation ───────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# ── ls / eza ─────────────────────────────────────────────────────────────────
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias ll='eza --icons -l --git'
  alias la='eza --icons -la --git'
  alias lt='eza --icons --tree --level=2'
else
  alias ls='ls --color=auto'
  alias ll='ls -lhF'
  alias la='ls -lhAF'
fi

# ── Editor ───────────────────────────────────────────────────────────────────
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# ── Git ──────────────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gap='git add -p'
alias gc='git commit'
alias gca='git commit --amend'
alias gco='git checkout'
alias gb='git branch'
alias gbd='git branch -d'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -20'
alias gll='git log --oneline --graph --decorate --all'
alias gp='git push'
alias gpl='git pull'
alias gpf='git push --force-with-lease'
alias gst='git stash'
alias gstp='git stash pop'

# ── tmux ─────────────────────────────────────────────────────────────────────
alias ta='tmux attach -t'
alias tls='tmux list-sessions'
alias tn='tmux new-session -s'
alias tk='tmux kill-session -t'

# ── Misc ─────────────────────────────────────────────────────────────────────
alias c='clear'
alias q='exit'
alias h='history | tail -30'
alias path='echo $PATH | tr ":" "\n"'
alias ports='ss -tulpn'
alias ip='ip -color addr'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -sh'
alias free='free -h'
alias top='htop 2>/dev/null || top'

# ── Claude ───────────────────────────────────────────────────────────────────
alias cl='claude'
