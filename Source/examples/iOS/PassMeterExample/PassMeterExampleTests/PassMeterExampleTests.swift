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

import XCTest
import WultraPassMeter
@testable import PassMeterExample

class PassMeterExampleTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        PasswordTester.shared.freeLoadedDictionary()
    }

    func testLibraryLoad() {
        XCTAssert(PasswordTester.shared.hasLoadedDictionary == false)
        PasswordTester.shared.loadDictionary(.czsk)
        XCTAssert(PasswordTester.shared.hasLoadedDictionary)
        PasswordTester.shared.freeLoadedDictionary()
        XCTAssert(PasswordTester.shared.hasLoadedDictionary == false)
    }
    
    func testWrongInputPin() {
        let result = PasswordTester.shared.testPin("asdf")
        XCTAssert(result == .pinFormatError)
    }
    
    func testPinIssues() {
        let frequent = PasswordTester.shared.testPin("1111")
        XCTAssert(frequent.contains(.frequentlyUsed))
        let pattern = PasswordTester.shared.testPin("1357")
        XCTAssert(pattern.contains(.patternFound))
        let date = PasswordTester.shared.testPin("1990")
        XCTAssert(date.contains(.possiblyDate))
        let unique = PasswordTester.shared.testPin("1112")
        XCTAssert(unique.contains(.notUnique))
        let repeating = PasswordTester.shared.testPin("1111")
        XCTAssert(repeating.contains(.repeatingCharacters))
    }
    
    func testOKPin() {
        let pin = PasswordTester.shared.testPin("9562")
        XCTAssert(pin.isEmpty)
    }
    
    func testPinDates() {
        let dates = ["0304", "1012", "3101", "1998", "2005", "150990", "241065", "16021998", "03122001"]
        let noDates = ["1313", "0028", "1287", "9752", "151590", "001297", "41121987"]
        
        for date in dates {
            XCTAssert(PasswordTester.shared.testPin(date).contains(.possiblyDate), date)
        }
        
        for nodate in noDates {
            XCTAssert(PasswordTester.shared.testPin(nodate).contains(.possiblyDate) == false, nodate)
        }
    }
    
    func testEnglishDictionary() {
        
        let words = [
            "international",
            "january",
            "development",
            "different",
            "television",
            "established",
            "championship",
            "performance",
            "municipality",
            "approximately",
            "background",
            "administrative"
        ]
        
        for word in words {
            let result = PasswordTester.shared.testPassword(word)
            XCTAssert(result == .good || result == .strong, word)
        }
        
        PasswordTester.shared.loadDictionary(.en)
        
        for word in words {
            let result = PasswordTester.shared.testPassword(word)
            XCTAssert(result == .weak || result == .veryWeak, word)
        }
    }
    
    func testCzskDictionary() {
        
        let words = [
            "spolecnosti",
            "rozcestnik",
            "rimskokatolicka",
            "ceskoslovenske",
            "historicke",
            "ostrava",
            "bratislava",
            "organizacie",
            "juhovychodnej",
            "demokratickej",
            "vydavatelstvo",
            "svajciarsko"
        ]
        
        for word in words {
            let result = PasswordTester.shared.testPassword(word)
            XCTAssert(result == .good || result == .strong, word)
        }
        
        PasswordTester.shared.loadDictionary(.czsk)
        
        for word in words {
            let result = PasswordTester.shared.testPassword(word)
            XCTAssert(result == .weak || result == .veryWeak, word)
        }
    }
    
    func testPasswords()  {
        XCTAssert(PasswordTester.shared.testPassword("qwerty") == .weak) // keyboard pattern
        XCTAssert(PasswordTester.shared.testPassword("12345678") == .veryWeak) // keyboard pattern
        XCTAssert(PasswordTester.shared.testPassword("ap") == .veryWeak) // too short
        XCTAssert(PasswordTester.shared.testPassword("apwu") == .weak) // short
        XCTAssert(PasswordTester.shared.testPassword("apwunb") == .good) // OK
        XCTAssert(PasswordTester.shared.testPassword("ap,wu92nbSm;#/") == .strong) // Strong
    }

}
