package com.wultra.passmeterexample

import android.content.res.AssetManager
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.widget.EditText
import android.widget.TextView
import com.wultra.android.passwordtester.PasswordStrength
import com.wultra.android.passwordtester.PasswordTester
import com.wultra.android.passwordtester.PinTestResult
import com.wultra.android.passwordtester.exceptions.WrongPasswordException
import com.wultra.android.passwordtester.exceptions.WrongPinException

class MainActivity : AppCompatActivity() {

    lateinit var input: EditText
    lateinit var passStrength: TextView
    lateinit var pinIssues: TextView
    lateinit var warningText: TextView

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        input = findViewById(R.id.input)
        passStrength = findViewById(R.id.strengthText)
        pinIssues = findViewById(R.id.issuesText)
        warningText = findViewById(R.id.warning)

        PasswordTester.getInstance().loadDictionary(assets, "en.dct")

        processText("")

        input.addTextChangedListener(object: TextWatcher {
            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {

            }

            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {

            }

            override fun afterTextChanged(s: Editable) {
                processText(s.toString())
            }
        })
    }

    private fun processText(text: String) {
        processPasssword(text)
        processPin(text)
    }

    private fun processPasssword(password: String) {

        var text: String

        if (password.isNotEmpty()) {

            try {

                val result = PasswordTester.getInstance().testPassword(password)

                when (result) {
                    PasswordStrength.STRONG -> text = "Strong 💪"
                    PasswordStrength.GOOD -> text = "Good 👍"
                    PasswordStrength.MODERATE -> text = "Moderate 🤔"
                    PasswordStrength.WEAK -> text = "Weak 🙄"
                    PasswordStrength.VERY_WEAK -> text = "Very Weak 🤦‍"
                }
            } catch (e: WrongPasswordException) {
                text = "Password format exception"
            }

        } else {
            text = "Type some text 🙏"
        }

        passStrength.text = text
    }

    private fun processPin(pin: String) {
        var text = ""
        var warnUser = false

        if (pin.length < 4) {
            text = "PIN has to be at least 4 characters long"
        } else if (isPin(pin)) {
            try {

                val result = PasswordTester.getInstance().testPin(pin)

                if (result.isEmpty()) {
                    text = "Good PIN 👍"
                } else {
                    if (result.contains(PinTestResult.FREQUENTLY_USED)) {
                        text += "- frequently used\n"
                    }
                    if (result.contains(PinTestResult.NOT_UNIQUE)) {
                        text += "- not enough unique characters\n"
                    }
                    if (result.contains(PinTestResult.HAS_PATTERN)) {
                        text += "- repeating pattern\n"
                    }
                    if (result.contains(PinTestResult.POSSIBLY_DATE)) {
                        text += "- could be a date\n"
                    }
                    if (result.contains(PinTestResult.REPEATING_CHARACTERS)) {
                        text += "- too much repeating characters\n"
                    }
                }

                if (pin.length == 4) {
                    warnUser = result.contains(PinTestResult.FREQUENTLY_USED) || result.contains(PinTestResult.NOT_UNIQUE)
                } else if (pin.length <= 6) {
                    warnUser = result.contains(PinTestResult.FREQUENTLY_USED) || result.contains(PinTestResult.NOT_UNIQUE) || result.contains(PinTestResult.REPEATING_CHARACTERS)
                } else {
                    warnUser = result.contains(PinTestResult.FREQUENTLY_USED) || result.contains(PinTestResult.NOT_UNIQUE) || result.contains(PinTestResult.REPEATING_CHARACTERS) || result.contains(PinTestResult.HAS_PATTERN)
                }

            } catch (e: WrongPinException) {
                text = "PIN format error"
            }
        } else {
            text = "Not a PIN"
        }

        warningText.visibility = if (warnUser) View.VISIBLE else View.INVISIBLE
        pinIssues.text = text
    }

    private fun isPin(text: String): Boolean {
        return text.isEmpty() == false && text.all { "0987654321".contains(it) }
    }
}
