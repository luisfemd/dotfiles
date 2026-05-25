#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export PATH="$PATH:$HOME/.local/bin"

alias jenkins='/usr/lib/jvm/java-25-openjdk/bin/java -jar /opt/jenkins-cli/jenkins-cli.jar -s http://ci.pulpo.co:8080 -auth $(cat ~/.jenkins-token)'

# API completion for myapibash
[ -f "/home/luisfemd/Develop/Me/myapibash/lib/api_completion.sh" ] && source "/home/luisfemd/Develop/Me/myapibash/lib/api_completion.sh"

