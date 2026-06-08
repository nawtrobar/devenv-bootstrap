# devenv-bootstrap

Bootstrap repo for a full development environment: zsh (Oh My Zsh + Powerlevel10k), neovim (LazyVim), tmux, and Claude Code configuration.

## Structure

```
devenv-bootstrap/
├── install.sh          # Main bootstrap script — run once on a new machine
├── zsh/
│   ├── .zshrc          # Linked to ~/.zshrc
│   └── aliases.zsh     # Linked to ~/.config/zsh/aliases.zsh
├── nvim/               # Linked to ~/.config/nvim (LazyVim)
│   ├── init.lua
│   └── lua/
│       ├── config/     # options.lua, keymaps.lua, lazy.lua
│       └── plugins/    # extras.lua — custom plugin specs
├── tmux/
│   └── .tmux.conf      # Linked to ~/.tmux.conf (TPM, Catppuccin colors)
└── claude/
    ├── settings.json.template  # Generated to ~/.claude/settings.json (not symlinked)
    ├── commands/               # Linked to ~/.claude/commands/  (custom slash commands)
    ├── agents/                 # Linked to ~/.claude/agents/    (custom sub-agents)
    ├── hooks/                  # Linked to ~/.claude/hooks/     (event hooks)
    ├── optional/               # Opt-in plugin installers (run manually per-machine)
    │   └── add-resume-kit.sh
    └── plugin/                 # Linked to ~/.claude/skills/devenv-bootstrap/ (auto-loaded skills)
        └── skills/             # Model-invoked skills (auto-triggered by context)
```

## Install

```bash
git clone <repo-url> ~/devenv-bootstrap
cd ~/devenv-bootstrap
bash install.sh
```

The script installs packages, sets up Oh My Zsh + plugins, TPM, neovim, Claude Code, then symlinks all dotfiles. `~/.claude/settings.json` is generated from `claude/settings.json.template` (not symlinked) so machine-specific paths like `$HOME` are substituted at install time.

## Optional Claude plugins

Some plugins are machine-specific and not installed by default. Run the corresponding script in `claude/optional/` to add them to `~/.claude/settings.json` on a given machine.

```bash
# Add resume-kit (clone it first if needed)
git clone git@github.com:nawtrobar/resume-kit.git ~/resume-kit
bash claude/optional/add-resume-kit.sh          # uses ~/resume-kit by default
bash claude/optional/add-resume-kit.sh /custom/path  # or specify a path
```

## Claude skills (auto-triggered)

Skills are automatically applied by Claude when the context matches — no slash command needed. They live in `claude/plugin/skills/` and are loaded as a plugin from `~/.claude/skills/devenv-bootstrap/`.

| Skill | Auto-triggers when... |
|-------|----------------------|
| `brainstorming` | User describes a new feature, asks how to approach something, or has an idea to explore |
| `tdd` | Writing any new function, class, endpoint, or component |
| `systematic-debugging` | Investigating a bug, error, test failure, or unexpected behavior |
| `verification-before-completion` | About to report any task, fix, or feature as done |
| `writing-plans` | Turning an approved spec into a step-by-step implementation plan |
| `subagent-driven-development` | Complex multi-component tasks needing parallel specialist work |
| `using-git-worktrees` | Starting isolated feature work in a new branch |
| `finishing-a-development-branch` | Feature branch is complete and ready to merge or push |
| `requesting-code-review` | User wants code changes reviewed |
| `receiving-code-review` | Review findings have been returned and need to be addressed |

## Claude commands

| Command | Description |
|---------|-------------|
| `/task <description>` | Autonomous end-to-end task: tech-lead plans → engineers implement → QA → security → review |
| `/sprint <features>` | Implement a sprint of features sequentially via the full task flow |
| `/commit` | Stage changes and write a conventional commit |
| `/plan <feature>` | Design implementation plan before coding |
| `/debug <issue>` | Systematic root-cause debugging |
| `/pr` | Push branch and open a GitHub PR |

## Claude agents

### Orchestration
| Agent | Role |
|-------|------|
| `tech-lead` | Reads codebase + requirements → structured delegation plan with engineer assignments and execution order |

### Specialist engineers
| Agent | Domain |
|-------|--------|
| `frontend-engineer` | React/TS/CSS, components, state management, API consumption, accessibility |
| `backend-engineer` | REST/GraphQL APIs, business logic, auth, DB schemas/queries, validation |
| `devops-engineer` | Docker, GitHub Actions CI/CD, env config, secrets management |
| `qa-engineer` | Unit/integration/e2e tests, coverage analysis, edge cases, bug surfacing |
| `security-engineer` | OWASP top-10, injection, auth/authz audit, secrets detection — returns PASS/BLOCK verdict |

### Quality & analysis
| Agent | Domain |
|-------|--------|
| `code-reviewer` | Correctness bugs, security issues, simplification opportunities |
| `architect` | System design, ADRs, cross-cutting structural decisions |
| `debugger` | Hypothesis-driven root-cause analysis for specific bugs |

### Autonomous task flow
```
/task "add user profile page"
  └── tech-lead          → delegation plan
  └── backend-engineer   → API endpoints + DB schema (outputs contracts)
  └── frontend-engineer  → UI components (consumes contracts)
  └── devops-engineer    → infra/pipeline changes (if needed)
  └── qa-engineer        → tests + bug report
  └── security-engineer  → PASS or BLOCK
  └── code-reviewer      → final diff review
```

## Zsh features

| Feature | How |
|---------|-----|
| Vim mode | `zsh-vi-mode` — beam cursor in insert, block in normal; `jk` to escape |
| History search | Up/Down arrows filter by prefix typed; `j`/`k` in normal mode too |
| Inline suggestions | `Ctrl+Space` to accept ghost text from history |
| Git prompt | p10k `vcs` segment: branch + staged/unstaged/untracked/ahead/behind/stash |
| Syntax highlighting | Commands green, paths cyan, strings yellow, errors red |
| FZF | Catppuccin Mocha theme; `Ctrl+T` files, `Alt+C` dirs, `Ctrl+R` history |

## Audio feedback (Claudio)

[Claudio](https://claudio.click) plays contextual sounds for Claude hook events — different sounds for tool starts, successes, failures, prompts, completions, and git subcommands (`git commit` vs `npm test` vs `go build` each sound different).

```bash
claudio status       # check audio setup
claudio volume 0.5   # adjust volume
claudio mute         # silence
claudio unmute
```

WSL requires PulseAudio or WSLg for audio. Run `claudio status` after bootstrap to verify.

## Notes

- MCP servers requiring keys: set `GITHUB_TOKEN` and `BRAVE_API_KEY` in your environment before launching Claude.
- `memory` MCP needs no key — stores a knowledge graph in `~/.local/share/`.
- After install, run `exec zsh` — p10k.zsh is pre-configured (skip the wizard or run `p10k configure` to regenerate).
- First `nvim` launch will auto-install all LazyVim plugins.
- Tmux plugins install with `<prefix>I` (Ctrl-a then I) after first launch.
