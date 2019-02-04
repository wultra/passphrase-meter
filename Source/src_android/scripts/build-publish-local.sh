#!/usr/bin/env bash

cd "$( dirname "$0" )/.."
./gradlew clean build install "$@"
