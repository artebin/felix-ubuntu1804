#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

terminate_x_with_ctrl_alt_backspace(){
	echo "Allow terminate X server with <Ctrl><Alt>Backspace ..."
	
	cd "${BASEDIR}"
	cp 90-zap.conf /usr/share/X11/xorg.conf.d/90-zap.conf
	
	echo
}

terminate_x_with_ctrl_alt_backspace 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
