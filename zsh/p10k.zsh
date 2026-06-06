# Powerlevel10k — classic dark configuration (Catppuccin Mocha palette)
# Re-run `p10k configure` to start fresh with the interactive wizard.
# Nerd Font required: https://www.nerdfonts.com (MesloLGS NF recommended)

# ── Prompt layout ─────────────────────────────────────────────────────────────
# Line 1: [dir][git]▶
# Line 2: ❯  (shape/color changes with vi mode)
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  dir
  vcs
  newline
  prompt_char
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status
  command_execution_time
  background_jobs
  time
)

typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true   # blank line above each prompt

# ── Classic powerline separators ─────────────────────────────────────────────
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$''          # ▶ filled
typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$''       # ▶ thin
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$''         # ◀ filled
typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$''      # ◀ thin
typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=$''
typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$''
typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=

# ── Directory ─────────────────────────────────────────────────────────────────
# Catppuccin blue bg, black text — anchors (first/last path parts) are bold
typeset -g POWERLEVEL9K_DIR_BACKGROUND=4             # terminal blue
typeset -g POWERLEVEL9K_DIR_FOREGROUND=0             # black
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=8   # gray for shortened parts
typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3         # 🔒 icon when not writable

# ── VCS (git) ─────────────────────────────────────────────────────────────────
# Segment color reflects repo state
typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=2         # green  — nothing to commit
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=0
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=3      # yellow — staged or unstaged
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=0
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=3     # yellow — untracked files
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=0

# Git status icons
typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=$' '      #  branch
typeset -g POWERLEVEL9K_VCS_COMMIT_ICON=$' '      #  detached HEAD
typeset -g POWERLEVEL9K_VCS_STAGED_ICON='+'             # staged changes
typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='!'           # unstaged changes
typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'          # untracked files
typeset -g POWERLEVEL9K_VCS_STASH_ICON='≡'              # stash entries
typeset -g POWERLEVEL9K_VCS_AHEAD_ICON='⇡'              # commits ahead remote
typeset -g POWERLEVEL9K_VCS_BEHIND_ICON='⇣'             # commits behind remote
typeset -g POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON=$' ' # → different remote branch

# What git data to fetch and display
typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=(
  vcs-detect-changes
  git-untracked
  git-aheadbehind
  git-stash
  git-remotebranch
  git-tagname
)
typeset -g POWERLEVEL9K_VCS_SHOW_CHANGESET=false

# ── Prompt character ─────────────────────────────────────────────────────────
# Shape changes with vi mode: ❯ insert, ❮ normal, V visual, ▶ replace
# Color changes: green (ok), red (error), blue (normal mode)
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=2     # green
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND=4     # blue
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIVIS_FOREGROUND=3     # yellow
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIOWR_FOREGROUND=5     # magenta
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=1  # red
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND=1
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIVIS_FOREGROUND=1
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIOWR_FOREGROUND=1

typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'

# ── Status ───────────────────────────────────────────────────────────────────
typeset -g POWERLEVEL9K_STATUS_OK=false                    # hide ✓ on success
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=1          # red exit code
typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'

# ── Command execution time ─────────────────────────────────────────────────────
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3   # show if took >3s
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=3  # yellow

# ── Background jobs ───────────────────────────────────────────────────────────
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=3

# ── Time ─────────────────────────────────────────────────────────────────────
typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
typeset -g POWERLEVEL9K_TIME_FOREGROUND=8    # gray

# ── Transient prompt ──────────────────────────────────────────────────────────
# Collapses old prompts to a single ❯ line, keeping scrollback clean
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

# ── Instant prompt ───────────────────────────────────────────────────────────
typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
