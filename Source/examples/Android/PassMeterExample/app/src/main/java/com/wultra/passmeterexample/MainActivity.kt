package com.wultra.passmeterexample

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.annotation.WorkerThread
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import android.widget.*
import com.wultra.android.passphrasemeter.*
import com.wultra.android.passphrasemeter.exceptions.*

class MainActivity : AppCompatActivity() {

    private val input: EditText by lazy { findViewById(R.id.input) }
    private val passStrength: TextView by lazy { findViewById(R.id.strengthText) }
    private val pinIssues: TextView by lazy { findViewById(R.id.issuesText) }
    private val warningText: TextView by lazy { findViewById(R.id.warning) }
    private val dropdown: Spinner by lazy { findViewById(R.id.dropdown) }

    private val languages = arrayOf(
        Language("English", "en.dct"),
        Language("Czech & Slovak", "czsk.dct"),
        Language("Romanian", "ro.dct")
    )

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        input.addTextChangedListener(object: TextWatcher {
            override fun afterTextChanged(s: Editable) {
                processText(s.toString())
            }
            override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) { }
            override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) { }
        })

        dropdown.adapter = ArrayAdapter(this, android.R.layout.simple_spinner_dropdown_item, languages)
        dropdown.onItemSelectedListener = object: AdapterView.OnItemSelectedListener {
            override fun onItemSelected(adapter: AdapterView<*>?, view: View?, position: Int, id: Long) {
                prepareLanguage(languages[position])
            }

            override fun onNothingSelected(p0: AdapterView<*>?) { }
        }
        dropdown.setSelection(0) // select first item
    }

    @WorkerThread
    private fun prepareLanguage(language: Language) {
        if (PasswordTester.getInstance().hasLoadedDictionary()) {
            PasswordTester.getInstance().freeLoadedDictionary()
        }
        PasswordTester.getInstance().loadDictionary(assets, language.dictionaryAsset)
        input.setText("")
    }

    private fun processText(text: String) {
        processPassword(text)
        processPin(text)
    }

    private fun processPassword(password: String) {

        val text: String

        if (password.isNotEmpty()) {

            text = try {

                when (PasswordTester.getInstance().testPassword(password)) {
                    PasswordStrength.STRONG -> "Strong 💪"
                    PasswordStrength.GOOD -> "Good 👍"
                    PasswordStrength.MODERATE -> "Moderate 🤔"
                    PasswordStrength.WEAK -> "Weak 🙄"
                    PasswordStrength.VERY_WEAK, null -> "Very Weak 🤦‍"
                }
            } catch (e: WrongPasswordException) {
                "Password format exception"
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

                warnUser = if (pin.length == 4) {
                    result.contains(PinTestResult.FREQUENTLY_USED) || result.contains(PinTestResult.NOT_UNIQUE)
                } else if (pin.length <= 6) {
                    result.contains(PinTestResult.FREQUENTLY_USED) || result.contains(PinTestResult.NOT_UNIQUE) || result.contains(PinTestResult.REPEATING_CHARACTERS)
                } else {
                    result.contains(PinTestResult.FREQUENTLY_USED) || result.contains(PinTestResult.NOT_UNIQUE) || result.contains(PinTestResult.REPEATING_CHARACTERS) || result.contains(PinTestResult.HAS_PATTERN)
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
        return text.isNotEmpty() && text.all { "0987654321".contains(it) }
    }

    data class Language(val name: String, val dictionaryAsset: String) {
        override fun toString(): String {
            return name
        }
    }
}
