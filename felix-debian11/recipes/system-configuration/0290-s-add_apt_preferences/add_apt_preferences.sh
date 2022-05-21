#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

add_apt_preferences(){
	printf "Adding APT preferences ...\n"
	
	cd "${RECIPE_DIRECTORY}"
	cp stable.pref /etc/apt/preferences.d/
	cp testing.pref /etc/apt/preferences.d/
	cp 99defaultrelease /etc/apt/apt.conf.d/
	
	printf "You should have the source lists `stable.list` and `testing.list` in your `/etc/apt/sources.list.d`\n"
	
	printf "\n"
}

add_apt_preferences 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
