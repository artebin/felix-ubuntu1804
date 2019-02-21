#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

configure_ssh_welcome_text(){
	echo "Setting SSH welcome text ..."
	
	echo "Disabling all previous 'message of the day' ..."
	cd /etc/update-motd.d
	for FILE in ./*; do
		backup_file rename ./"${FILE}"
	done
	chmod a-x ./*
	
	echo "Adding Tux Welcome Dude ..."
	cd "${BASEDIR}"
	cp 00-welcome-dude /etc/update-motd.d/00-welcome-dude
	chmod 744 /etc/update-motd.d/00-welcome-dude
	cp tux /etc/update-motd.d/tux
	chmod 644 /etc/update-motd.d/tux
	
	echo
}

configure_ssh_welcome_text 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
