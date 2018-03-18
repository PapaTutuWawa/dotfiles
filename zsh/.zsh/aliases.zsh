#!/usr/bin/zsh
# Folder navigation
alias ..="cd ../"
alias ...="cd ../../"
alias home='cd $HOME'

# Shell
alias c="clear"
alias reload='$SHELL -l'

# Antibody
alias antibundle='antibody bundle < $HOME/.zsh/bundle > $HOME/.zsh/bundle.zshn'

# tmux
alias tmux='tmux -2 -f $HOME/.config/tmux/config'

# Development
alias dev='cd $HOME/Development'
alias build='cd $HOME/Build'

# WM
alias lock="swaylock"
alias suspend="systemctl suspend"

# npcmpcpp
alias n='ncmpcpp --config $HOME/.config/ncmpcpp/config'
