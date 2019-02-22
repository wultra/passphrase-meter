package com.wultra.passmeterexample

import android.support.test.InstrumentationRegistry
import android.support.test.runner.AndroidJUnit4
import com.wultra.android.passwordtester.PasswordStrength
import com.wultra.android.passwordtester.PasswordTester
import com.wultra.android.passwordtester.PinTestResult
import com.wultra.android.passwordtester.exceptions.WrongPinException

import org.junit.Test
import org.junit.runner.RunWith

import org.junit.Assert.*

/**
 * Instrumented test, which will execute on an Android device.
 */
@RunWith(AndroidJUnit4::class)
class PassMeterInstrumentedTest {

    @Test
    fun testLibraryLoad() {
        assertFalse(PasswordTester.getInstance().hasLoadedDictionary())
        PasswordTester.getInstance().loadDictionary(InstrumentationRegistry.getTargetContext().assets, "czsk")
        assert(PasswordTester.getInstance().hasLoadedDictionary())
        PasswordTester.getInstance().freeLoadedDictionary()
        assertFalse(PasswordTester.getInstance().hasLoadedDictionary())
    }

    @Test
    fun testWrongInputPin() {
        try {
            PasswordTester.getInstance().testPin("asdf")
            fail()
        } catch (e: WrongPinException) {
            assert(true)
        }
    }

    @Test
    fun testPinIssues() {
        val frequent = PasswordTester.getInstance().testPin("1111")
        assert(frequent.contains(PinTestResult.FREQUENTLY_USED))
        val pattern = PasswordTester.getInstance().testPin("1357")
        assert(pattern.contains(PinTestResult.HAS_PATTERN))
        val date = PasswordTester.getInstance().testPin("1990")
        assert(date.contains(PinTestResult.POSSIBLY_DATE))
        val unique = PasswordTester.getInstance().testPin("1112")
        assert(unique.contains(PinTestResult.NOT_UNIQUE))
        val repeating = PasswordTester.getInstance().testPin("1111")
        assert(repeating.contains(PinTestResult.REPEATING_CHARACTERS))
    }

    @Test
    fun testOKPin() {
        val pin = PasswordTester.getInstance().testPin("9562")
        assert(pin.isEmpty())
    }

    @Test
    fun testEnglishDictionary() {

        val words = arrayOf(
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
        )

        for (word in words) {
            val result = PasswordTester.getInstance().testPassword(word)
            assert(result == PasswordStrength.GOOD || result == PasswordStrength.STRONG)
        }

        PasswordTester.getInstance().loadDictionary(InstrumentationRegistry.getTargetContext().assets,"czsk.dct")

        for (word in words) {
            val result = PasswordTester.getInstance().testPassword(word)
            assert(result == PasswordStrength.VERY_WEAK || result == PasswordStrength.WEAK)
        }
    }

    @Test
    fun testCzskDictionary() {

        val words = arrayOf(
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
        )

        for (word in words) {
            val result = PasswordTester.getInstance().testPassword(word)
            assert(result == PasswordStrength.GOOD || result == PasswordStrength.STRONG)
        }

        PasswordTester.getInstance().loadDictionary(InstrumentationRegistry.getTargetContext().assets,"czsk.dct")

        for (word in words) {
            val result = PasswordTester.getInstance().testPassword(word)
            assert(result == PasswordStrength.VERY_WEAK || result == PasswordStrength.WEAK)
        }
    }

    @Test
    fun testPasswords()  {
        assert(PasswordTester.getInstance().testPassword("qwerty") == PasswordStrength.WEAK) // keyboard pattern
        assert(PasswordTester.getInstance().testPassword("12345678") == PasswordStrength.VERY_WEAK) // keyboard pattern
        assert(PasswordTester.getInstance().testPassword("ap") == PasswordStrength.VERY_WEAK) // too short
        assert(PasswordTester.getInstance().testPassword("apwu") == PasswordStrength.WEAK) // short
        assert(PasswordTester.getInstance().testPassword("apwunb") == PasswordStrength.GOOD) // OK
        assert(PasswordTester.getInstance().testPassword("ap,wu92nbSm;#/") == PasswordStrength.STRONG) // Strong
    }
}
