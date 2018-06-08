#!/bin/bash

set -eu

dockerComposeFile='docker/workspace-image/workspace.yml'

function showUsage() {
    echo "usage: $0 up|access|stop|start|destroy|recreate|status|help"
}

function getStatus() {
    docker-compose -f $dockerComposeFile ps
}

function up() {
    docker-compose -f $dockerComposeFile up -d &&\
    getStatus
    access
}

function access() {
    if [[ "$(docker-compose -f $dockerComposeFile ps | grep workspace | awk '{print $1}')" != "" ]]; then
        docker-compose -f $dockerComposeFile exec -u node workspace /bin/sh
    else
        start
    fi
}

function start() {
    docker-compose -f $dockerComposeFile start
    getStatus
    access
}

function stop() {
    docker-compose -f $dockerComposeFile stop
    getStatus
}

function recreate() {
    destroy
    up
}

function destroy() {
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
        exit ;;
    up)
        up ;;
    access)
        access ;;
    start)
        start ;;
    stop)
        stop ;;
    destroy)
        destroy ;;
    recreate)
        recreate ;;
    status)
        getStatus ;;
    *)
        echo "ERROR: command \"$1\" not found."
        showUsage
        exit 1
esac

exit 0
