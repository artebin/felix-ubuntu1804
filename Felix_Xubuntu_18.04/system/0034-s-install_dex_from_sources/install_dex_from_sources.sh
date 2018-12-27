#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

install_dex_from_sources(){
	echo "Installing dex from sources ..."
	
	# Install dependencies
	if ! is_package_installed; then
		apt-get install -y python3-sphinx
	fi
	
	# Clone git repository
	cd ${BASEDIR}
	git clone https://github.com/jceb/dex
	cd dex
	patch dex < ../terminal_property.patch
	make install
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr dex
	
	echo
}

cd ${BASEDIR}

install_dex_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
