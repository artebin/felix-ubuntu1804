#!/usr/bin/env bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

configure_alternatives(){
	cd ${BASEDIR}
	
	# NJ: 18-04-29: termite should have been set as x-terminal-emulator during its installation
	#echo "Setting mate-terminal as x-terminal-emulator ..."
	#update-alternatives --set x-terminal-emulator /usr/bin/mate-terminal.wrapper
	
	echo "Setting firefox as x-www-browser ..."
	update-alternatives --set x-www-browser /usr/bin/firefox
}

cd ${BASEDIR}
configure_alternatives 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
