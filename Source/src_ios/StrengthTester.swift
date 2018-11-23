//
// Copyright 2018 Wultra s.r.o.
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
import PasswordMeter

/// Class that provides functionality for testing strngth of passwords and PINs.
///
/// Warning: Only one insttance of this class can exist. Init will return nil if you'll try to create 2nd instance.
public class StrengthTester {
    
    private static weak var instance: StrengthTester?
    
    /// Will create instance of the tester. Only one instance can be created, otherwise will return nil.
    /// If dictionary setup fails, init will also return nil.
    ///
    /// - Parameter dictionary: language dictionary for password checking
    public init?(dictionary: StrengthTesterDictionary? = nil) {
        
        guard StrengthTester.instance == nil else {
            print("[StrengthTester] WARNING: Only one instance of StrengthChecker can exist")
            return nil
        }
        
        if let dictionary = dictionary {
            guard
                let result = dictionary.path.data(using: .utf8)?.withUnsafeBytes({ WPM_setPasswordDictionary($0) }),
                result == 1 else {
                    print("[StrengthTester] WARNING: Instance with give dict cannot be configured.")
                    return nil
            }
        }
        
        StrengthTester.instance = self
    }
    
    deinit {
        WPM_freePasswordDictionary()
        StrengthTester.instance = nil
    }
    
    
    /// Tests strength of the PIN.
    ///
    /// - Parameter pin: PIN to evaluate. This needs to be digits only.
    /// - Returns: Optionset of found issues.
    public func testPin(_ pin: String) -> PinTestResult {
        
        guard Int(pin) != nil else {
            return .pinFormatError
        }
        
        return pin.data(using: .utf8)!.withUnsafeBytes({ (ptr: UnsafePointer<Int8>) -> PinTestResult in
            
            let result = WPM_testPasscode(ptr)
            
            var cr: PinTestResult = []
            
            if result.rawValue & NOT_UNIQUE_WPM.rawValue != 0 {
                cr.insert(.notUnique)
            }
            
            if result.rawValue & HAS_PATTERN_WPM.rawValue != 0 {
                cr.insert(.patternFound)
            }
            
            if result.rawValue & REPEATING_CHARACTERS_WPM.rawValue != 0 {
                cr.insert(.repeatingCharacters)
            }
            
            if result.rawValue & POSSIBLY_DATE_WPM.rawValue != 0 {
                cr.insert(.possiblyDate)
            }
            
            if result.rawValue & FREQUENTLY_USED_WPM.rawValue != 0 {
                cr.insert(.frequentlyUsed)
            }
            
            if cr.isEmpty {
                cr.insert(.ok)
            }
            
            return cr
        })
    }
    
    /// Tests strength of the password.
    ///
    /// Note that result is affected by dictionary that was set in `init` method.
    ///
    /// - Parameter password: Password to test
    /// - Returns: Strength of the password
    public func testPassword(_ password: String) -> PasswordStrength {
        guard password.count > 0 else { return .veryWeak }
        return PasswordStrength(password.data(using: .utf8)!.withUnsafeBytes{ return WPM_testPassword($0) })
    }
}

/// Specific language dictionary for password strength checking. Note that implementation for each language is provided in separated podspec.
public struct StrengthTesterDictionary {
    let path: String
    init(_ path: String) {
        self.path = path
    }
}

/// Result of PIN testing
public struct PinTestResult: OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    /// No issues found
    public static let ok = PinTestResult(rawValue: 1 << 0)
    /// Not enough unique digits found
    public static let notUnique = PinTestResult(rawValue: 1 << 1)
    /// Too much repeating characters
    public static let repeatingCharacters = PinTestResult(rawValue: 1 << 2)
    /// There is a pattern in this pin (for example 1357)
    public static let patternFound = PinTestResult(rawValue: 1 << 3)
    /// Tested pin could be date (for example 2512 as birthday - 25th of december)
    public static let possiblyDate = PinTestResult(rawValue: 1 << 4)
    /// Tested pin is in TOP used pins (like 1234 as number 1 used pin)
    public static let frequentlyUsed = PinTestResult(rawValue: 1 << 5)
    /// PIN contains non-digit characters
    public static let pinFormatError = PinTestResult(rawValue: 1 << 6)
}

/// Result of password strength test
public enum PasswordStrength {
    case veryWeak
    case weak
    case modetrate
    case good
    case strong
    
    fileprivate init(_ score: WPM_password_check_score) {
        switch score {
        case VERY_WEAK_PASSWORD_SCORE_WPM: self = .veryWeak
        case WEAK_PASSWORD_SCORE_WPM: self = .weak
        case MODERATE_PASSWORD_SCORE_WPM: self = .modetrate
        case GOOD_PASSWORD_SCORE_WPM: self = .good
        case STRONG_PASSWORD_SCORE_WPM: self = .strong
        default: fatalError("Uncovered password check case", file: "StrengthTester.swift")
        }
    }
}
