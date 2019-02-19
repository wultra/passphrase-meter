//
// Copyright 2019 Wultra s.r.o.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions
// and limitations under the License.
//

import Foundation

let testingPinLength = 8

func printHelp() {
    
    print("-------- Wultra PassMeter Tester --------")
    print("")
    print("run this program with -generate absolute_path_to_file to generate testing file")
    print("")
    print("run this program with -test absolute_path_to_file to test this file")
}

guard CommandLine.arguments.count == 3 else {
    printHelp()
    exit(1)
}

guard let url = URL(string: CommandLine.arguments[2]) else {
    print("error: \(CommandLine.arguments[2]) is not valid path")
    printHelp()
    exit(1)
}

if CommandLine.arguments[1] == "-generate" {
    do {
        print("Generating test file...")
        try PinGenerator.generate(url: url)
        print("Done!")
    } catch let e {
        print("error: \(e)")
    }
} else if CommandLine.arguments[1] == "-test" {
    print("Testing given file against current code...")
    PinTester.test(url)
    print("Done!")
} else {
    print("Unkown parameter")
    exit(1)
}
