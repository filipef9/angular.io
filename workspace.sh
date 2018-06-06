#!/bin/bash

set -eu

dockerComposeFile='workspace.yml'

function showUsage() {
    echo "usage: $0 start|access|stop|status|help"
}

function getStatus() {
    docker-compose -f $dockerComposeFile ps
}

function start() {
    docker-compose -f $dockerComposeFile up -d &&\
    getStatus
    docker-compose -f $dockerComposeFile exec -u node workspace /bin/sh
}

function access() {
    if [[ "$(docker-compose -f workspace.yml ps | grep workspace | awk '{print $1}')" != "" ]]; then
        docker-compose -f $dockerComposeFile exec -u node workspace /bin/sh
    else
        start
    fi
}

function stop() {
    docker-compose -f $dockerComposeFile down
    getStatus
}

if [[ "$#" -eq 0 ]]; then
    echo "$0: try \"$0 help\" for more information"
    exit 1
fi

case "$1" in
    help)
        showUsage
        exit
        ;;
    start)
        start
        ;;
    access)
        access
        ;;
    stop)
        stop
        ;;
    status)
        getStatus
        ;;
    *)
        echo "ERROR: command \"$1\" not found."
        showUsage
        exit 1
esac

exit 0
