# AGENTS.md - Coding Agent Instructions

## Repository Overview

This is a **macOS dotfiles repository** managed with GNU Stow. It contains:

- `dot` - A Bash CLI (~670 lines) for interactive Mac setup, package management, and dotfile stowing
- `home/` - Stow-managed dotfiles symlinked into `$HOME` (Fish shell, Git, Ghostty, Starship, OpenCode)
- `home/.local/bin/coffee` - A Bash CLI wrapper around macOS `caffeinate`
- `packages/Brewfile` - Homebrew bundle manifest (CLI tools + GUI apps)

Target platform: **macOS (Apple Silicon, /opt/homebrew)**. Primary shell: **Fish**. Editor: **Neovim**.

---

## Build / Lint / Test Commands

There is no formal build system, test framework, or CI pipeline. The codebase is shell scripts and config files.

### Validation

```bash
# Health check - verifies all tools, packages, and symlinks are correct
dot doctor

# Lint Bash scripts with shellcheck (installed separately)
shellcheck dot
shellcheck home/.local/bin/coffee

# Validate Brewfile syntax
brew bundle check --file=packages/Brewfile
```

### Common Operations

```bash
dot init                    # Interactive full Mac setup (Homebrew, packages, stow, SSH)
dot stow                    # Stow dotfiles from home/ into $HOME (backs up conflicts)
dot link                    # Symlink 'dot' CLI into /usr/local/bin/
dot unlink                  # Remove the symlink
dot update                  # brew update && brew upgrade && brew upgrade --cask && brew cleanup
dot add <brew|cask> <pkg>   # Install package and add to Brewfile (sorted)
dot remove <brew|cask> <pkg> # Uninstall package and remove from Brewfile
dot ssh [email]             # Generate ed25519 SSH key, configure macOS keychain
dot doctor                  # Verify installation status
```

### Running Individual Checks

There are no unit tests. To validate a specific script after editing:

```bash
# Check a single script for errors
shellcheck dot
shellcheck home/.local/bin/coffee

# Dry-run stow to check for conflicts without applying
stow -n -v -t "$HOME" home
```

---

## Code Style Guidelines

### Bash Scripts

All Bash scripts in this repo follow these conventions:

1. **Shebang**: Always `#!/usr/bin/env bash`
2. **Strict mode**: Always `set -euo pipefail` immediately after shebang
3. **Indentation**: 4 spaces, no tabs
4. **Line length**: No hard limit, but keep lines readable (~100 chars)
5. **Quoting**: Always double-quote variables: `"$var"`, `"${array[@]}"`

### Naming Conventions

- **Global constants**: `UPPER_SNAKE_CASE` (e.g., `DOTFILES_DIR`, `BREWFILE`, `PIDFILE`)
- **Local variables**: `lower_snake_case` with `local` keyword (e.g., `local has_errors=0`)
- **Functions**: `lower_snake_case` (e.g., `command_exists`, `stop_session`, `parse_duration`)
- **Subcommand handlers**: Prefixed with `cmd_` (e.g., `cmd_init`, `cmd_doctor`, `cmd_stow`)
- **Helper/utility functions**: Descriptive verbs (e.g., `confirm`, `info`, `error`)

### Script Structure

Scripts follow this ordering pattern:

1. Shebang + strict mode
2. Color/constant definitions
3. Path/config variables
4. Helper/utility functions
5. Command functions (each separated by `# ===...===` comment blocks)
6. Main dispatch (`case` statement)
7. Entry point: `main "$@"`

### Output and Logging

Use the colored logging helpers consistently:

```bash
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
```

- `info` for progress/status messages
- `success` for completed operations
- `warn` for non-fatal issues
- `error` for failures

### Error Handling

- Use `set -euo pipefail` - scripts exit on error, unset variable, or pipe failure
- Guard commands that may fail with `|| true` when failure is acceptable
- Redirect stderr with `2>/dev/null` for commands where failure output is noise
- Use `return 1` (not `exit 1`) in functions to allow callers to handle errors
- In case-dispatch `*)` blocks, print an error and show usage before `exit 1`

### Conditionals and Control Flow

- Use `[[ ]]` for tests, never `[ ]`
- Use `command -v "$1" &>/dev/null` to check if a command exists
- Use `local` for all function-scoped variables
- Prefer `if/else` for multi-line blocks, `[[ cond ]] && action` for one-liners

### Fish Shell Config (`home/.config/fish/config.fish`)

- Aliases are defined inside `if status is-interactive` block
- Functions use `function name ... end` syntax
- PATH additions use `fish_add_path` (not manual `$PATH` manipulation)
- Environment variables use `set -gx NAME value`
- Tool initializations use `command --flags | source` pattern

### Brewfile (`packages/Brewfile`)

- Format: one entry per line, `brew "name"` for CLI tools, `cask "name"` for GUI apps
- Sorted alphabetically within each section (brew, then cask)
- First line sets `cask_args appdir: "/Applications"`

---

## Git Configuration

- **Default branch**: `main`
- **Pull strategy**: rebase (not merge)
- **Push**: `autoSetupRemote = true`
- **Rerere**: enabled (reuse recorded resolution)
- **Fetch**: prune + writeCommitGraph
- **Commit identity**: Personal email for general repos, `vshinde@cloudflare.com` for `~/work/` repos (via conditional include)
- **Global gitignore**: ignores `mise.toml`

---

## File Organization

```
.dotfiles/
  dot                              # Main CLI (Bash)
  packages/Brewfile                # Homebrew manifest
  home/                            # Stow root -> symlinked to ~/
    .config/
      fish/config.fish             # Fish shell config
      ghostty/config               # Terminal emulator config
      git/config                   # Global git config
      git/work_config              # Conditional work git config
      git/ignore                   # Global gitignore
      opencode/opencode.json       # OpenCode AI assistant config
      starship.toml                # Prompt config
    .local/bin/coffee              # caffeinate wrapper CLI (Bash)
```

### Adding New Dotfiles

1. Place files under `home/` mirroring the `$HOME` directory structure
2. Run `dot stow` to create symlinks
3. Add any sensitive files to `.gitignore`

---

## Security Notes

- **Never commit secrets**: `.env`, `.envrc`, `secrets.fish`, and credentials are gitignored
- **SSH keys**: Generated via `dot ssh`, stored at `~/.ssh/id_ed25519`, never committed
- **OpenCode permissions**: Denies reading `*.env`, `*.envrc`, and `secrets/*` files
- **Work separation**: Git identity switches automatically for `~/work/` repos

---

## Key Dependencies

| Tool | Purpose |
|------|---------|
| GNU Stow | Symlink manager for dotfiles |
| Homebrew | macOS package manager |
| Fish | Primary shell |
| Starship | Cross-shell prompt |
| mise | Runtime version manager (node, bun) |
| Neovim | Editor (`$EDITOR`) |
| Ghostty | Terminal emulator |
| fzf | Fuzzy finder |
| zoxide | Smart `cd` replacement |
| ripgrep | Fast grep alternative |
