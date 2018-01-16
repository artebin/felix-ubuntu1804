#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

process_package_install_list(){
	cd ${BASEDIR}
	
	echo 'Installing missing language support ...'
	xargs apt-get -y install < ./packages.install.list
}

cd ${BASEDIR}
process_package_install_list 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
