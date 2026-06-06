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
    ├── settings.json   # Linked to ~/.claude/settings.json
    ├── commands/       # Linked to ~/.claude/commands/  (custom slash commands)
    ├── agents/         # Linked to ~/.claude/agents/    (custom sub-agents)
    └── hooks/          # Linked to ~/.claude/hooks/     (event hooks)
```

## Install

```bash
git clone <repo-url> ~/devenv-bootstrap
cd ~/devenv-bootstrap
bash install.sh
```

The script installs packages, sets up Oh My Zsh + plugins, TPM, neovim, Claude Code, then symlinks all dotfiles.

## Claude commands

| Command | Description |
|---------|-------------|
| `/commit` | Stage changes and write a conventional commit |
| `/plan <feature>` | Design implementation plan before coding |
| `/debug <issue>` | Systematic root-cause debugging |
| `/pr` | Push branch and open a GitHub PR |

## Claude agents

| Agent | Description |
|-------|-------------|
| `code-reviewer` | Reviews diffs for bugs and security issues |
| `architect` | Designs feature architectures with concrete blueprints |
| `debugger` | Hypothesis-driven bug tracing |

## Notes

- MCP server configs in `claude/settings.json` use `${GITHUB_TOKEN}` — set this in your environment.
- After install, run `exec zsh` then `p10k configure` to set up the Powerlevel10k prompt.
- First `nvim` launch will auto-install all LazyVim plugins.
- Tmux plugins install with `<prefix>I` (Ctrl-a then I) after first launch.
