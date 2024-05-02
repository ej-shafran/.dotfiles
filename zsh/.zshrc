#!/usr/bin/env zsh

sourceif() {
  [[ -f "$1" ]] && source "$1"
}

# {{{ Environment variables

# {{{ Tool configuration

# Colored `gcc` warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Use `bat` as the pager for `man`
if command -v bat >/dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Starship config file
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# Setup MySQL prompt to show user, host and database
export MYSQL_PS1='[\u@\h] \d> '

# You can add/override environment variables for configuration
# that you don't want to push to git in "$HOME/.zsh_configs.local"
sourceif "$HOME/.zsh_configs.local"

# }}}

# {{{ Tool locations

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
# that you don't want to push to git in "$HOME/.zsh_tools.local"
sourceif "$HOME/.zsh_tools.local"

# }}}

# }}}

# {{{ Miscellaneous settings

# Make `less` more friendly for non-text input
# See |lesspipe(1)|
if [[ -x /usr/bin/lesspipe ]]; then
  eval "$(SHELL=/bin/sh lesspipe)"
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

# }}}

# }}}

# {{{ Source additional tool configurations

# Fuzzy files
sourceif "$HOME/.fzf.zsh"

# Haskell manager
sourceif "$GHCUP_DIR/env"

# Cargo
sourceif "$CARGO_DIR/env"

if command -v starship >/dev/null; then
  eval "$(starship init bash)"
fi

# }}}

# {{{ Load aliases and utils

sourceif "$HOME/.zsh_aliases"
sourceif "$HOME/.zsh_aliases.local"

sourceif "$HOME/.zsh_utils"
sourceif "$HOME/.zsh_utils.local"

# }}}

# vim: foldmethod=marker