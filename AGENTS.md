# AGENTS.md - Coding Agent Instructions

## Repository Overview

macOS dotfiles repository managed with GNU Stow containing:

- `dot` - Bash CLI (~1090 lines) for Mac setup, package management, and stowing
- `home/` - Stow-managed dotfiles by profile (common, work, personal)
- `home/common/.local/bin/coffee` - Bash CLI wrapper for macOS `caffeinate`
- `packages/Brewfile*` - Homebrew manifests (base + profile-specific)

Platform: **macOS (Apple Silicon)**. Shell: **Fish**. Editor: **Neovim**.

---

## Build / Lint / Test Commands

No formal build/test system. Validate with:

```bash
dot doctor                                    # Verify tools, packages, symlinks
shellcheck dot                                # Lint main CLI
shellcheck home/common/.local/bin/coffee      # Lint coffee script
brew bundle check --file=packages/Brewfile    # Validate Brewfile
stow -n -v -t "$HOME" -d home common          # Dry-run stow (no changes)
```

### Common Operations

```bash
dot init                              # Interactive full Mac setup
dot stow [work|personal]              # Stow dotfiles (common + profile)
dot doctor                            # Verify installation status
dot update                            # brew update && upgrade && cleanup
dot add <brew|cask> <pkg> [profile]   # Install and add to Brewfile
dot remove <brew|cask> <pkg>          # Uninstall and remove from Brewfile
dot install                           # Install all packages from Brewfiles
```

---

## Code Style Guidelines

### Bash Scripts

1. **Shebang**: `#!/usr/bin/env bash`
2. **Strict mode**: `set -euo pipefail` (always, immediately after shebang)
3. **Indentation**: 4 spaces, no tabs
4. **Quoting**: Always double-quote: `"$var"`, `"${array[@]}"`

### Naming Conventions

- **Constants**: `UPPER_SNAKE_CASE` (`DOTFILES_DIR`, `BREWFILE`)
- **Variables**: `local lower_snake_case` (`local has_errors=0`)
- **Functions**: `lower_snake_case` (`command_exists`, `parse_duration`)
- **Subcommands**: `cmd_` prefix (`cmd_init`, `cmd_doctor`)

### Script Structure

1. Shebang + strict mode
2. Color/constant definitions
3. Path/config variables
4. Helper functions
5. Command functions (separated by `# ===...===` blocks)
6. Main dispatch (`case` statement)
7. Entry point: `main "$@"`

### Logging Helpers

```bash
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }
```

### Error Handling

- `set -euo pipefail` exits on error, unset var, or pipe failure
- Use `|| true` for commands where failure is acceptable
- Use `2>/dev/null` when failure output is noise
- Use `return 1` in functions (not `exit 1`)
- `*)` blocks: print error, show usage, then `exit 1`

### Conditionals

- Use `[[ ]]` for tests, never `[ ]`
- Use `command -v "$1" &>/dev/null` to check command existence
- Use `local` for all function variables

### Fish Shell (`home/common/.config/fish/`)

- Main config in `config.fish`, modular `conf.d/*.fish` files
- Interactive code inside `if status is-interactive` block
- PATH: use `fish_add_path`, not manual `$PATH` manipulation
- Environment: `set -gx NAME value`
- Tool init: `command --flags | source` pattern

### Brewfile (`packages/Brewfile*`)

- Format: `brew "name"` for CLI, `cask "name"` for GUI
- Sorted alphabetically within sections
- Base has `cask_args appdir: "/Applications"` header

---

## File Organization

```
.dotfiles/
  dot                                 # Main CLI
  packages/
    Brewfile                          # Base packages
    Brewfile.work                     # Work-specific
    Brewfile.personal                 # Personal-specific
  home/
    common/                           # Always stowed
      .config/fish/config.fish
      .config/fish/conf.d/*.fish
      .config/ghostty/config
      .config/git/{config,ignore}
      .config/starship.toml
      .local/bin/coffee
    work/                             # Work profile
      .config/git/profile_config
      .config/opencode/opencode.json
    personal/                         # Personal profile
      .config/git/profile_config
```

### Stow Profiles

- **common**: Always applied (fish, ghostty, starship, git base)
- **work/personal**: Mutually exclusive (git identity, profile tools)
- Active profile stored in `.active_profile`

### Adding Dotfiles

1. Place in `home/{common,work,personal}/` mirroring `$HOME` structure
2. Run `dot stow` to create symlinks
3. Add secrets to `.gitignore`

---

## Security

- Never commit: `.env`, `.envrc`, `secrets.fish`, credentials
- SSH keys via `dot ssh`, stored at `~/.ssh/id_ed25519`
- Git identity switches via profile-specific `profile_config`

---

## Key Dependencies

| Tool | Purpose |
|------|---------|
| GNU Stow | Symlink manager |
| Homebrew | Package manager |
| Fish | Primary shell |
| Starship | Cross-shell prompt |
| mise | Runtime manager (node, bun) |
| Neovim | Editor (`$EDITOR`) |
| Ghostty | Terminal emulator |
