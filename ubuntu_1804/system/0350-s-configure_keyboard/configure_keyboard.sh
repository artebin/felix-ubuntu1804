#!/usr/bin/env bash

source ../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

configure_keyboard(){
	cd ${BASEDIR}
	
	echo "Configuring keyboard ..."
	
	if [ ! -f /etc/default/keyboard ]; then
		echo "Can not find /etc/default/keyboard"
		exit 1
	fi
	
	backup_file copy /etc/default/keyboard
	
	echo "XKBMODEL=\"${XKBMODEL}\""
	add_or_update_line_based_on_prefix "XKBMODEL=" "XKBMODEL=\"${XKBMODEL}\"" /etc/default/keyboard
	
	echo "XKBLAYOUT=\"${XKBLAYOUT}\""
	add_or_update_line_based_on_prefix "XKBLAYOUT=" "XKBLAYOUT=\"${XKBLAYOUT}\"" /etc/default/keyboard
	
	echo "XKBVARIANT=\"${XKBVARIANT}\""
	add_or_update_line_based_on_prefix "XKBVARIANT=" "XKBVARIANT=\"${XKBVARIANT}\"" /etc/default/keyboard
	
	echo "XKBOPTIONS=\"${XKBOPTIONS}\""
	add_or_update_line_based_on_prefix "XKBOPTIONS=" "XKBOPTIONS=\"${XKBOPTIONS}\"" /etc/default/keyboard
	
	echo
}

cd ${BASEDIR}

configure_keyboard 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi