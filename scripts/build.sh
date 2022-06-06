#!/bin/bash

set -e

###############################################################################
# PassphraseMeter build for Apple platforms
#
# The main purpose of this script is build and prepare PassphraseMeter
# xcframeworks for the library distribution.
#
# ----------------------------------------------------------------------------

###############################################################################
# Include common functions...
# -----------------------------------------------------------------------------
TOP=$(dirname $0)
source "${TOP}/common-functions.sh"
source "${TOP}/targets.sh"
SRC_ROOT="`( cd \"$TOP/..\" && pwd )`"
BUILD_FOLDER="${TOP}/build"

# Variables loaded from command line
VERBOSE=1
OUT_DIR=''

# -----------------------------------------------------------------------------
# USAGE prints help and exits the script with error code from provided parameter
# Parameters:
#   $1   - error code to be used as return code from the script
# -----------------------------------------------------------------------------
function USAGE
{
    echo ""
    echo "Usage:  $CMD  [options]"
    echo ""
    echo "  Build PassphraseMeter.xcframework and dictionaries xcframeworks"
    echo ""
    echo "options are:"
    echo ""
    echo "  --out-dir path    changes directory where final framework"
    echo "                    will be stored"
    echo ""
    echo "  --sim-only        will build simulator only only"
    echo ""
    echo "  -v0               turn off all prints to stdout"
    echo "  -v1               print only basic log about build progress"
    echo "  -v2               print full build log with rich debug info"
    echo "  -h | --help       prints this help information"
    echo ""
    exit $1
}

# -----------------------------------------------------------------------------
# Build library for all plaforms and create xcframework
# -----------------------------------------------------------------------------
function BUILD_LIB
{
    local target="$1"
    local xcver=$(GET_XCODE_VERSION --full)
    
    LOG_LINE
    LOG "Building PassphraseMeter with Xcode ${xcver}..."
    LOG_LINE

    local ios_archive="${BUILD_FOLDER}/${target}_ios.xcarchive"
    local sim_archive="${BUILD_FOLDER}/${target}_ios_sim.xcarchive"
    local final_artifact_name="${target}.xcframework"
    local final_artifact="${BUILD_FOLDER}/${final_artifact_name}"
    local project_path="Source/proj_ios/WultraPassphraseMeter.xcodeproj"

    PUSH_DIR "${SRC_ROOT}"

    # build for ios device
    xcodebuild archive \
        -project ${project_path} \
        -scheme ${target} \
        -archivePath "${ios_archive}" \
        -configuration "Release" \
        -sdk iphoneos \
        SKIP_INSTALL=NO \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        SWIFT_SERIALIZE_DEBUGGING_OPTIONS=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES

    # build for ios simulator
    xcodebuild archive \
        -project ${project_path} \
        -scheme ${target} \
        -archivePath "${sim_archive}" \
        -configuration "Release" \
        -sdk iphonesimulator \
        SKIP_INSTALL=NO \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        SWIFT_SERIALIZE_DEBUGGING_OPTIONS=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES

    # create xcframwork
    xcodebuild -create-xcframework \
        -framework "${ios_archive}/Products/Library/Frameworks/${target}.framework" \
        -framework "${sim_archive}/Products/Library/Frameworks/${target}.framework" \
        -output "${final_artifact}"
    
    mkdir -p "${OUT_DIR}"
    cp -r "${final_artifact}" "$OUT_DIR"
    
    POP_DIR
}

###############################################################################
# Script's main execution starts here...
# -----------------------------------------------------------------------------

while [[ $# -gt 0 ]]
do
    opt="$1"
    case "$opt" in
        --out-dir)
            OUT_DIR="$2"
            shift
            ;;
        -v*)
            SET_VERBOSE_LEVEL_FROM_SWITCH $opt
            ;;
        -h | --help)
            USAGE 0
            ;;
        *)
            USAGE 1
            ;;
    esac
    shift
done

# Defaulting target & temporary folders
if [ -z "$OUT_DIR" ]; then
    OUT_DIR="${TOP}/Lib"
fi

rm -rf "${BUILD_FOLDER}" # delete old builds

for target in "${TARGETS[@]}"; do
   BUILD_LIB "${target}"
done

EXIT_SUCCESS
