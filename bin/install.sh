#!/bin/bash

echo ""

# Run in Linux only
if [ "$(uname)" == "Darwin" ]; then
  echo "You cannot run this in an OSX host OS."
  echo "Please execute this command inside your vagrant box i.e., linux."
  exit
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  echo "Executing install.sh..."
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
