#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_additional_fonts(){
	cd ${BASEDIR}
	
	echo 'Installing additional fonts ...'
	cp *.ttf /usr/local/share/fonts/
	
	echo 'Updating font cache ...'
	fc-cache -f -v 1>/dev/null
}

cd ${BASEDIR}
install_additional_fonts 2>&1 | tee -a ./${SCRIPT_LOG_NAME}