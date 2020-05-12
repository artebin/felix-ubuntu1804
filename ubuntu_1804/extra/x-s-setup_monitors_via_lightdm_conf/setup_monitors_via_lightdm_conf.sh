#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

exit_if_not_bash
exit_if_has_not_root_privileges

setup_monitors_via_lightdm_conf(){
	echo "Setup monitors setup via lightdm configuration ..."
	
	if [[ -f /etc/lightdm/lightdm.conf.d/10-monitors_setup.sh ]]; then
		echo "lightdm configuration file /etc/lightdm/lightdm.conf.d/10-monitors_setup.sh already exists!"
		exit 1
	fi
	
	cd "${RECIPE_DIR}"
	cp 10-monitors_setup.sh /etc/lightdm/lightdm.conf.d
	
	echo
}

setup_monitors_via_lightdm_conf 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
