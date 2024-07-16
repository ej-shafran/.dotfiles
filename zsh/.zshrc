#!/usr/bin/env zsh

sourceif() {
  [[ -f "$1" ]] && source "$1" || return 0
}

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

# {{{ Miscellaneous settings

# Make `less` more friendly for non-text input
# See |lesspipe(1)|
if [[ -x /usr/bin/lesspipe ]]; then
  eval "$(SHELL=/bin/sh lesspipe)"
fi

# Load completion
autoload -Uz compinit && compinit

# }}}

# {{{ Shell prompt

if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
fi

# }}}

# {{{ Load aliases and utils

sourceif "$HOME/.zsh_aliases"
sourceif "$HOME/.zsh_aliases.local"

sourceif "$HOME/.zsh_utils"
sourceif "$HOME/.zsh_utils.local"

# }}}

# vim: foldmethod=marker
