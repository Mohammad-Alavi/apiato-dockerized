# #!/bin/bash

# Enable debugging and print all commands for the current shell
# set -x

# Get the path of the current script
SCRIPT_PATH=${BASH_SOURCE[0]}

# Initialize SED_FLAG as an array
SED_FLAG=(-i)
# Check for macOS and adjust the sed command flag accordingly
if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_FLAG=(-i '')
fi

# Use the SED_FLAG array with proper quoting in the sed command
# Convert Windows-style line endings to Unix-style line endings
sed "${SED_FLAG[@]}" 's/\r$//' "$SCRIPT_PATH"

# Get the current directory name using ${pwd##*/}
CURRENT_DIR_NAME=${PWD##*/}
# Get the current directory path using $(pwd)
CURRENT_DIR_PATH=$(pwd)

# Get the values for OS_USER and UID for the current user
OS_USER=$(whoami)
OS_UID=$(id -u)

# Define the path to your .env file
DOCKER_ENV_FILE="${CURRENT_DIR_PATH}/.env.docker"
PARENT_DIR_PATH=$(dirname "$CURRENT_DIR_PATH")
# Define the path to the .env file in the parent directory
ENV_FILE="${PARENT_DIR_PATH}/.env"

# Create the .env file if it does not exist
if [ ! -e "$DOCKER_ENV_FILE" ]; then
  touch "$DOCKER_ENV_FILE"
  if [ $? -eq 0 ]; then
    echo "Created $DOCKER_ENV_FILE"
  else
    echo "Error: Failed to create $DOCKER_ENV_FILE"
  fi
fi

# Define an associative array to map variable names to their values
declare -A DYNAMIC_ENV_VARS=(
  ["COMPOSE_PROJECT_NAME"]=$CURRENT_DIR_NAME
  ["PROJECT_FOLDER_NAME"]=$CURRENT_DIR_NAME
  ["PROJECT_VOLUME"]="./$CURRENT_DIR_NAME:/opt/project"
  ["WORKING_DIR"]="/opt/project"
  ["OS_USER"]=$OS_USER
  ["UID"]=$OS_UID
)
DEFAULT_PHP_SERVICE="php81"
# Check if the PHP_SERVICE variable is set in the .docker.env file
if grep -q "^PHP_SERVICE=" "$DOCKER_ENV_FILE"; then
  # If its value is empty, it will be set to php and we tell the user
  PHP_SERVICE=$(grep "^PHP_SERVICE=" "$DOCKER_ENV_FILE" | cut -d '=' -f2)
  if [ -z "$PHP_SERVICE" ]; then
    echo "PHP_SERVICE is empty in $DOCKER_ENV_FILE, setting it to $DEFAULT_PHP_SERVICE"
    DYNAMIC_ENV_VARS["PHP_SERVICE"]=$DEFAULT_PHP_SERVICE
  else
  echo "PHP_SERVICE is set in $DOCKER_ENV_FILE, setting it to $PHP_SERVICE"
    DYNAMIC_ENV_VARS["PHP_SERVICE"]=$PHP_SERVICE
  fi
else
  echo "PHP_SERVICE is not set in $DOCKER_ENV_FILE, setting it to $DEFAULT_PHP_SERVICE"
  DYNAMIC_ENV_VARS["PHP_SERVICE"]=$DEFAULT_PHP_SERVICE
fi

# Check if the .env file is readable and writable
if [ ! -r "$DOCKER_ENV_FILE" ] || [ ! -w "$DOCKER_ENV_FILE" ]; then
  # Make sure the .env file is writable
  echo "Setting permissions for $DOCKER_ENV_FILE"
  sudo chmod 777 "$DOCKER_ENV_FILE"
  sudo chown "$OS_USER:$OS_USER" "$DOCKER_ENV_FILE"
fi

# Check if the .env file exists
if [ -e "$DOCKER_ENV_FILE" ]; then
  # Loop through the associative array and replace variable values
  for VAR_NAME in "${!DYNAMIC_ENV_VARS[@]}"; do
    VAR_VALUE="${DYNAMIC_ENV_VARS[$VAR_NAME]}"
    OLD_VALUE=$(grep "^$VAR_NAME=" "$DOCKER_ENV_FILE" | cut -d '=' -f2)
    # Replace the value if the key exists
    sed "${SED_FLAG[@]}" "s^$VAR_NAME=.*^$VAR_NAME=$VAR_VALUE^" "$DOCKER_ENV_FILE"
    sed "${SED_FLAG[@]}" "s^$VAR_NAME=.*^$VAR_NAME=$VAR_VALUE^" "$ENV_FILE"

    # Add the key if it does not exist in the .env.docker file
    if ! grep -q "^$VAR_NAME=" "$DOCKER_ENV_FILE"; then
      echo "$VAR_NAME=$VAR_VALUE" >> "$DOCKER_ENV_FILE"
    fi
    # Add the key if it does not exist in the .env file
    if ! grep -q "^$VAR_NAME=" "$ENV_FILE"; then
      echo "$VAR_NAME=$VAR_VALUE" >> "$ENV_FILE"
    fi

    # Print information about the updated variable only if the value has changed
    if [ "$OLD_VALUE" != "$VAR_VALUE" ]; then
      if [ $? -eq 0 ]; then
        echo "$DOCKER_ENV_FILE: $VAR_NAME => $VAR_VALUE"
      else
        echo "Error: Failed to update $DOCKER_ENV_FILE: $VAR_NAME"
      fi
    fi
  done
else
  echo "Error: $DOCKER_ENV_FILE does not exist."
fi

# Set the bash aliases for the current session from the .bash_aliases file
# basename=$(basename "$0")
#dirname=$(dirname "$0")
#source ./"$dirname/.bash_aliases"
