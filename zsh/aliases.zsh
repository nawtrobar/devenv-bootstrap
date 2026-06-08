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
# Inside the Vagrant dev VM, run Claude with no permission prompts. Gated on
# /vagrant + its Vagrantfile so it only fires in a real Vagrant guest — never on
# the WSL host (no /vagrant), which keeps full guardrails.
#
# CAVEAT — the VM is only *partly* disposable. Its synced folders are LIVE host
# paths, not throwaway state:
#   /vagrant                     -> this repo's project dir on the host
#   /opt/devenv-bootstrap        -> the devenv-bootstrap host repo
#   /opt/fiverr-agents-and-skills-> the fiverr-kit host repo
# With --dangerously-skip-permissions, a destructive command (e.g. rm -rf) under
# any of those trees deletes REAL host files with no prompt. The VM OS is
# disposable; the synced trees are not. Do throwaway work outside them, and
# commit often. (If you add more synced_folder mounts, they carry the same risk.)
if [ -d /vagrant ] && [ -f /vagrant/Vagrantfile ]; then
  alias claude='claude --dangerously-skip-permissions'
fi
alias cl='claude'
