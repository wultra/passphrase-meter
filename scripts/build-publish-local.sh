#!/bin/sh

TOP=$(dirname "$(readlink "$BASH_SOURCE")")
opt=${1:--ns}
"${TOP}/../scripts/android-publish-build.sh" ${opt} local

