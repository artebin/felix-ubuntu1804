#!/usr/bin/env bash

declare -g RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
declare -g FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

exit_if_not_bash
exit_if_has_not_root_privileges

disable_automatic_update_and_upgrade(){
	echo "Disable apt-daily.service ..."
	
	# See <https://askubuntu.com/questions/1057458/how-to-remove-ubuntus-automatic-internet-connection-needs/1057463#1057463>
	
	systemctl stop apt-daily.timer
	systemctl disable apt-daily.timer
	systemctl disable apt-daily.service
	systemctl stop apt-daily-upgrade.timer
	systemctl disable apt-daily-upgrade.timer
	systemctl disable apt-daily-upgrade.service
	
	echo
	
	echo "Remove unattended-upgrades ..."
	remove_with_purge_package_if_installed "unattended-upgrades"
	
	echo
}

disable_automatic_update_and_upgrade 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
