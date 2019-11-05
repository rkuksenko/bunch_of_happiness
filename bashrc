# .bashrc

# Expand the history size 
export HISTFILESIZE=10000 
export HISTSIZE=5000

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
ulimit -c unlimited
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

getHardwareConcurrency() {
    cat /proc/cpuinfo | grep processor | wc -l
}

# colors
LIGHTGRAY="\033[0;37m"
WHITE="\033[1;37m"
BLACK="\033[0;30m"
DARKGRAY="\033[1;30m"
RED="\033[0;31m"
LIGHTRED="\033[1;31m"
GREEN="\033[0;32m"
LIGHTGREEN="\033[1;32m"
BROWN="\033[0;33m"
YELLOW="\033[1;33;34m"
BLUE="\033[0;34m"
LIGHTBLUE="\033[1;34m"
MAGENTA="\033[0;35m"
LIGHTMAGENTA="\033[1;35m"
CYAN="\033[0;36m"
LIGHTCYAN="\033[1;36m"
NOCOLOR="\033[0m"

# aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias touchall='touch *.*'
alias q='exit'
alias c='clear'
alias h='history'
alias cs='clear;ls'
alias p='cat'
alias pd='pwd'
alias lsa='ls -a'
alias lsl='ls -l'
alias pd='pwd'
alias t='time'
alias k='kill'
alias null='/dev/null'
alias home='cd ~'
alias root='cd /'
alias ..='cd ..;'
alias ...='cd ..; cd ..;'
alias ....='cd ..; cd ..; cd ..;'
alias .....='cd ..; cd ..; cd ..; cd ..;'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -iv'
alias mkdir='mkdir -p'
alias ping='ping -c 10'
alias bd='cd "$OLDPWD"'
alias lk='ls -lSrh' # sort by size
alias lc='ls -lcrh' # sort by change time
alias lu='ls -lurh' # sort by access time
alias p="ps aux | grep "

# Git
alias gl='git log'
alias gll='git log | head -20'
alias gs='git status'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git pull'
alias gpr='git pull --rebase'
alias gss='git stash save'
alias gsp='git stash pop'
alias gd='git diff'
alias ga='git add'

# Docker
alias di='docker images'
alias dil='docker images | head -8'
alias dps='docker ps'
alias dpsl='docker ps | head -8'
alias dirm='docker image rm'
alias dirmf='docker image rm -f'
alias drm='docker rm'
alias drmf='docker rm -f'
alias dk='docker kill'
alias dkf='docker kill -f'
alias dinsp='docker inspect'
alias dl='docker logs'
alias drun='f(){ docker run -ti $@; unset -f f; }; f'
alias dexec='f(){ docker exec -ti $1 bash; unset -f f; }; f'
alias drb='f(){ echo -e $@; docker run -ti $1 bash; unset -f f; }; f'
alias dcp='docker cp'

# System
alias fps='ps aux | grep'
alias kps='pkill -f -9'
alias amzssh='f(){ ssh -i /vagrant/.ssh/DevOp-All-Dev.pem ec2-user@$1; unset -f f; }; f'
#alias for_all='f(){ for i in $1; do cmd=$(echo $2 | sed 's/OBJ/$i/'); echo $cmd; $cmd ; done && echo -e ${GREEN}[Success] Last run cmd: \”cmd\”${NORMAL};  unset -f f; }; f'

# show git branch in the terminal prompt
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Copy file with a progress bar
cpp()
{
	set -e
	strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
	| awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}

function __setprompt
{
	PS1="\[${DARKGRAY}\]\t j\j \[${DARKGRAY}\]\[${LIGHTCYAN}\]\u\[${LIGHTGREEN}\]@\[${LIGHTMAGENTA}\]\h"
	
	# Current directory
	PS1+="\[${DARKGRAY}\]:\[${YELLOW}\]\w\[${DARKGRAY}\]\[$(parse_git_branch)\]\n"
	
	if [[ $EUID -ne 0 ]]; then
		PS1+="\[${GREEN}\]>\[${NOCOLOR}\] " # Normal user
	else
		PS1+="\[${RED}\]>\[${NOCOLOR}\] " # Root user
	fi

	# PS2 is used to continue a command using the \ character
	PS2="\[${DARKGRAY}\]>\[${NOCOLOR}\] "

	# PS3 is used to enter a number choice in a script
	PS3='Please enter a number from above list: '

	# PS4 is used for tracing a script in debug mode
	PS4='\[${DARKGRAY}\]+\[${NOCOLOR}\] '
}

PROMPT_COMMAND='__setprompt'
