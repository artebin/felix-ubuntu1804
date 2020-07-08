#!/usr/bin/env bash

# df human readable
alias df="df -h"

# Add standard math library to bc
alias bc='bc -l'

public_ip(){
	curl ipinfo.io/ip
}
alias public_ip=public_ip

weather(){
	# wttr.in guesses the location from the request originator if no indicated location
	curl "wttr.in/${1}"
}
alias weather=weather

github-clone(){
	if [[ $# -eq 1 ]]; then
		git clone "${1}"
	elif [[ $# -eq 2 ]]; then
		git clone "https://github.com/${1}/${2}"
	else 
		printf "Usage: %s REPOSITORY_URL\n" "${FUNCNAME[0]}"
		printf "       %s USER_NAME REPOSITY_NAME\n" "${FUNCNAME[0]}"
		return
	fi
}
alias github-clone=github-clone

git-config-global-user-name-email(){
	NAME="${1}"
	EMAIL="${2}"
	if [[ -z "${NAME}" ]] | [[ -z "${EMAIL}" ]]; then
		printf "Usage: %s NAME EMAIL\n" "${FUNCNAME[0]}"
		return
	fi
	git config --global user.name "${NAME}"
	git config --global user.email "${EMAIL}"
}
alias git-config-global-user-name-email=git-config-global-user-name-email

dateInSeconds(){
	date +%s
}
alias dateInSeconds=dateInSeconds

dateInMillis(){
	date +%s%N | cut -b1-13
}
alias dateInMillis=dateInMillis

millis2date() {
	DATE_IN_MILLIS="${1}"
	if [[ -z "${DATE_IN_MILLIS}" ]]; then
		printf "Usage: %s DATE_IN_MILLIS\n" "${FUNCNAME[0]}"
		return
	fi
	DATE_IN_SECONDS=$(( "${DATE_IN_MILLIS}" / 1000 ))
	date -d @${DATE_IN_SECONDS}
}
alias millis2date=millis2date

date2seconds(){
	DATE_AS_STRING="${1}"
	if [[ -z "${DATE_AS_STRING}" ]]; then
		printf "Usage: %s DATE_AS_STRING\n" "${FUNCNAME[0]}"
		return
	fi
	date -d "${DATE_AS_STRING}" %s
}
alias date2seconds=date2seconds

dates2duration(){
	LEFT_DATE_AS_STRING="${1}"
	RIGHT_DATE_AS_STRING="${2}"
	if [[ -z "${LEFT_DATE_AS_STRING}" ]] | [[ -z "${RIGHT_DATE_AS_STRING}" ]]; then
		printf "Usage: %s LEFT_DATE_AS_STRING RIGHT_DATE_AS_STRING\n" "${FUNCNAME[0]}"
		return
	fi
	LEFT_DATE_IN_SECONDS=$(date -d "${LEFT_DATE_AS_STRING}" +%s)
	RIGHT_DATE_IN_SECONDS=$(date -d "${RIGHT_DATE_AS_STRING}" +%s)
	DIFF_IN_SECONDS=$(( ${RIGHT_DATE_IN_SECONDS} - ${LEFT_DATE_IN_SECONDS} ))
	DAY_COUNT=$(( ${DIFF_IN_SECONDS} / 86400 ))
	SECONDS_FROM_MIDNIGHT_COUNT=$(( ${DIFF_IN_SECONDS} % 86400  ))
	TIME_OF_DAY=$(date -u -d @"${DIFF_IN_SECONDS}" +"%T")
	printf "%sd %s\n" "${DAY_COUNT}" "${TIME_OF_DAY}"
}
alias dates2duration=dates2duration

backup_file(){
	BACKUP_MODE="${1}"
	FILE="${2}"
	if [[ "${BACKUP_MODE}" != "-r"  && "${BACKUP_MODE}" != "-c" ]]; then
		printf "Usage: %s [-r | -c] FILE\n" "${FUNCNAME[0]}"
		return
	fi
	if [[ -z "${FILE}" || ! -e "${FILE}" ]]; then
		printf "Usage: %s [-r | -c] FILE\n" "${FUNCNAME[0]}"
		return
	fi
	FILE_BACKUP="${FILE}.bak.$(date -u +'%y%m%d-%H%M%S')"
	case "${BACKUP_MODE}" in
		"-r")
			mv "${FILE}" "${FILE_BACKUP}"
			if [[ "$?" -ne 0 ]]; then
				printf "!ERROR! Cannot backup: %s\n" "${FILE}"
				return
			fi
			;;
		"-c")
			cp "${FILE}" "${FILE_BACKUP}"
			if [ "$?" -ne 0 ]; then
				printf "!ERROR! Cannot backup: %s\n" "${FILE}"
				return
			fi
			;;
	esac
}
alias backup_file=backup_file

# Sed command for removing ANSI/VT100 control sequences
# See <https://stackoverflow.com/questions/17998978/removing-colors-from-output>
remove_terminal_control_sequences(){
	sed -r "s/\x1B(\[[0-9;]*[JKmsu]|\(B)//g"
}
alias remove_terminal_control_sequences=remove_terminal_control_sequences

package_reinstall_and_revert_conf_files(){
	apt-get install --reinstall -o Dpkg::Options::="--force-confask,confnew,confmiss" "${@}"
}
alias package_reinstall_and_revert_conf_files=package_reinstall_and_revert_conf_files

screen_dimension(){
	xdpyinfo | grep -oP 'dimensions:\s+\K\S+'
}
alias screen_dimension=screen_dimension

show_connected_monitors(){
	xrandr | grep ' connected'
}
alias show_connected_monitors=show_connected_monitors

retrieve_geometry_of_primary_monitor(){
	xrandr | grep ' connected primary' | cut -d" " -f4
}
alias retrieve_geometry_of_primary_monitor=retrieve_geometry_of_primary_monitor

retrieve_distro_codename(){
	lsb_release --codename --short
}
alias retrieve_distro_codename=retrieve_distro_codename

ls_socket_for_pid(){
	PID="${1}"
	if [[ -z "${PID}" ]]; then
		printf "Usage: %s PID\n" "${FUNCNAME[0]}"
		return
	fi
	lsof -Pan -p ${PID} -i
}
alias ls_socket_for_pid=ls_socket_for_pid

desc_for_pid(){
	if [[ $# -eq 0 ]]; then
		printf "Usage: %s PID_LIST\n" "${FUNCNAME[0]}"
		return
	fi
	PS_ARGS=""
	for PID in $@; do
		PS_ARGS+="-p ${PID} "
	done
	echo "${PS_ARGS}"
	ps ${PS_ARGS} -o pid,vsz=MEMORY -o user,group=GROUP -o comm,args=ARGS
}
alias desc_for_pid=desc_for_pid

svn_mark_missing_as_deletions(){
	if [[ ! -z "$(svn st | grep ^! | awk '{print " --force "$2}')" ]]; then
		svn st | grep ^! | awk '{print " --force "$2}' | xargs svn rm
	fi
}
alias svn_mark_missing_as_deletions=svn_mark_missing_as_deletions

set_terminal_title() {
	if [[ -z "$ORIG" ]]; then
		ORIG=$PS1
	fi
	TITLE="\[\e]2;$*\a\]"
	PS1=${ORIG}${TITLE}
}
alias set_terminal_title=set_terminal_title
