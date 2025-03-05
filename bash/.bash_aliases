#!/usr/bin/env bash

# {{{ Tool aliases

# {{{ Git

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

# }}}

# {{{ MySQL

alias sql-local='mycli -hlocalhost -uroot'
alias sql-dump='mysqldump -hlocalhost -uroot'
alias sql-run='mysql -hlocalhost -uroot'

# }}}

# {{{ NPM

alias m='npm run'
alias mx="npx"
alias mi="npm i"
alias mci="npm ci"
alias mrm="npm rm"

# }}}

# {{{ Other tools

# MongoDB
alias mongosh="mongosh --quiet"

# Node
alias noder="node ~/.repl.cjs"

# PNPM
alias pm="pnpm"
alias pmc="pnpm -C"
alias pmi="pnpm install"

# TurboRepo
alias tb="turbo"

# Python
alias py="python3"
alias pip="python3 -m pip"

# Docker
alias dk="docker"
alias dkc="docker compose"

# `fzf` - fuzzy file finder
alias fzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'

# `dt` - a duct tape for the CLI
alias dtsh="rlwrap dt"

# MIT license
alias mit_license="curl https://api.github.com/licenses/mit -s | jq '.body' -r"

# }}}

# }}}

# {{{ Optional tools

# `thefuck` - correct mistakes in CLI
if command -v thefuck >/dev/null; then
  eval "$(thefuck --alias)"
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

# }}}

# {{{ Comfort remaps

# Copy and paste the results of a command
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

# Nicer `ls` commands
alias ll='ls -alH'
alias la='ls -a'
alias l='ls -F'

# Make file executable
alias xc="chmod +x"

# HTTP server in the current directory, using python
alias serve="python3 -m http.server"

# Resource bash configuration
alias rc="source ~/.bashrc"

# An "alert" alias for long running commands, used like:
# `sleep 10; alert`
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Enabling colors for dir, vdir, grep, fgrep, egrep
if [ -x /usr/bin/dircolors ]; then
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# }}}

# vim: foldmethod=marker
