package com.wultra.utils;

import android.content.res.AssetManager;
import android.support.annotation.Nullable;

import java.util.EnumSet;

/**
 *  Class that provides methods for testing strength of passwords and PINs. Only once instance can be created at once!
 */
public class StrengthTester {

    static {
        System.loadLibrary("StrengthTester");
    }

    private native int init(AssetManager manager, String dictionaryAsset);
    private native int deinit();

    private native int testPasswordJNI(String password);
    private native int testPinJNI(String password);

    private static StrengthTester instance;

    /**
     * Creates instance. Note that only one instance can created, otherwise exception will be thrown.
     * @param manager Asset manager where asset is present
     * @param dictionaryAsset name of the language dictionary in asset manager
     */
    public StrengthTester(@Nullable AssetManager manager, @Nullable String dictionaryAsset) throws SingleInstanceExteption {

        if (instance != null) {
            throw new SingleInstanceExteption();
        }

        init(manager, dictionaryAsset);
        instance = this;
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        freeDictionary();
    }

    /**
     * Releases dictionary. Call this when instance is no longer needed.
     */
    public void freeDictionary() {
        deinit();
    }

    /**
     * Tests strength of the password. Result can ne affected by dictionary given in construtor.
     * @param password Password to test
     * @return Strength of the password
     */
    public PasswordStrength testPassword(String password) {
        switch (testPasswordJNI(password)) {
            case 0: return PasswordStrength.VERY_WEAK;
            case 1: return PasswordStrength.WEAK;
            case 2: return PasswordStrength.MODERATE;
            case 3: return PasswordStrength.GOOD;
            default: return PasswordStrength.STRONG;
        }
    }

    /**
     * Scans PIN for possible issues.
     * @param pin PIN to scan.
     * @return Set of issues.
     */
    public EnumSet<PinResultFlag> testPin(String pin) {

        int result = testPinJNI(pin);

        EnumSet<PinResultFlag> set = EnumSet.noneOf(PinResultFlag.class);

        if ((result & 1) != 0) {
            set.add(PinResultFlag.OK);
        }

        if ((result & 2) != 0) {
            set.add(PinResultFlag.NOT_UNIQUE);
        }

        if ((result & 4) != 0) {
            set.add(PinResultFlag.REPEATING_CHARACTERS);
        }

        if ((result & 8) != 0) {
            set.add(PinResultFlag.HAS_PATTERN);
        }

        if ((result & 16) != 0) {
            set.add(PinResultFlag.POSSIBLY_DATE);
        }

        if ((result & 32) != 0) {
            set.add(PinResultFlag.FREQUENTLY_USED);
        }

        return set;
    }

    /**
     * Result of PIN testing
     */
    public enum PinResultFlag {
        /**
         * Passcode is OK, no issues found
         */
        OK,
        /**
         * Passcode doesn't have enough unique digits
         */
        NOT_UNIQUE,
        /**
         * There is significant amount of repeating characters in the passcode
         */
        REPEATING_CHARACTERS,
        /**
         * Repeating pattern was found in the passcode
         */
        HAS_PATTERN,
        /**
         * This passcode can be date (and possible birthday of the user)
         */
        POSSIBLY_DATE,
        /**
         * Passcode is in most used passcodes
         */
        FREQUENTLY_USED
    }

    /**
     * Result of password strength test
     */
    public enum PasswordStrength {
        VERY_WEAK,
        WEAK,
        MODERATE,
        GOOD,
        STRONG
    }

    public static class SingleInstanceExteption extends Exception {

    }
}