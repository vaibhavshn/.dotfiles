# Disable greeting
set fish_greeting 

# Set Editor to neovim
set -gx EDITOR 'nvim'

# Set neovim as the program to open manpages
set -gx MANPAGER 'nvim +Man!'

if status is-interactive
    # Commands to run in interactive sessions can go here
    
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
