#!/bin/bash

source ../../common.sh
check_shell
get_root_privileges

configure_lightdm_greeter(){
	cd ${BASEDIR}
	
	echo "Configuring LightDM greeter ..."
	renameFileForBackup /etc/lightdm/lightdm-gtk-greeter.conf
	cp ./lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
}

cd ${BASEDIR}
configure_lightdm_greeter 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
