# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# NJ:16-08-18: use \w for complete path and \W for current path 
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \W\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -lF'
alias la='ls -A'
alias lla='ls -lFA'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Add standard math library to bc
alias bc='bc -l'

weather(){
	curl "wttr.in/${1}"
}
alias weather=weather

github-clone(){
	if [[ $# -eq 1 ]]; then
		git clone "${1}"
	elif [[ $# -eq 2 ]]; then
		git clone "https://github.com/${1}/${2}"
	else 
		printf "usage: github-clone [repository URL]\n"
		printf "       github-clone [user name] [project name]\n"
	fi
}
alias github-clone=github-clone

git-config-global-user-name-email(){
	git config --global user.name "${1}"
	git config --global user.email "${2}"
}
alias git-config-global-user-name-email=git-config-global-user-name-email

datetime2seconds(){
	date -d "${1}" %s
}
alias datetime2seconds=datetime2seconds

dates_diff(){
	LEFT_DATE_IN_SECONDS=$(date -d "${1}" +%s)
	RIGHT_DATE_IN_SECONDS=$(date -d "${2}" +%s)
	DIFF_IN_SECONDS=$(( ${RIGHT_DATE_IN_SECONDS} - ${LEFT_DATE_IN_SECONDS} ))
	DAY_COUNT=$(( ${DIFF_IN_SECONDS} / 86400 ))
	SECONDS_FROM_MIDNIGHT_COUNT=$(( ${DIFF_IN_SECONDS} % 86400  ))
	TIME_OF_DAY=$(date -u -d @"${DIFF_IN_SECONDS}" +"%T")
	echo "${DAY_COUNT}d ${TIME_OF_DAY}"
}
alias dates_diff=dates_diff

backup_file(){
	if [ "$#" -ne 2 ]; then
		echo "Usage: backup_file mode path"
		echo "  arguments:"
		echo "    mode\t\t'rename' or 'copy'"
		exit 1
	fi
	MODE="${1}"
	FILE_TO_BACKUP="${2}"
	if [ ! -e "${FILE_TO_BACKUP}" ]; then
		echo "Can not find ${FILE_TO_BACKUP}"
		exit 1
	fi
	FILE_BACKUP="${FILE_TO_BACKUP}.bak.$(date -u +'%y%m%d-%H%M%S')"
	case "${MODE}" in
		"rename")
			mv "${FILE_TO_BACKUP}" "${FILE_BACKUP}"
			if [ "$?" -ne 0 ]; then
				echo "Can not backup: ${FILE_TO_BACKUP}"
				exit 1
			fi
			;;
		"copy")
			cp "${FILE_TO_BACKUP}" "${FILE_BACKUP}"
			if [ "$?" -ne 0 ]; then
				echo "Can not backup: ${FILE_TO_BACKUP}"
				exit 1
			fi
			;;
		*)
			echo "Unkown mode \"${MODE}\""
			exit 1
	esac
}
alias backup_file=backup_file

# Sed command for removing ANSI/VT100 control sequences
# See <https://stackoverflow.com/questions/17998978/removing-colors-from-output>
remove_terminal_control_sequences(){
	sed -r "s/\x1B(\[[0-9;]*[JKmsu]|\(B)//g"
}
alias remove_terminal_control_sequences=remove_terminal_control_sequences

millisToDate() {
	date -d @$(echo "${1}/1000"|bc)
}
