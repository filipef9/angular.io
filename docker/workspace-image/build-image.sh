#!/bin/sh

set -eu

version='8.11.2'

docker image build -t node-workspace:$version .
