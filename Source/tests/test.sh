#!/bin/bash

#set -e # stop sript when error occures
#set -x # print all execution (good for debugging)

testfile=$(pwd)/testfile.txt

function section { # prints section header
    echo -e "\033[0;32m${1}\033[0m"
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
    section "BUILDING CONSISTENCY TEST PROJECT"
    xcodebuild -workspace PassMeterTester.xcworkspace -scheme PassMeterTester clean > /dev/null 2>&1
    pod install > /dev/null
    xcodebuild -quiet -workspace PassMeterTester.xcworkspace -configuration Debug -sdk macosx10.14 -scheme PassMeterTester build OBJROOT=$(PWD)/build SYMROOT=$(PWD)/build > /dev/null 2>&1

    qpushd "build/Debug"

    if [[ $1 = "generate" ]]; then
        section "RUNNING FILE GENERATING"
        ./PassMeterTester "-generate" "${testfile}"
        exit 0
    else
        section "RUNNING CONSISTENCY TEST"
        ./PassMeterTester "-test" "${testfile}"
    fi

    qpopd
    qpopd
}

# Builds and runs ios test
function iostest {
    qpushd "../examples/iOS/PassMeterExample"
    section "RUNNING iOS TESTS"
    xcodebuild -workspace PassMeterExample.xcworkspace -scheme PassMeterExample clean > /dev/null 2>&1
    pod install > /dev/null
    xcodebuild -workspace PassMeterExample.xcworkspace -scheme PassMeterExample -destination 'platform=iOS Simulator,name=iPhone SE,OS=12.1' test > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        error "iOS TESTS FAILED"
    else
        success "iOS TESTS OK"
    fi
    qpopd
}

# Builds and runs android test
function androidtest {
    section "RUNNING ANDROID TESTS"
    sh "../src_android/scripts/build-publish-local.sh" > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        error "ANDROID LIB BUILD FAILED"
    fi
    qpushd "../examples/Android/PassMeterExample"
    ./gradlew "clean" "cAT"  > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        error "ANDROID TESTS FAILED"
    else
        success "ANDROID TESTS OK"
    fi
}

consistencytest $1
iostest
androidtest