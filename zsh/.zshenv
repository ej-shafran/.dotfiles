#!/usr/bin/env zsh

sourceif() {
  [[ -f "$1" ]] && source "$1" || return 0
}

export _TEST="true"

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

# Kitty
export KITTY_INSTALL="/Applications/kitty.app/Contents/MacOS/"

# You can add/override environment variables for tools
# that you don't want to push to git in "$HOME/.zsh_tools.local"
sourceif "$HOME/.zsh_tools.local"

# }}}

# {{{ Source additional tool configurations

# Fuzzy files
sourceif "$HOME/.fzf.zsh"

# Haskell manager
sourceif "$GHCUP_DIR/env"

# Cargo
sourceif "$CARGO_DIR/env"

# }}}

# {{{ Set system PATH

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

# Personal binaries
export PATH="$PATH:$HOME/.local/bin"

# Screen layout related binaries
export PATH="$PATH:$HOME/.screenlayout"

# Kitty
export PATH="$PATH:$KITTY_INSTALL"

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
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/go/bin"

# PNPM
export PATH="$PATH:$PNPM_HOME"

# Bun
export PATH="$PATH:$HOME/.bun"

# Java
export PATH="$PATH:/usr/local/opt/openjdk/bin"

# fnm
if command -v fnm >/dev/null; then
  export PATH="$HOME/Library/Application Support/fnm:$PATH"
  eval "`fnm env`"
fi

# fzf
export PATH="$PATH:$HOME/.fzf/bin"

# }}}

# {{{ Editor

if command -v nvim >/dev/null; then
  export EDITOR="$(which nvim)"
elif command -v vim >/dev/null; then
  export EDITOR="$(which vim)"
elif command -v vi >/dev/null; then
  export EDITOR="$(which vi)"
fi

# }}}

# vim: foldmethod=marker
