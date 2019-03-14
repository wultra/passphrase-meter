/*
 * Copyright 2018 Wultra s.r.o.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.wultra.android.passphrasemeter;

/**
 * Result of PIN testing
 */
public enum PinTestResult {
    /**
     * PIN doesn't have enough unique digits
     */
    NOT_UNIQUE,
    /**
     * There is significant amount of repeating characters in the PIN
     */
    REPEATING_CHARACTERS,
    /**
     * Repeating pattern was found in the PIN
     */
    HAS_PATTERN,
    /**
     * This PIN can be date (and possible birthday of the user)
     */
    POSSIBLY_DATE,
    /**
     * PIN is in database of the most used PINs
     */
    FREQUENTLY_USED
}
