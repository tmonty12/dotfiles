# Home Manager Configuration

Declarative user-environment configuration using Nix Home Manager.

This directory manages shell configuration, CLI packages, Git, SSH, Vim,
Neovim, Rust bootstrap, and a small set of Python tools installed through
`uv`.

## Entry Point

Use the Makefile as the supported interface:

```bash
cd home-manager
make help
```

First-time setup on a machine without Nix:

```bash
make install
```

After restarting the terminal, apply a target:

```bash
make home      # local macOS target for tmontfort
make bataquaman  # Linux target for tmontfort
make vm        # Linux VM target, auto-selects nvidia vs ubuntu
make vm-arm    # Linux ARM VM target
```

## Flake Targets

Targets are defined in `flake.nix`:

- `home`: local macOS config for `tmontfort` at `/Users/tmontfort`
- `bataquaman`: Linux config for `tmontfort` at `/home/tmontfort`
- `brev-vm`: Linux config for `ubuntu`
- `brev-vm-gpu`: Linux config for `nvidia`
- `brev-vm-arm`: ARM Linux config for `ubuntu`

You can also run Home Manager directly:

```bash
nix run home-manager/master -- switch --flake .#home -b backup
```

## Layout

```text
home-manager/
├── flake.nix
├── flake.lock
├── home.nix
├── Makefile
├── modules/
│   ├── bash.nix
│   ├── git.nix
│   ├── neovim.nix
│   ├── rust.nix
│   ├── ssh.nix
│   ├── uvx.nix
│   ├── vim.nix
│   └── zsh.nix
└── config/nvim/
```

## What It Manages

- `home.nix`: shared packages, module imports, global aliases, and PATH additions.
- `modules/git.nix`: Git identity, signing, ignores, delta, and gh-dash.
- `modules/zsh.nix`: zsh completion, history, aliases, prompt, zoxide, Atuin, and local overrides.
- `modules/bash.nix`: bash completion, history, aliases, prompt, Atuin, and local overrides.
- `modules/ssh.nix`: SSH includes, multiplexing, GitHub identity, and agent/keychain behavior.
- `modules/vim.nix`: Vim config, ALE, autosave, and jellybeans.
- `modules/neovim.nix`: Neovim enablement and linked Lua config.
- `modules/rust.nix`: rustup bootstrap.
- `modules/uvx.nix`: `uv tool install` for `llm`, `y-cli`, and `ty`.
- `config/nvim/`: Lua Neovim config loaded by `modules/neovim.nix`.

## Common Commands

```bash
make check        # validate the flake
make update       # update flake inputs
make clean        # collect old Nix generations/store paths
make generations  # list Home Manager generations
make rollback     # roll back to previous Home Manager generation
```

## Local Overrides

Machine-specific shell customizations should live outside Home Manager:

- `~/.zshrc.local`
- `~/.bashrc.local`

Those files are sourced by the managed shell configs when present.
