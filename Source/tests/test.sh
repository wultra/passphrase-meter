#!/bin/bash

#set -e # stop sript when error occures
#set -x # print all execution (good for debugging)

testfile=$(pwd)/testfile.txt

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
function qpopd { # quiet popd
    popd > /dev/null
}
function qpushd { # quiet pushd
    pushd "$1" > /dev/null
}

# This tests tests pins between 0000 - 1999999 if there was any change with current implementation
function consistencytest { 
    qpushd "PassMeterTester"
    section "CONSISTENCY TESTS ON PIN SAMPLES"
    subtask "cleaning project"
    xcodebuild -workspace PassMeterTester.xcworkspace -scheme PassMeterTester clean > /dev/null 2>&1
    subtask "running cocoapods"
    pod install > /dev/null
    subtask "building test project"
    xcodebuild -quiet -workspace PassMeterTester.xcworkspace -configuration Debug -sdk macosx10.14 -scheme PassMeterTester build OBJROOT=$(PWD)/build SYMROOT=$(PWD)/build > /dev/null 2>&1

    qpushd "build/Debug"

    if [[ $1 = "generate" ]]; then
        section "RUNNING FILE GENERATING"
        ./PassMeterTester "-generate" "${testfile}"
        exit 0
    else
        subtask "running consistency tests"
        ./PassMeterTester "-test" "${testfile}"
    fi

    qpopd
    qpopd
}

# Builds and runs ios test
function iostest {
    qpushd "../examples/iOS/PassMeterExample"
    section "iOS TESTS"
    subtask "cleaning project"
    xcodebuild -workspace PassMeterExample.xcworkspace -scheme PassMeterExample clean > /dev/null 2>&1
    subtask "running cocoapods"
    pod install > /dev/null
    subtask "running tests"
    xcodebuild -workspace PassMeterExample.xcworkspace -scheme PassMeterExample -destination 'platform=iOS Simulator,name=iPhone SE,OS=12.2' test > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        error "iOS TESTS FAILED"
    else
        success "iOS TESTS OK"
    fi
    qpopd
}

# Builds and runs android test
function androidtest {
    section "ANDROID TESTS"
    subtask "Publishing library to local maven"
    sh "../src_android/scripts/build-publish-local.sh" > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        error "ANDROID LIB BUILD FAILED"
    fi
    qpushd "$HOME/Library/Android/sdk/tools/"
    subtask "starting emulator"
    name=$(./emulator -list-avds | head -n1)
    ./emulator "@${name}" &
    adb wait-for-device
    qpopd
    qpushd "../examples/Android/PassMeterExample"
    subtask "running tests"
    ./gradlew "clean" "cAT" > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        error "ANDROID TESTS FAILED"
    else
        success "ANDROID TESTS OK"
    fi
}

echo -e "\n!! All scripts are running in silent mode (no output). In case of test fail, modify this script to be able to debug."

consistencytest $1
iostest
androidtest