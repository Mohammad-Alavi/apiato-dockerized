#!/usr/bin/env bash

case "$OSTYPE" in
    linux*) HOST_IP=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+') ;;
    darwin*) HOST_IP="docker.for.mac.host.internal" ;;
    msys*|cygwin*) HOST_IP="docker.for.win.host.internal" ;;
    *) echo "Unknown system: $OSTYPE. Set APP_XDEBUG_REMOTE_HOST_IP manually in .env." ;;
esac

if [[ $HOST_IP ]]; then
    export APP_XDEBUG_REMOTE_HOST_IP=$HOST_IP
else
    echo "Docker host IP not found. Set APP_XDEBUG_REMOTE_HOST_IP manually in .env."
fi

docker-compose "$@"
RESULT=$?
exit $RESULT