#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export PATH="$PATH:$HOME/.local/bin"

# API completion for myapibash
[ -f "/home/luisfemd/Develop/Me/myapibash/lib/api_completion.sh" ] && source "/home/luisfemd/Develop/Me/myapibash/lib/api_completion.sh"
