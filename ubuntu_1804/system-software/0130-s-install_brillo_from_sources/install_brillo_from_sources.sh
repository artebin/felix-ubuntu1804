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

install_brillo_from_sources(){
	echo "Install brillo from sources ..."
	
	# See <https://www.reddit.com/r/archlinux/comments/9mr58u/my_brightness_control_tool_brillo_has_a_new/>.
	
	# Install dependencies
	install_package_if_not_installed "go-md2man"
	
	# Clone repository
	cd ${RECIPE_DIR}
	git clone https://gitlab.com/cameronnemo/brillo
	
	# Compile and install
	cd ${RECIPE_DIR}
	cd brillo
	make
	make install
	make dist
	make install-dist
	
	# Cleaning
	cd ${RECIPE_DIR}
	rm -fr brillo
	
	echo
}



cd ${RECIPE_DIR}
install_brillo_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
