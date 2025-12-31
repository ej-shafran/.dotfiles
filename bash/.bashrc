#!/usr/bin/env bash

# shellcheck disable=SC1091

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Check if a file exists, and source it if it does.
# This way, we can enable certain tools only if they actually exist.
sourceif() {
  if [ -f "$1" ]; then
    # shellcheck disable=SC1090
    . "$1"
  fi
}

# {{{ Tool locations

export PNPM_HOME="$HOME/.local/share/pnpm"
export GHCUP_DIR="$HOME/.ghcup"
export CARGO_DIR="$HOME/.cargo"
export NVM_DIR="$HOME/.nvm"
export BOB_DIR="$HOME/.local/share/bob"
# You can add/override environment variables for tools
# that you don't want to push to git in "$HOME/.bash_tools.local"
sourceif "$HOME/.bash_tools.local"

# }}}

# {{{ Set system path

# Prefixing - high priority
# Brew
if command -v brew >/dev/null; then
	PATH="$(brew --prefix)/bin:$PATH"
fi
# Nix
PATH="/nix/var/nix/profiles/default/bin:$PATH"
# Local binaries
PATH="$HOME/.screenlayout:$PATH"
PATH="$HOME/.local/bin:$PATH"

# Suffixing - lower priority
# Node modules
PATH="$PATH:$HOME/node_modules/.bin"
# Tools
PATH="$PATH:$PNPM_HOME"
PATH="$PATH:$BOB_DIR/nvim-bin"
PATH="$PATH:$CARGO_DIR"
# Snap
PATH="$PATH:/snap/bin"
# Games
PATH="$PATH:/usr/games"
PATH="$PATH:/usr/local/games"
# Global binaries
PATH="$PATH:/bin"
PATH="$PATH:/sbin"
PATH="$PATH:/usr/bin"
PATH="$PATH:/usr/sbin"
PATH="$PATH:/usr/local/bin"
PATH="$PATH:/usr/local/sbin"
# Google Cloud CLI
sourceif "$HOME/google-cloud-sdk/path.bash.inc"
sourceif "$HOME/google-cloud-sdk/completion.bash.inc"

# Remove duplicates
PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++{if (NR > 1) printf ORS; printf $a[$1]}')
export PATH

#  }}}

# {{{ Shell settings

# Don't put duplicate lines or lines starting with space into history
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
# Append to the history file instead of overwriting it
shopt -s histappend
# Update the values of LINES and COLUMNS
shopt -s checkwinsize
# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if command -v brew >/dev/null && [ -f "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
    source "$(brew --prefix)/etc/profile.d/bash_completion.sh" 
    command -v xcode-select >/dev/null && sourceif "$(xcode-select -p)/usr/share/git-core/git-completion.bash"
  elif [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /usr/local/etc/profile.d/bash_completion.sh ]; then
    source /usr/local/etc/profile.d/bash_completion.sh
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# }}}

# {{{ Environment variables

export EDITOR=nvim
export MANPAGER='nvim +Man!'
export MYSQL_PS1='[\u@\h] \d> '
sourceif "$NVM_DIR/nvm.sh"
sourceif "$NVM_DIR/bash_completion"
export FZF_CTRL_T_COMMAND=""
sourceif "$HOME/.fzf.bash"
sourceif "$HOME/.local/bin/fzf-git.sh"
sourceif "$GHCUP_DIR/env"
sourceif "$CARGO_DIR/env"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
if command -v starship >/dev/null; then
  eval "$(starship init bash)"
fi

# }}}

# {{{ Aliases

# Git
alias gst="git status --short"
alias gstt="git status"
alias gup="git push"
alias gpl="git remote prune origin && git pull"
alias gsync="git fetch --prune --all && git bclean"
alias gdf="git diff"
alias gad="git add"
alias gap="git add -p"
alias gau="git add -u"
alias gan='git add "$(git ls-files -o --exclude-standard)"'
alias gaa="git add -A"
alias gcm="git commit"
alias glo="git log --oneline"
alias glog="git log"
alias gun="git restore --staged"
alias gxp="git explode"
alias gco="git checkout"
alias gac="git commit -a"
alias gbr="git branch"
alias gsm="git submodule"
alias gcz="git cz"
alias gcv="git convencm"
alias ghlp="git help"
alias gwt="git worktree"
alias gbs="git bisect start"
alias gbsr="git bisect reset"
alias gbg="git bisect good"
alias gbb="git bisect bad"
alias gft="git fetch --prune --all"
alias grb="git rebase"
alias grbi="git rebase -i -r"
alias gmr="git merge"
alias glast="git commit --amend -C@"
alias gsw="git switch"
alias grs="git restore"
# PNPM
alias pm="pnpm"
alias pmc="pnpm -C"
alias pmi="pnpm install"
# Turbo
alias tb="turbo"
# Python
alias py="python3"
alias pip="python3 -m pip"
# Docker
alias dk="docker"
alias dkc="docker compose"
# Fzf
alias fzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
# MIT License
alias mit_license="curl https://api.github.com/licenses/mit -s | jq '.body' -r"
# `pay-respects` - correct mistakes in CLI
if command -v pay-respects >/dev/null; then
  eval "$(pay-respects bash --alias fuck)"
fi
# `zoxide` - a better `cd`
if command -v zoxide >/dev/null; then
  eval "$(zoxide init bash --cmd cd)"
fi
# `bat` - a better `cat`
if command -v bat >/dev/null; then
  alias cat="bat"
fi
# `eza` - a better `ls`
if command -v eza >/dev/null; then
  alias ls="eza"
fi
# pbcopy + pbpaste for linux
if command -v xsel >/dev/null; then
  command -v pbcopy >/dev/null || alias pbcopy='xsel --clipboard --input'
  command -v pbpaste >/dev/null || alias pbpaste='xsel --clipboard --output'
fi
# ls
alias ll='ls -alH'
alias la='ls -a'
alias l='ls -F'
# Allow colors
if [ -x /usr/bin/dircolors ]; then
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
# An "alert" alias for long running commands, used like:
# `sleep 10; alert`
if command -v notify-send >/dev/null; then
	alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
else
	# shellcheck disable=SC2154
	alias alert='title="$([ $? = 0 ] && echo terminal || echo error)"; osascript -e "display notification \"$(history|tail -n1|sed -r -e '\''s/^[ \t]*[0-9]+[ \t]*//;s/[ \t]*[;&|][ \t]*alert$//;'\'')\" with title \"$title\""'
fi
# Resource config
alias rc="source ~/.bashrc"

# }}}

# {{{ Utils

# Make a directory, then `cd` into it.
mkcd() {
  mkdir "$1"
  cd "$1" || exit
}

# Download something from GitHub.
githubraw() {
  local repo="$1"
  local path="$2"

  curl -SLO "https://github.com/${repo}/raw/main/${path}"
}

# }}}

# vim: foldmethod=marker
