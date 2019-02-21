#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

configure_apt_mirror(){
	echo "Configuring apt-mirror ..."
	cd "${RECIPE_DIR}"
	if [[ -f /etc/apt/mirror.list ]]; then
		backup_file rename /etc/apt/mirror.list
	fi
	cp apt.mirror.list /etc/apt/mirror.list
	
	echo "Adding the local mirror into the sources ..."
	cd "${RECIPE_DIR}"
	if [[ -f /etc/apt/sources.list.d/local_mirror.list ]]; then
		backup_file rename /etc/apt/sources.list.d/local_mirror.list
	fi
	cp apt.mirror.list /etc/apt/sources.list.d/local_mirror.list
	
	echo
}

cd "${RECIPE_DIR}"
configure_apt_mirror 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi