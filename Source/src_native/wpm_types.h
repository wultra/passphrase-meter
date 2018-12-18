/**
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

#ifndef wultra_wpm_types_h
#define wultra_wpm_types_h

#ifdef __cplusplus
extern "C" {
#endif

/// Result of WPM_testPasscode function that can result with multiple issues.
typedef enum _WPM_passcode_result_flags {
    /// Passcode is OK, no issues found
    OK_WPM                   = 1 << 0,
    /// Passcode doesn't have enough unique digits
    NOT_UNIQUE_WPM           = 1 << 1,
    /// There is significant amount of repeating characters in the passcode
    REPEATING_CHARACTERS_WPM = 1 << 2,
    /// Repeating pattern was found in the passcode
    HAS_PATTERN_WPM          = 1 << 3,
    /// This passcode can be date (and possible birthday of the user)
    POSSIBLY_DATE_WPM        = 1 << 4,
    /// Passcode is in most used passcodes
    FREQUENTLY_USED_WPM      = 1 << 5,
    /// Wrong input
    WRONG_INPUT_PIN_WPM      = 1 << 6
    
} WPM_passcode_result_flags;

/// Classification of the password strength
typedef enum _WPM_password_check_score {
    VERY_WEAK_PASSWORD_SCORE_WPM = 0,
    WEAK_PASSWORD_SCORE_WPM      = 1,
    MODERATE_PASSWORD_SCORE_WPM  = 2,
    GOOD_PASSWORD_SCORE_WPM      = 3,
    STRONG_PASSWORD_SCORE_WPM    = 4,
	WRONG_INPUT_PASSWORD_WPM     = 5,
} WPM_password_check_score;

#ifdef __cplusplus
}
#endif
    
#endif /* wultra_wpm_types_h */
