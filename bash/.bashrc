#!/usr/bin/env bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# This function checks if a file exists, and sources it if it does.
# This way, we can enable certain tools only if they actually exist.
sourceif() {
  if [ -f "$1" ]; then
    . "$1"
  fi
}

# {{{ Environment variables

# {{{ Tool configuration

# Colored `gcc` warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Use kitty as the default terminal
if command -v kitty >/dev/null; then
  export TERMINAL="kitty"
fi

# Use `bat` as the pager for `man`
if command -v bat >/dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Starship config file
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# Setup MySQL prompt to show user, host and database
export MYSQL_PS1='[\u@\h] \d> '

# You can add/override environment variables for configuration
# that you don't want to push to git in "$HOME/.bash_configs.local"
sourceif "$HOME/.bash_configs.local"

# }}}

# {{{ Tool locations

# Kitty
export KITTY_INSTALL="$HOME/.local/kitty.app"

# Android SDK
export ANDROID_HOME="$HOME/AndroidSDK"

# PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"

# Bun
export BUN_INSTALL="$HOME/.bun"

# Deno
export DENO_INSTALL="$HOME/.deno"

# Node Version Manager
export NVM_DIR="$HOME/.nvm"

# Cabal
export CABAL_DIR="$HOME/.cabal"

# GHCUP
export GHCUP_DIR="$HOME/.ghcup"

# Cargo
export CARGO_DIR="$HOME/.cargo"

# You can add/override environment variables for tools
# that you don't want to push to git in "$HOME/.bash_tools.local"
sourceif "$HOME/.bash_tools.local"

# }}}

# }}}

# {{{ History settings

# Don't put duplicate lines or lines starting with space into history
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Append to the history file instead of overwriting it
shopt -s histappend

# }}}

# {{{ Miscellaneous settings

# Update the values of LINES and COLUMNS
shopt -s checkwinsize

# Make `less` more friendly for non-text input
# See |lesspipe(1)|
if [ -x /usr/bin/lesspipe ]; then
  eval "$(SHELL=/bin/sh lesspipe)"
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# }}}

# {{{ Set system PATH

# {{{ Global

# Basic binary directories
export PATH="/bin"
export PATH="$PATH:/sbin"
export PATH="$PATH:/usr/bin"
export PATH="$PATH:/usr/sbin"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/sbin"

# Snap binaries
export PATH="$PATH:/snap/bin"

# Games
export PATH="$PATH:/usr/games"
export PATH="$PATH:/usr/local/games"

# }}}

# {{{ User

# Personal binaries
export PATH="$PATH:$HOME/.local/bin"

# Screen layout related binaries
export PATH="$PATH:$HOME/.screenlayout"

# Kitty
export PATH="$PATH:$KITTY_INSTALL/bin"

# Haskell binaries
export PATH="$PATH:$CABAL_DIR/bin"
export PATH="$PATH:$GHCUP_DIR/bin"

# Cargo
export PATH="$PATH:$CARGO_DIR/bin"

# Node
export PATH="$PATH:$HOME/node_modules/.bin"

# Deno
export PATH="$PATH:$DENO_INSTALL/bin"

# Zig
export PATH="$PATH:$HOME/.zig"

# Golang
export PATH="$PATH:$HOME/.local/go/bin"
export PATH="$PATH:$HOME/go/bin"

# PNPM
export PATH="$PATH:$PNPM_HOME"

# Bun
export PATH="$PATH:$HOME/.bun"

# Update PATH for the Google Cloud SDK
sourceif "$HOME/google-cloud-sdk/path.bash.inc"

# Shell completion for Google Cloud SDK
sourceif "$HOME/google-cloud-sdk/completion.bash.inc"

# }}}

# }}}

# {{{ Source additional tool configurations

# Node Version Manager
sourceif "$NVM_DIR/nvm.sh"
sourceif "$NVM_DIR/bash_completion"

# Fuzzy files
sourceif "$HOME/.fzf.bash"

# Haskell manager
sourceif "$GHCUP_DIR/env"

# Cargo
sourceif "$CARGO_DIR/env"

if command -v starship >/dev/null; then
  eval "$(starship init bash)"
fi

# }}}

# {{{ Load aliases and utils

sourceif "$HOME/.bash_aliases"
sourceif "$HOME/.bash_aliases.local"

sourceif "$HOME/.bash_utils"
sourceif "$HOME/.bash_utils.local"

# }}}

# vim: foldmethod=marker
