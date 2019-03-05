#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
RECIPE_FAMILY_DIR=$(retrieve_recipe_family_dir "${RECIPE_DIR}")
RECIPE_FAMILY_CONF_FILE=$(retrieve_recipe_family_conf_file "${RECIPE_DIR}")
if [[ ! -f "${RECIPE_FAMILY_CONF_FILE}" ]]; then
	printf "Cannot find RECIPE_FAMILY_CONF_FILE: ${RECIPE_FAMILY_CONF_FILE}\n"
	exit 1
fi
source "${RECIPE_FAMILY_CONF_FILE}"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_root_privileges
exit_if_no_x_session

configure_firefox_default_profile(){
	cd ${RECIPE_DIR}
	
	echo "Configuring Firefox ..."
	
	# Retrieve path to the Firefox default profile
	PREFS_JS_PATH=""
	if [[ -d ~/.mozilla/firefox ]]; then
		FIREFOX_DEFAULT_PROFILE_PATH=$(find ~/.mozilla/firefox -maxdepth 1 -iname "*\.default")
		if [[ -f "${FIREFOX_DEFAULT_PROFILE_PATH}/prefs.js" ]]; then
			PREFS_JS_PATH="${FIREFOX_DEFAULT_PROFILE_PATH}/prefs.js"
		fi
	fi
	
	if [[ ! -f "${PREFS_JS_PATH}" ]]; then
		echo "Can not find Firefox default profile => creating one ..."
		firefox -CreateProfile "default"
		
		FIREFOX_DEFAULT_PROFILE_PATH=$(find ~/.mozilla/firefox -maxdepth 1 -iname "*\.default")
		if [[ -f "${FIREFOX_DEFAULT_PROFILE_PATH}/prefs.js" ]]; then
			PREFS_JS_PATH="${FIREFOX_DEFAULT_PROFILE_PATH}/prefs.js"
		fi
	
		if [[ ! -f "${PREFS_JS_PATH}" ]]; then
			echo "Can not find Firefox default profile"
			exit 1
		fi
	fi
	
	echo "Configuring Firefox default profile ${PREFS_JS_PATH} ..."
	
	echo "Setting \"Show your windows and tabs from last time\" ..."
	KEY="browser.startup.page"
	PREFIX_TO_SEARCH="user_pref(\"${KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${KEY}\", 3);"
	if grep -q "${KEY}" "${PREFS_JS_PATH}"; then
		sed -i "/^${PREFIX_TO_SEARCH}/s/.*/${LINE_REPLACEMENT_VALUE}/" "${PREFS_JS_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${PREFS_JS_PATH}"
	fi
	
	echo "Setting \"Always ask you where to save files\" ..."
	KEY="browser.download.useDownloadDir"
	PREFIX_TO_SEARCH="user_pref(\"${KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${KEY}\", false);"
	if grep -q "${KEY}" "${PREFS_JS_PATH}"; then
		sed -i "/^${PREFIX_TO_SEARCH}/s/.*/${LINE_REPLACEMENT_VALUE}/" "${PREFS_JS_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${PREFS_JS_PATH}"
	fi
	
	echo "Setting \"Do not remember logins and passwords\" ..."
	KEY="signon.rememberSignons"
	PREFIX_TO_SEARCH="user_pref(\"${KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${KEY}\", false);"
	if grep -q "${KEY}" "${PREFS_JS_PATH}"; then
		sed -i "/^${PREFIX_TO_SEARCH}/s/.*/${LINE_REPLACEMENT_VALUE}/" "${PREFS_JS_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${PREFS_JS_PATH}"
	fi
	
	echo "Setting \"Do not trim URLs in the URL bar\" ..."
	KEY="browser.urlbar.trimURLs"
	PREFIX_TO_SEARCH="user_pref(\"${KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${KEY}\", false);"
	if grep -q "${KEY}" "${PREFS_JS_PATH}"; then
		sed -i "/^${PREFIX_TO_SEARCH}/s/.*/${LINE_REPLACEMENT_VALUE}/" "${PREFS_JS_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${PREFS_JS_PATH}"
	fi
	
	echo "Setting \"Do not show search engines in drop panel of the URL bar\" ..."
	KEY="browser.urlbar.oneOffSearches"
	PREFIX_TO_SEARCH="user_pref(\"${KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${KEY}\", false);"
	if grep -q "${KEY}" "${PREFS_JS_PATH}"; then
		sed -i "/^${PREFIX_TO_SEARCH}/s/.*/${LINE_REPLACEMENT_VALUE}/" "${PREFS_JS_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${PREFS_JS_PATH}"
	fi
	
	echo "Setting \"No search suggestions in the URL bar\" ..."
	# Part 1
	KEY="browser.urlbar.searchSuggestionsChoice"
	PREFIX_TO_SEARCH="user_pref(\"${KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${KEY}\", false);"
	if grep -q "${KEY}" "${PREFS_JS_PATH}"; then
		sed -i "/^${PREFIX_TO_SEARCH}/s/.*/${LINE_REPLACEMENT_VALUE}/" "${PREFS_JS_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${PREFS_JS_PATH}"
	fi
	# Part 2
	KEY="browser.urlbar.suggest.searches"
	PREFIX_TO_SEARCH="user_pref(\"${KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${KEY}\", false);"
	if grep -q "${KEY}" "${PREFS_JS_PATH}"; then
		sed -i "/^${PREFIX_TO_SEARCH}/s/.*/${LINE_REPLACEMENT_VALUE}/" "${PREFS_JS_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${PREFS_JS_PATH}"
	fi
	# Part 3
	KEY="browser.urlbar.timesBeforeHidingSuggestionsHint"
	PREFIX_TO_SEARCH="user_pref(\"${KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${KEY}\", 0);"
	if grep -q "${KEY}" "${PREFS_JS_PATH}"; then
		sed -i "/^${PREFIX_TO_SEARCH}/s/.*/${LINE_REPLACEMENT_VALUE}/" "${PREFS_JS_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${PREFS_JS_PATH}"
	fi
	
	echo
}

configure_firefox_default_profile 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
