#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_root_privileges

configure_geany(){
	printf "Configuring Geany ...\n"
	
	if [[ -d "${HOME}/.config/geany" ]]; then
		backup_file rename "${HOME}/.config/geany"
	fi
	mkdir -p "${HOME}/.config/geany"
	
	#Geany main configuration
	cp "${RECIPE_FAMILY_DIRECTORY}/dotfiles/.config/geany/geany.conf" "${HOME}/.config/geany"
	
	# Geany keybindings
	cp "${RECIPE_FAMILY_DIRECTORY}/dotfiles/.config/geany/keybindings.conf" "${HOME}/.config/geany"
	
	# Geany filedefs
	mkdir -p "${HOME}/.config/geany/filedefs"
	cp "${RECIPE_FAMILY_DIRECTORY}/dotfiles/.config/geany/filedefs/filetypes.common" "${HOME}/.config/geany/filedefs"
	
	# GitHub markdown CSS
	mkdir -p "${HOME}/.config/geany/plugins/markdown"
	cp "${RECIPE_FAMILY_DIRECTORY}/dotfiles/.config/geany/plugins/markdown/github-markdown.html" "${HOME}/.config/geany/plugins/markdown"
	
	printf "\n"
}

configure_geany 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi