#!/usr/bin/zsh
# Shellcheck is not happy about the source
# shellcheck disable=SC1090

# Source the bundled plugins
source "$HOME/.zsh/bundle.zsh"
# The one from oh-my-zsh does not really work, so we need to "patch" it
source "$HOME/.zsh/extra/common-aliases.zsh"

# Custom auto-completion files
# If some function definitions start not working, comment this out!
fpath=("$HOME/.zsh/completion" $fpath)

# Fix zsh not interpreting the left and right arrow keys as
# forwards and backwards
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# I don't know why, but ls does not output color
# FIX IT
alias ls="ls --color=always"

# Not everything needs to go to /usr/local/bin
export PATH="$HOME/.local/bin:$PATH"
export CARGO_HOME="$HOME/.cargo"

# My keyboard may be German, but I want my system on English!
export LANG="en_GB.UTF-8"
export LC_ALL="en_GB.UTF-8"

# Set my default editor
export ALTERNATE_EDITOR=""
export EDITOR="/usr/local/bin/editor"

# Set all my aliases
source "$HOME/.zsh/aliases.zsh"
