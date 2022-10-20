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
// the C module is named differently in CocoaPods
#if COCOAPODS
import PasswordMeter // Static library build by CocoaPods
#else
import WultraPassphraseMeterCore // SPM dynamic framework
#endif

/// Class that provides functionality for testing strength of passwords and PINs.
/// Only `sharedInstance` singleton is available.
public class PasswordTester {
    
    /**
     Singleton instance
     
     Consider proper usage of `loadDictionary` and `freeLoadedDictionary`.
     */
    public static var shared = PasswordTester()
    
    /// If password dictionary was loaded via `loadDictionary`
    public var hasLoadedDictionary: Bool { return WPM_hasPasswordDictionary() }
    
    init() {
    }
    
    deinit {
        freeLoadedDictionary()
    }
    
    /// Sets dictionary of poorly rated words for `testPassword` method
    ///
    /// - Parameter dictionary: Dictionary with words
    /// - Returns: true if dictionary was loaded
    @discardableResult public func loadDictionary(_ dictionary: PasswordTesterDictionary) -> Bool {
        return WPM_setPasswordDictionary(dictionary.path)
    }
    
    /// Free all resources tied to loaded dictionary
    public func freeLoadedDictionary() {
        WPM_freePasswordDictionary()
    }
    
    /// Tests strength of the PIN.
    ///
    /// Minimum length for PIN is 4 and maximum 100.
    ///
    /// - Parameter pin: PIN to evaluate..
    /// - Returns: Result of the testing
    public func testPin(_ passcodePtr: UnsafePointer<Int8>) -> PinTestResult {
		
        let code = WPM_testPasscode(passcodePtr).rawValue
        var issues: PinTestIssue = []
		
        if code & WPM_PasscodeResult_Ok.rawValue == 0 {
            if code & WPM_PasscodeResult_WrongInput.rawValue != 0 {
                issues.insert(.pinFormatError)
            }
            if code & WPM_PasscodeResult_NotUnique.rawValue != 0 {
                issues.insert(.notUnique)
            }
            if code & WPM_PasscodeResult_HasPattern.rawValue != 0 {
                issues.insert(.patternFound)
            }
            if code & WPM_PasscodeResult_RepeatingChars.rawValue != 0 {
                issues.insert(.repeatingCharacters)
            }
            if code & WPM_PasscodeResult_PossiblyDate.rawValue != 0 {
                issues.insert(.possiblyDate)
            }
            if code & WPM_PasscodeResult_FrequentlyUsed.rawValue != 0 {
                issues.insert(.frequentlyUsed)
            }
        }
        
        var pinLength : Int = 0
        while(passcodePtr[pinLength] != 0) {
            pinLength += 1
        }
        
        return PinTestResult(pinLength: pinLength, issues: issues)
    }
    
    /// Tests strength of the password.
    ///
    /// Note that result is affected by dictionary that was set in `init` method.
    ///
    /// - Parameter password: Password to test
    /// - Returns: Strength of the password
    public func testPassword(_ passwordPtr: UnsafePointer<Int8>) -> PasswordStrength {
        return PasswordStrength(WPM_testPassword(passwordPtr))
    }
}

/// Specific language dictionary for the password strength test.
///
/// Implementation for each language is provided in a separated POD / SPM package.
public struct PasswordTesterDictionary {
    public let path: String
    public init(_ path: String) {
        self.path = path
    }
}

/// Result of the PIN testing.
public struct PinTestResult {
    
    /// Tested pin
    public let pinLength: Int
    
    /// Issues found
    public let issues: PinTestIssue
    
    /// If the user should be warned that the PIN is weak. Be aware that this property is just a hint based on simple
    /// rules explained below. Consider implementing your own logic.
    /// ```
    /// +------------+--------------------------------------------------------------------+
    /// | PIN length | Returns true when                                                  |
    /// +============+====================================================================+
    /// | < 4        | never                                                              |
    /// | 4          | frequentlyUsed or notUnique                                        |
    /// | 5,6        | frequentlyUsed or notUnique or repeatingCharacters                 |
    /// | 6+         | frequentlyUsed or notUnique or repeatingCharacters or patternFound |
    /// +------------+--------------------------------------------------------------------+
    /// ```
    public var shouldWarnUserAboutWeakPin: Bool {
        if issues.contains(.pinFormatError) {
            return false
        } else if pinLength <= 4 { // future proofing in case we would evaluate short PINs.
            return issues.contains(.frequentlyUsed) || issues.contains(.notUnique)
        } else if pinLength <= 6 {
            return issues.contains(.frequentlyUsed) || issues.contains(.notUnique) || issues.contains(.repeatingCharacters)
        } else {
            return issues.contains(.frequentlyUsed) || issues.contains(.notUnique) || issues.contains(.repeatingCharacters) || issues.contains(.patternFound)
        }
    }
}

/// Problem with tested PIN.
public struct PinTestIssue: OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    /// Not enough unique digits found
    public static let notUnique = PinTestIssue(rawValue: 1 << 1)
    /// Too much repeating characters
    public static let repeatingCharacters = PinTestIssue(rawValue: 1 << 2)
    /// There is a pattern in this pin (for example 1357)
    public static let patternFound = PinTestIssue(rawValue: 1 << 3)
    /// Tested pin could be date (for example 2512 as birthday - 25th of december)
    public static let possiblyDate = PinTestIssue(rawValue: 1 << 4)
    /// Tested pin is in TOP used pins (like 1234 as number 1 used pin)
    public static let frequentlyUsed = PinTestIssue(rawValue: 1 << 5)
    /// PIN contains non-digit characters or is too short (under 4 digits)
    public static let pinFormatError = PinTestIssue(rawValue: 1 << 6)
}

/// Result of password strength test
public enum PasswordStrength {
    case veryWeak
    case weak
    case moderate
    case good
    case strong
    
    fileprivate init(_ score: WPM_PasswordResult) {
        switch score {
        case WPM_PasswordResult_WrongInput: self = .veryWeak
        case WPM_PasswordResult_VeryWeak: self = .veryWeak
        case WPM_PasswordResult_Weak: self = .weak
        case WPM_PasswordResult_Moderate: self = .moderate
        case WPM_PasswordResult_Good: self = .good
        case WPM_PasswordResult_Strong: self = .strong
        default: fatalError("Uncovered password check case", file: "PasswordTester.swift")
        }
    }
}
