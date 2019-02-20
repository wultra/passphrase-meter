#!/bin/bash

set -e # stop sript when error occures
#set -x # print all execution (good for debugging)

testfile=$(pwd)/testfile.txt

pushd "PassMeterTester"
echo -e "\n\n\n\n\n UPDATING PODS \n\n\n\n\n"
pod install
echo -e "\n\n\n\n\n BUILDING TEST PROJECT \n\n\n\n\n"
xcodebuild -quiet -workspace PassMeterTester.xcworkspace -configuration Debug -sdk macosx10.14 -scheme PassMeterTester build OBJROOT=$(PWD)/build SYMROOT=$(PWD)/build

pushd "build/Debug"

if [[ $1 = "generate" ]]; then
    echo -e "\n\n\n\n\n RUNNING FILE GENERATING \n\n\n\n\n"
    ./PassMeterTester "-generate" "${testfile}"
else
    echo -e "\n\n\n\n\n RUNNING TEST \n\n\n\n\n"
    ./PassMeterTester "-test" "${testfile}"
fi