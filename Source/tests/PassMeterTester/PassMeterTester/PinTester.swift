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

final class PinTester {
    private init() { }
    
    static func test(_ url: URL) -> Int32 {
        
        guard var loadedPins = loadFromFile(url) else {
            print("Failed to load pin file")
            return 1
        }
        
        var badPins = 0
        
        PinGenerator.pins(maxLength: testingPinLength) { pin, percent in
            
            if let filePin = loadedPins.removeValue(forKey: pin.value) {
                if pin.result != filePin.result {
                    print("\(pin.value) changed from \(filePin.result) to \(pin.result)", terminator: ", ")
                    badPins += 1
                }
            } else if pin.result.isEmpty == false {
                print("\(pin.value) changed from OK to \(pin.result)", terminator: ", ")
                badPins += 1
            }
        }
        
        if badPins > 0 {
            print("\(badPins) has changed from testing set.")
            return 1
        } else {
            print("Everything looks 👌")
            return 0
        }
    }
    
    private static func loadFromFile(_ url: URL) -> [String: Pin]? {
        
        let fileUrl = URL(fileURLWithPath: url.path)
        
        let data: Data
        do {
            data = try Data(contentsOf: fileUrl)
        } catch let e {
            print(e)
            return nil
        }
        
        guard let content = String(bytes: data, encoding: .utf8) else {
            return nil
        }
        
        let items = content.split(separator: ",").map { Pin(fromFileFormat: String($0)) }
        
        return Dictionary(uniqueKeysWithValues: items.map({ ($0.value, $0) }))
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places :Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
