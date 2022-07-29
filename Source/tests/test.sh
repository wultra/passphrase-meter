#!/bin/bash

set -e # stop sript when error occures
#set -x # print all execution (good for debugging)

SCRIPT_FOLDER=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

testfile=${SCRIPT_FOLDER}/testfile.txt

function section { # prints section header
    echo -e "\033[0;32m\n ## ${1} ## \033[0m"
}
function subtask { # 
    echo -e "\033[0;33m- ${1}\033[0m"
}
function success { # prints success text to console
    echo -e "\033[0;32m${1}\033[0m"
}
function error { # prints failed text to console and exits
    echo -e "\033[0;31m${1}\033[0m"
    exit 1
}

# This checks if there is a change with current implementation between PINs 0000 - 1999999
function consistencytest { 
    pushd "${SCRIPT_FOLDER}/PassMeterTester"
    buildfolder="build/Test"
    section "CONSISTENCY TESTS ON PIN SAMPLES"
    subtask "cleaning project"
    xcodebuild -workspace PassMeterTester.xcworkspace -scheme PassMeterTester clean
    rm -rf "${buildfolder}"
    rm -rf "Pods"
    subtask "running cocoapods"
    pod install
    subtask "building test project"
    xcodebuild -workspace PassMeterTester.xcworkspace -configuration Test -sdk macosx12.1 -scheme PassMeterTester build OBJROOT=$(PWD)/build SYMROOT=$(PWD)/build

    pushd "${buildfolder}"

    if [[ $1 = "generate" ]]; then
        section "RUNNING FILE GENERATING"
        ./PassMeterTester "-generate" "${testfile}"
        exit 0
    else
        subtask "running consistency tests"
        ./PassMeterTester "-test" "${testfile}"
    fi

    popd
    popd
}

# Build and run iOS tests
function iostest {
    pushd "${SCRIPT_FOLDER}/../examples/iOS/PassMeterExample"
    section "iOS TESTS"
    subtask "cleaning project"
    xcodebuild -workspace PassMeterExample.xcworkspace -scheme PassMeterExample clean
    subtask "running cocoapods"
    pod install
    subtask "running tests"
    xcodebuild -workspace PassMeterExample.xcworkspace -scheme PassMeterExample -destination 'platform=iOS Simulator,name=iPhone 12 mini,OS=15.2' test
    if [[ $? != 0 ]]; then
        error "iOS TESTS FAILED"
    else
        success "iOS TESTS OK"
    fi
    popd
}

# Build and run Android tests
function androidtest {
    section "ANDROID TESTS"
    subtask "Publishing library to local maven"
    sh "${SCRIPT_FOLDER}/../../scripts/build-publish-local.sh"
    echo "Result of the build-publish-local.sh: ${?}"
    if [[ $? != 0 ]]; then
        error "ANDROID LIB BUILD FAILED WITH RESULT: ${?}"
    fi

    # Note that at this point, android simulator should be running
    pushd "${SCRIPT_FOLDER}/../examples/Android/PassMeterExample"
    subtask "running tests"
    ./gradlew "clean" "cAT" #> /dev/null 2>&1
    if [[ $? != 0 ]]; then
        error "ANDROID TESTS FAILED"
    else
        success "ANDROID TESTS OK"
    fi
}

# removed android test until maven issue resolved (https://github.com/wultra/passphrase-meter/issues/42)
#androidtest
iostest
consistencytest $1