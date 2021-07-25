#!/bin/bash
# Wrapper script for phpcs installed with Drupal composer components.
##
SELF="`basename ${0}`"

PHPCS="vendor/bin/phpcs"
DRUPAL_CODER_PATH="vendor/drupal/coder/coder_sniffer"
CUSTOM_MODULES_PATH="web/modules/custom"
CUSTOM_THEMES_PATH="web/themes/custom"
CUSTOM_PROFILES_PATH="web/profiles/custom"

#
# Check environment.
#
if [ ! -f "${PHPCS}" ]; then
  echo "ERROR: phpcs component cannot be found."
  echo "You may need to run:"
  echo "  composer require drupal/coder"
  exit 1
fi
if [ ! -d "${DRUPAL_CODER_PATH}" ]; then
  echo "ERROR: Coder Sniffer cannot be found."
  exit 1
fi

#
# Print usage.
#
usage() {
  echo ""
  echo "Usage: ${SELF} [option]"
  echo "where [option] may be:"
  echo "   check-rules     Checks installed rules."
  echo "   install-rules   Installs Drupal rules."
  echo "   check-modules   Checks coding standards of all custom modules."
  echo "   check-themes    Checks coding standards of all custom themes."
  echo "   check-profiles  Checks coding standards of all custom profiles."
  echo "   check-local     Checks coding standards of all custom modules and themes."
  echo "   check-all       Checks coding standards of all custom modules, themes and profiles."
  echo ""
}

#
# Execute command.
#
exec_cmd() {
  echo "${@}"
  ${@}
}

#
# Main processing.
#
if [ "${1}" == "check-rules" ]; then
  exec_cmd ${PHPCS} -i
elif [ "${1}" == "install-rules" ]; then
  exec_cmd ${PHPCS} --config-set installed_paths "${DRUPAL_CODER_PATH}"
elif [[ "${1}" =~ ^check\-(all|local|modules|themes|profiles)$ ]]; then
  if [[ "${1}" =~ ^check\-(all|local|modules)$ ]]; then
    for FILE in `find "${CUSTOM_MODULES_PATH}" -mindepth 1 -maxdepth 1 -type d | sort`; do
      echo "Checking module ${FILE}..."
      ${PHPCS} --standard=Drupal --extensions=php,module,inc,install,test,profile,theme,css,info,txt,md --ignore=node_modules "${FILE}"
    done
  fi
  if [[ "${1}" =~ ^check\-(all|local|themes)$ ]]; then
    for FILE in `find "${CUSTOM_THEMES_PATH}" -mindepth 1 -maxdepth 1 -type d | sort`; do
      echo "Checking theme ${FILE}..."
      ${PHPCS} --standard=Drupal --extensions=php,module,inc,install,test,profile,theme,info,txt,md --ignore=node_modules,bootstrap "${FILE}"
    done
  fi
  if [[ "${1}" =~ ^check\-(all|local|profiles)$ ]]; then
    for FILE in `find "${CUSTOM_PROFILES_PATH}" -mindepth 1 -maxdepth 1 -type d | sort`; do
      echo "Checking profile ${FILE}..."
      ${PHPCS} --standard=Drupal --extensions=php,module,inc,install,test,profile,theme,info,txt,md --ignore=node_modules,bootstrap "${FILE}"
    done
  fi
  echo "Done!"
elif [ "${1}" == "" ]; then
  usage
else
  echo "ERROR: invalid arguments: ${@}"
  usage
  exit 1
fi

exit 0
