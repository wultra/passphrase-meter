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
import WultraPassphraseMeter

final class PinGenerator {
    
    private init() { }
    
    static func generate(url: URL) throws {
        
        FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
        let h = try FileHandle(forWritingTo: url)
        
        var started = true
        
        pins(maxLength: testingPinLength) { pin, percent in
            
            //print(String(format: "%.2f%% evaluated \(pin)", percent*100))
            
            if pin.result.isEmpty == false {
                h.write("\(started ? "" : ",")\(pin.fileValue)".data(using: .utf8)!)
            }
            
            if started {
                started = false
            }
        }
    }
    
    static func pins(maxLength: Int, handle: (_ pin: Pin, _ percent: Double) -> Void) {
        
        guard maxLength > 3 else {
            return
        }
        
        // we only need to test 20% of the numbers to get the full coverage of variants (the rest is just variants for 1234....,2345....,3456....)
        let capacity = Int(pow(10, Double(maxLength)))/5
        var tested = 0.0
        let total = Double(capacity)
        
        for pin in 0..<capacity {
            
            tested += 1
            
            if tested.truncatingRemainder(dividingBy: 100000) == 0 {
                print("  \(((tested/total)*100).rounded(toPlaces: 2))% done \r", terminator: "")
                fflush(stdout)
            }
            
            let digits = numberOfDigits(in: pin)
            for length in 4...maxLength {
                if digits > length {
                    continue
                }
                let formatted =  String(format: "%0\(length)d", pin)
                handle(Pin(value: formatted, result: PasswordTester.shared.testPin(formatted).issues), Double(pin)/Double(capacity))
            }
        }
    }
    
    private static func numberOfDigits(in number: Int) -> Int {
        if number < 10 {
            return 1
        } else {
            return 1 + numberOfDigits(in: number/10)
        }
    }
}
