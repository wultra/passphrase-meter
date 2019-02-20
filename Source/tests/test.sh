#!/bin/bash

#set -e # stop sript when error occures
#set -x # print all execution (good for debugging)

testfile=$(pwd)/testfile.txt

function section
{
    echo -e "\033[0;32m${1}\033[0m"
}

function success
{
    echo -e "\033[0;32m${1}\033[0m"
}

function error
{
    echo -e "\033[0;31m${1}\033[0m"
}

function qpopd
{
    popd > /dev/null
}

function qpushd 
{
    pushd "$1" > /dev/null
}

function consistencytest
{
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

function iostest
{
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

consistencytest
iostest