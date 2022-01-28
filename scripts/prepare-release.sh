#!/bin/bash
###############################################################################
# This script prepares release 
# ----------------------------------------------------------------------------

###############################################################################
# Include common functions...
# -----------------------------------------------------------------------------
TOP=$(dirname $0)
source "${TOP}/common-functions.sh"
source "${TOP}/targets.sh"
SRC_ROOT="`( cd \"$TOP/..\" && pwd )`"

# -----------------------------------------------------------------------------
RELEASE_DIR="${TOP}/public-repo"
BUILD_DIR="${TOP}/Lib"
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# USAGE prints help and exits the script with error code from provided parameter
# Parameters:
#   $1   - error code to be used as return code from the script
# -----------------------------------------------------------------------------
function USAGE
{
    echo ""
    echo "Usage: $CMD version"
    echo ""
    echo "  -p | --publish    creates tag and commit message"
    echo ""
    echo "  -v0               turn off all prints to stdout"
    echo "  -v1               print only basic log about build progress"
    echo "  -v2               print full build log with rich debug info"
    echo "  -h | --help       prints this help information"
    echo ""
    exit $1
}

# -----------------------------------------------------------------------------
# PATCH_LIBRARY_VERSION function applies version & build number to FwVersion.xcconfig
# -----------------------------------------------------------------------------
function PATCH_LIBRARY_VERSION
{
    LOG_LINE
    LOG "Patching library version & build number..."
    
    PUSH_DIR "$SRC_ROOT"
    
    local FW_VERSION_FILE="Source/proj_ios/FwVersion.xcconfig"

    # Revert possible changes in version file, to do not increase version if build has not been published
    git checkout -- $FW_VERSION_FILE
    
    # Load current build number
    local DEPLOY_BUILD=$(GET_PROPERTY $FW_VERSION_FILE "CURRENT_PROJECT_VERSION ")
    if [ -z "$DEPLOY_BUILD" ]; then
        WARNING "Defaulting \$DEPLOY_BUILD to 1"
        DEPLOY_BUILD=1
    else
        DEPLOY_BUILD=$(expr $DEPLOY_BUILD + 1)
    fi
    
    # Patch version file
    sed -e "s/%DEPLOY_VERSION%/$VERSION/g" "${TOP}/FwVersion.xcconfig.tpl" | sed -e "s/%DEPLOY_BUILD%/$DEPLOY_BUILD/g" > $FW_VERSION_FILE
    
    POP_DIR
    
    LOG " - Version $VERSION, build $DEPLOY_BUILD"
}

# -----------------------------------------------------------------------------
# PREPARE_BUILD function prepares precompiled xcframework with library
# -----------------------------------------------------------------------------
function PREPARE_BUILD
{
    PATCH_LIBRARY_VERSION
    
    LOG_LINE
    LOG "Building library..."
    
    [[ -d "$BUILD_DIR" ]] && $RM -r "$BUILD_DIR"
    $MD "$BUILD_DIR"
    "${TOP}/build.sh" --out-dir "${BUILD_DIR}"
}

# -----------------------------------------------------------------------------
# PREPARE_RELEASE function prepares local changes required for CocoaPods & SPM
# -----------------------------------------------------------------------------
function PREPARE_RELEASE
{   
    LOG_LINE
    LOG "Preparing repository for distribution..."

    PUSH_DIR "${BUILD_DIR}"

    local TPL_CONTENT=$(cat "$TOP/Package.swift.tpl")
    local PACKAGE_CONTENT=$(echo "$TPL_CONTENT")
    
    for TARGET in "${TARGETS[@]}"; do
        LOG "- Preparing ${TARGET} archive..."
        local ZIP_FILE="${TARGET}-${VERSION}.xcframework.zip"
        local ZIP_URL="https://github.com/wultra/powerauth-mobile-sdk-spm/releases/download/${VERSION}/${ZIP_FILE}"
        
        zip -9yrq "${ZIP_FILE}" "${TARGET}.xcframework"
        
        local ZIP_HASH=$(SHA256 "$ZIP_FILE")
        
        LOG "   - Patching Package.swift with ${TARGET} data..."
        PACKAGE_CONTENT=$(echo "$PACKAGE_CONTENT" | sed -e "s|%ZIP_URL_${TARGET}%|$ZIP_URL|g" | sed -e "s|%ZIP_HASH_${TARGET}%|$ZIP_HASH|g")
    done

    echo "$PACKAGE_CONTENT" > "${SRC_ROOT}/Package.swift"
    
    LOG "- Preparing podspec..."
    sed -e "s/%DEPLOY_VERSION%/$VERSION/g" "${TOP}/WultraPassphraseMeter.podspec.tpl" > "${SRC_ROOT}/WultraPassphraseMeter.podspec" 
        
    POP_DIR
}

# -----------------------------------------------------------------------------
# CREATE_AND_PUSH_TAG function creates version tag and push to git
# -----------------------------------------------------------------------------
function CREATE_AND_PUSH_TAG
{
    local XCVER=$(GET_XCODE_VERSION --full)
    local RELEASE_MSG="Version $VERSION, compiled with Xcode $XCVER"
    
    LOG_LINE
    LOG "Creating release..."
    
    LOG "- Adding changed files..."
    git add .
    LOG "- Commiting changes..."
    git commit -m "$RELEASE_MSG" $GIT_VERBOSE
    LOG "- Creating release tag..."
    git tag "${VERSION}"
    
    LOG "- Pushing changes to repository..."
    git push --tags $GIT_VERBOSE
    git push $GIT_VERBOSE
}

###############################################################################
# Script's main execution starts here...
# -----------------------------------------------------------------------------

while [[ $# -gt 0 ]]
do
    opt="$1"
    case "$opt" in
        -v*)
            SET_VERBOSE_LEVEL_FROM_SWITCH $opt
            ;;
        -h | --help)
            USAGE 0
            ;;
        -p | --publish)
            DO_PUBLISH=1
            ;;
        *)
            VALIDATE_AND_SET_VERSION_STRING $opt
            ;;
    esac
    shift
done

if [ -z "$VERSION" ]; then
	FAILURE "You have to provide version string."
fi

# Silence output from git depending on verbose level
GIT_VERBOSE=""
if [ x$VERBOSE != x2 ]; then
    GIT_VERBOSE="--quiet"
fi

# Prerequisities
REQUIRE_COMMAND xcodebuild
[[ x$DO_PUBLISH == x1 ]] && REQUIRE_COMMAND git

# Do the job
PREPARE_BUILD
PREPARE_RELEASE

[[ x$DO_PUBLISH == x1 ]] && CREATE_AND_PUSH_TAG

EXIT_SUCCESS
