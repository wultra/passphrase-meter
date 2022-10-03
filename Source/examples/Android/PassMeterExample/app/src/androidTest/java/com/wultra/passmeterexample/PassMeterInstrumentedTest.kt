package com.wultra.passmeterexample

import android.support.test.InstrumentationRegistry
import android.support.test.runner.AndroidJUnit4
import com.wultra.android.passphrasemeter.*
import com.wultra.android.passphrasemeter.exceptions.*

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
        assertTrue(PasswordTester.getInstance().loadDictionary(InstrumentationRegistry.getTargetContext().assets, "czsk.dct"))
        assertTrue(PasswordTester.getInstance().hasLoadedDictionary())
        PasswordTester.getInstance().freeLoadedDictionary()
        assertFalse(PasswordTester.getInstance().hasLoadedDictionary())
    }

    @Test(expected=WrongPinException::class)
    fun testWrongInputPin() {
        PasswordTester.getInstance().testPin("asdf")
    }

    @Test
    fun testPinIssues() {
        val frequent = PasswordTester.getInstance().testPin("1111")
        assertTrue(frequent.issues.contains(PinTestIssue.FREQUENTLY_USED))
        val pattern = PasswordTester.getInstance().testPin("1357")
        assertTrue(pattern.issues.contains(PinTestIssue.HAS_PATTERN))
        val date = PasswordTester.getInstance().testPin("1990")
        assertTrue(date.issues.contains(PinTestIssue.POSSIBLY_DATE))
        val unique = PasswordTester.getInstance().testPin("1112")
        assertTrue(unique.issues.contains(PinTestIssue.NOT_UNIQUE))
        val repeating = PasswordTester.getInstance().testPin("1111")
        assertTrue(repeating.issues.contains(PinTestIssue.REPEATING_CHARACTERS))
    }

    @Test
    fun testOKPin() {
        val result = PasswordTester.getInstance().testPin("9562")
        assertTrue(result.issues.isEmpty())
    }

    @Test
    fun testPinDates() {
        val dates = arrayOf("0304", "1012", "0101", "1998", "2005", "150990", "241065", "16021998", "03122001")
        val noDates = arrayOf("1313", "0028", "1287", "9752", "151590", "001297", "41121987")

        for (date in dates) {
            assertTrue(date, PasswordTester.getInstance().testPin(date).issues.contains(PinTestIssue.POSSIBLY_DATE))
        }

        for (nodate in noDates) {
            assertTrue(nodate, PasswordTester.getInstance().testPin(nodate).issues.contains(PinTestIssue.POSSIBLY_DATE) == false)
        }
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
            assertTrue(word, result == PasswordStrength.GOOD || result == PasswordStrength.STRONG)
        }

        PasswordTester.getInstance().loadDictionary(InstrumentationRegistry.getTargetContext().assets,"en.dct")

        for (word in words) {
            val result = PasswordTester.getInstance().testPassword(word)
            assertTrue(word, result == PasswordStrength.VERY_WEAK || result == PasswordStrength.WEAK)
        }

        PasswordTester.getInstance().freeLoadedDictionary()
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
            assertTrue(result == PasswordStrength.GOOD || result == PasswordStrength.STRONG)
        }

        PasswordTester.getInstance().loadDictionary(InstrumentationRegistry.getTargetContext().assets,"czsk.dct")

        for (word in words) {
            val result = PasswordTester.getInstance().testPassword(word)
            assertTrue(result == PasswordStrength.VERY_WEAK || result == PasswordStrength.WEAK)
        }

        PasswordTester.getInstance().freeLoadedDictionary()
    }

    @Test
    fun testPasswords()  {
        assertTrue(PasswordTester.getInstance().testPassword("qwerty") == PasswordStrength.WEAK) // keyboard pattern
        assertTrue(PasswordTester.getInstance().testPassword("12345678") == PasswordStrength.VERY_WEAK) // keyboard pattern
        assertTrue(PasswordTester.getInstance().testPassword("ap") == PasswordStrength.VERY_WEAK) // too short
        assertTrue(PasswordTester.getInstance().testPassword("apwu") == PasswordStrength.WEAK) // short
        assertTrue(PasswordTester.getInstance().testPassword("apwunb") == PasswordStrength.GOOD) // OK
        assertTrue(PasswordTester.getInstance().testPassword("ap,wu92nbSm;#/") == PasswordStrength.STRONG) // Strong
    }
}
