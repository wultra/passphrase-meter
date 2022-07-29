#!/bin/sh

SCRIPT_FOLDER=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
opt=${1:--ns}
"${SCRIPT_FOLDER}/android-publish-build.sh" ${opt} local

