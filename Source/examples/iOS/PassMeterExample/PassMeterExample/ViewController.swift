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

import UIKit
import WultraPassphraseMeter

class ViewController: UIViewController {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var pinLabel: UILabel!
    @IBOutlet private weak var passwordHeader: UILabel!
    @IBOutlet private weak var pinHeader: UILabel!
    @IBOutlet private weak var pinWarning: UILabel!
    @IBOutlet private weak var languageButton: UIButton!
    
    private var queue: OperationQueue =  {
       let q = OperationQueue()
        q.name = "PassMeterQueue"
        q.maxConcurrentOperationCount = 1
        return q
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectLanguage(.en)
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        languageButton.addTarget(self, action: #selector(languageButtonTaped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // When screns will appear, load english dictionary
        // Only one dictionary can be loaded
        PasswordTester.shared.loadDictionary(.en)
        processText("")
        textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Free the memory
        PasswordTester.shared.freeLoadedDictionary()
    }
    
    @objc private func languageButtonTaped() {
        let v = UIAlertController(title: "Select language", message: nil, preferredStyle: .actionSheet)
        
        for l in Language.all {
            v.addAction(UIAlertAction(title: l.name, style: .default, handler: { _ in
                self.selectLanguage(l)
            }))
        }
        present(v, animated: true)
    }
    
    @objc private func textDidChange() {
        processText(textField.text ?? "")
    }
    
    private func processText(_ text: String) {
        // if user types too fast, cancel waiting operations and add new one
        queue.cancelAllOperations()
        queue.addOperation {
            self.processPin(text)
            self.processPassword(text)
        }
    }
    
    private func processPassword(_ password: String) {
        
        let text: String
        
        if password.count > 0 {
            let result = PasswordTester.shared.testPassword(password)
            
            switch result {
            case .strong: text = "Strong 💪"
            case .good: text = "Good 👍"
            case .moderate: text = "Moderate 🤔"
            case .weak: text = "Weak 🙄"
            case .veryWeak: text = "Very Weak 🤦‍♂️"
            }
        } else {
            text = "Type some text 🙏"
        }
        
        runOnMain {
            self.passwordLabel.text = text
        }
    }
    
    private func processPin(_ pin: String) {
        
        var text = ""
        var warnUser = false
        
        if pin.count < 4 {
            
            text = "PIN has to be at least 4 characters long"
            
        } else if isPin(pin) {
            let result = PasswordTester.shared.testPin(pin)
            
            if result.isEmpty {
                text += "Good pin 👍"
            } else {
                if result.contains(.frequentlyUsed) {
                    text += "- frequently used\n"
                }
                if result.contains(.notUnique) {
                    text += "- not enough unique characters\n"
                }
                if result.contains(.patternFound) {
                    text += "- repeating pattern\n"
                }
                if result.contains(.possiblyDate) {
                    text += "- could be a date\n"
                }
                if result.contains(.repeatingCharacters) {
                    text += "- too much repeating characters\n"
                }
                if result.contains(.pinFormatError) {
                    text = "- format error!"
                }
            }
            
            // We want to warn the user only in some cases. Otherwise, we could eliminate too much pin codes and that could be anoying
            
            if pin.count == 4 {
                warnUser = result.contains(.frequentlyUsed) || result.contains(.notUnique)
            } else if pin.count <= 6 {
                warnUser = result.contains(.frequentlyUsed) || result.contains(.notUnique) || result.contains(.repeatingCharacters)
            } else {
                warnUser = result.contains(.frequentlyUsed) || result.contains(.notUnique) || result.contains(.repeatingCharacters) || result.contains(.patternFound)
            }
            
        } else {
            
            text = "Not a PIN"
            
        }
        
        runOnMain {
            self.pinWarning.isHidden = !warnUser
            self.pinLabel.text = text
        }
    }
    
    private func isPin(_ text: String) -> Bool {
        guard text.isEmpty == false else {
            return false
        }
        return text.allSatisfy({ "0987654321".contains($0) })
    }
    
    private func selectLanguage(_ l: Language) {
        languageButton.setTitle("Language selected: \(l.name)", for: .normal)
        textField.text = ""
        processPin("")
        processPassword("")
        if PasswordTester.shared.hasLoadedDictionary {
            PasswordTester.shared.freeLoadedDictionary()
        }
        
        PasswordTester.shared.loadDictionary(l.dictionary)
    }
    
    private struct Language {
        
        static let all = [en, czsk, ro, ru]
        
        static let en = Language(name: "English", dictionary: .en)
        static let czsk = Language(name: "Czech & Slovak", dictionary: .czsk)
        static let ro = Language(name: "Romanian", dictionary: .ro)
        static let ru = Language(name: "Russian", dictionary: .ru)
        
        let name: String
        let dictionary: PasswordTesterDictionary
    }
}

private func runOnMain(_ closure: @escaping () -> Void) {
    if OperationQueue.current == .main {
        closure()
    } else {
        OperationQueue.main.addOperation {
            closure()
        }
    }
}
