# #!/bin/bash

# Enable debugging and print all commands for the current shell
# set -x

# Get the path of the current script
script_path="${BASH_SOURCE[0]}"

# Convert Windows-style line endings to Unix-style line endings
sed -i '' 's/\r$//' "$script_path"

# Get the current directory name using ${pwd##*/}
CURRENT_DIR_NAME="${PWD##*/}"
# Get the current directory path using $(pwd)
CURRENT_DIR_PATH=$(pwd)

# Get the values for OS_USER and UID for the current user
OS_USER=$(whoami)
OS_UID=$(id -u)

# Define an associative array to map variable names to their values
declare -A VAR_VALUES=(
  ["COMPOSE_PROJECT_NAME"]=$CURRENT_DIR_NAME
  ["PROJECT_FOLDER_NAME"]=$CURRENT_DIR_NAME
  ["PROJECT_VOLUME"]="./$CURRENT_DIR_NAME:/opt/project"
  ["WORKING_DIR"]="/opt/project"
  ["OS_USER"]=$OS_USER
  ["UID"]=$OS_UID
)

# Define the path to your .env file
DOCKER_ENV_FILE="$CURRENT_DIR_PATH/.env.docker"
# move up 1 directory from current directory and set the .env file
ENV_FILE="$CURRENT_DIR_PATH/../.env"

# Create the .env file if it does not exist
if [ ! -e "$DOCKER_ENV_FILE" ]; then
  touch "$DOCKER_ENV_FILE"
  if [ $? -eq 0 ]; then
    echo "Created $DOCKER_ENV_FILE"
  else
    echo "Error: Failed to create $DOCKER_ENV_FILE"
  fi
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
  for VAR_NAME in "${!VAR_VALUES[@]}"; do
    VAR_VALUE="${VAR_VALUES[$VAR_NAME]}"
    OLD_VALUE=$(grep "^$VAR_NAME=" "$DOCKER_ENV_FILE" | cut -d '=' -f2)
    # Replace the value if the key exists
    sed -i '' "s^$VAR_NAME=.*^$VAR_NAME=$VAR_VALUE^" "$DOCKER_ENV_FILE"
    sed -i '' "s^$VAR_NAME=.*^$VAR_NAME=$VAR_VALUE^" "$ENV_FILE"

    # Add the key if it does not exist
    if ! grep -q "^$VAR_NAME=" "$DOCKER_ENV_FILE"; then
      echo "$VAR_NAME=$VAR_VALUE" >> "$DOCKER_ENV_FILE"
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
