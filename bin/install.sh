#!/bin/bash

echo ""

# Run in Linux only AND
# Run inside vagrant only
if [ "$(uname)" == "Darwin" ]; then
  echo "You cannot run this in an OSX host OS."
  echo "Please execute this command inside your vagrant box i.e., linux."
  exit
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  # Run inside vagrant only
  user_is_present=false
  getent passwd vagrant >/dev/null 2>&1 && user_is_present=true
  if $user_is_present; then
    echo "Executing install.sh..."
  else
    echo "Please run install.sh inside your vagrant."
    echo "Installation aborted."
    exit 1
  fi
  echo ""
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
  echo "You cannot run this in a Windows host OS."
  echo "Please execute this command inside your vagrant box i.e., linux."
  exit
fi

# Install whiptail TUI
if ! type "whiptail" &> /dev/null; then
  sudo apt-get install whiptail -y
fi

# Include functions
for f in includes/*.sh; do
  source $f
done

# Parse config yaml files
eval $(parse_yaml config/dialog.yml)
eval $(parse_yaml config/default.yml)
eval $(parse_yaml config/acquia.yml)
eval $(parse_yaml config/pantheon.yml)
if [ $display_config_vars = 1 ]; then
  parse_yaml config/dialog.yml
  parse_yaml config/default.yml
  parse_yaml config/acquia.yml
  parse_yaml config/pantheon.yml
  exit
fi

# Make temp file
temp_file=$(mktemp)

# Make sure the minimum vars needed are met
if [ -z "$install_profile" ]; then echo "install_profile is undefined."; fi
if [ -z "$install_mail" ]; then echo "install_mail is undefined."; fi
exit
  [ -z "$install_name" ] ||
  [ -z "$install_pass" ] ||
  [ -z "$install_db_name" ] ||
  [ -z "$install_db_host" ] ||
  [ -z "$install_db_su" ] ||
  [ -z "$install_db_su_pw" ] ||
  [ -z "$install_mail" ] ||
  [ -z "$install_name" ] ||
  [ -z "$install_subdir" ] ||
  [ -z "$install_theme" ]
  echo "The following may be undefined: install_profile, install_mail, install_name, install_pass, install_db_name, install_db_host, install_db_su, install_db_su_pw, install_mail, install_name, install_subdir, install_theme"
  echo "Please check and set them in config/default.yml file."
  exit
exit

# Dialog to select install
whiptail --title "$dialog_title" --menu "\nChoose your installation..." 13 50 3 \
  "acquia"    " - Acquia" \
  "pantheon"  " - Pantheon" \
  "custom"    " - Non-aquia and non-pantheon" 2>$temp_file
exit_status=$?
echo ""
if [ $exit_status = 0 ]; then
  install_server=$(cat $temp_file)
  rm $temp_file
else
  echo "Installation has been aborted."
  exit
fi

exit
# If Acquia
if [ $install = "acquia" ]; then
  # Check if minimum variables for acquia install are met
  if [ -z "$acquia_drush_alias_remote" ] || [ -z "$acquia_drush_alias_local" ] || [ -z "$install_project_name" ]; then 
    echo "They are set"
  fi
fi


