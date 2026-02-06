# Disable greeting
set fish_greeting 

# Set Editor to neovim
set -gx EDITOR 'nvim'

# Set neovim as the program to open manpages
set -gx MANPAGER 'nvim +Man!'


if status is-interactive
    # Commands to run in interactive sessions can go here
    
    # Aliases
    alias p="pnpm"
    alias gg="lazygit"
    alias gs="git status"
    alias gco="git checkout"
    alias gl="git log"
    alias gp="git pull"
    alias ggp="git push"
    alias ggpf="git push --force"
    alias ls="ls --color=auto"
    
    # Functions
    function upgrade-tools
        opencode upgrade
        brew upgrade
    end
    
    function take
        mkdir -p $argv[1] && z $argv[1]
    end
    
    function remove-wrangler-auth
        rm -rf .wrangler node_modules/.cache node_modules/.vite node_modules/.vite-temp
    end
end

# Homebrew
/opt/homebrew/bin/brew shellenv | source

# Shell tool initializations
fzf --fish | source
zoxide init fish | source
starship init fish | source
/Users/vshinde/.local/bin/mise activate fish | source

# PATH additions

# Add dotfiles directory to PATH for 'dot' command
fish_add_path ~/.dotfiles

fish_add_path /Users/vshinde/.codeium/windsurf/bin
fish_add_path /Users/vshinde/.opencode/bin
fish_add_path /Users/vshinde/.bun/bin
fish_add_path /Users/vshinde/.cargo/bin
