# Aliases

alias p 'pnpm'
alias oc 'opencode'
alias gg 'lazygit'

# git aliases

# Basic operations
alias gs 'git status'
alias ga 'git add'
alias gd 'git diff'
alias gds 'git diff --staged'

# Commit
alias gc 'git commit'
alias gac 'git add -A && git commit'
alias gca 'git commit --amend'
alias gcan 'git commit --amend --no-edit'

# Branch
alias gb 'git branch'
alias gco 'git checkout'
alias gbd 'git branch -d'
alias gbD 'git branch -D'

# Remote
alias gf 'git fetch'
alias gp 'git pull'
alias ggp 'git push'
alias ggpf 'git push --force'

# History & log
alias gl 'git log'

# Merge & rebase
alias gm 'git merge'
alias gr 'git rebase'
alias gri 'git rebase -i'

# Stash
alias gst 'git stash'
alias gstp 'git stash pop'
alias gstl 'git stash list'

# Undo
alias grh 'git reset HEAD~1'
alias grhh 'git reset --hard HEAD~1'