#!/bin/bash

# Get the path of the current script
script_path="${BASH_SOURCE[0]}"

# Convert Windows-style line endings to Unix-style line endings
sed -i 's/\r$//' "$script_path"

# Get the current directory name using ${PWD##*/}
CURRENT_DIR="${PWD##*/}"

# Get the values for OS_USER and UID for the current user
OS_USER=$(whoami)
UID=$(id -u)

# Define an associative array to map variable names to their values
declare -A VAR_VALUES=(
  ["PROJECT_FOLDER_NAME"]=$CURRENT_DIR
  ["PROJECT_VOLUME"]="./$CURRENT_DIR:/opt/project"
  ["WORKING_DIR"]="/opt/project"
  ["OS_USER"]=$OS_USER
  ["UID"]=$UID
)

# Define the path to your .env file
ENV_FILE="$HOME/backend/.env"

# Check if the .env file exists
if [ -e "$ENV_FILE" ]; then
  # Loop through the associative array and replace variable values
  for VAR_NAME in "${!VAR_VALUES[@]}"; do
    VAR_VALUE="${VAR_VALUES[$VAR_NAME]}"
    sed -i "s^$VAR_NAME=.*^$VAR_NAME=$VAR_VALUE^" "$ENV_FILE"
    if [ $? -eq 0 ]; then
      echo "Variable $VAR_NAME in $ENV_FILE has been updated to $VAR_VALUE"
    else
      echo "Error: Failed to update variable $VAR_NAME in $ENV_FILE"
    fi
  done
else
  echo "Error: $ENV_FILE does not exist."
fi