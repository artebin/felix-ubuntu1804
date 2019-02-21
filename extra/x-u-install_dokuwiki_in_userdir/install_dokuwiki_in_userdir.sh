#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash

DOKUWIKI_STABLE="dokuwiki-2017-02-19e"
USERNAME=$(whoami)

install_dokuwiki_in_userdir(){
	cd ${BASEDIR}
	
	echo "Installing DokuWiki in userdir ..."
	
	sudo adduser www-data ${USERNAME}
	
	cd ${BASEDIR}
	mkdir -p ~/public_html
	cp ./dokuwiki-stable.tgz ~/public_html/dokuwiki-stable.tgz
	cd ~/public_html
	tar xzf dokuwiki-stable.tgz
	
	cd ${BASEDIR}
	cp ./dokubook-stable.tgz ~/public_html/${DOKUWIKI_STABLE}/lib/tpl/dokubook-stable.tgz
	cp ./conf/mime.local.conf ~/public_html/${DOKUWIKI_STABLE}/conf/mime.local.conf
	cp ./conf/entities.conf ~/public_html/${DOKUWIKI_STABLE}/conf/entities.conf
	cp ./conf/userstyle.css ~/public_html/${DOKUWIKI_STABLE}/conf/userstyle.css
	cp ./conf/userscript.js ~/public_html/${DOKUWIKI_STABLE}/conf/userscript.js
	cd ~/public_html/${DOKUWIKI_STABLE}/lib/tpl/
	tar xzf ./dokubook-stable.tgz
	chmod -R g+r ~/public_html
	chmod -R g+w ~/public_html/${DOKUWIKI_STABLE}/data
	find ~/public_html -type d | xargs chmod g+x
	sudo service apache2 restart
	
	echo
}

cd ${BASEDIR}

install_dokuwiki_in_userdir 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi

x-www-browser http://localhost/~${USERNAME}/${DOKUWIKI_STABLE}/install.php &
