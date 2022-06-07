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

import java.util.Set;

/**
 * Result of the PIN test
 */
public class PinTestResult {

    private final String pin;
    private final Set<PinTestIssue> issues;

    public PinTestResult(String pin, Set<PinTestIssue> issues) {
        this.pin = pin;
        this.issues = issues;
    }

    /**
     * Issues with the tested PIN.
     * @return set of issues
     */
    public Set<PinTestIssue> getIssues() {
        return issues;
    }

    /**
     * Originally tested PIN.
     * @return tested PIN.
     */
    public String getPin() {
        return pin;
    }

    /**
     * If the user should be warned that the PIN is weak. Be aware that this property is just a hint based on simple
     * rules explained below. Consider implementing your own logic.
     * <br><br>
     *
     * <table>
     *  <caption>List of returned values</caption>
     *  <tr>
     *     <th>PIN&nbsp;length</th><th>Returns true when</th>
     *  </tr>
     *   <tr>
     *     <td>&lt; 4</td><td>never</td>
     *   </tr>
     *   <tr>
     *     <td>4</td><td>FREQUENTLY_USED or NOT_UNIQUE</td>
     *   </tr>
     *   <tr>
     *      <td>5,6</td><td>FREQUENTLY_USED or NOT_UNIQUE or REPEATING_CHARACTERS</td>
     *   </tr>
     *   <tr>
     *      <td>6+</td><td>FREQUENTLY_USED or NOT_UNIQUE or REPEATING_CHARACTERS or HAS_PATTERN</td>
     *   </tr>
     * </table>
     *
     * @return If the user should be warned that the pin is weak.
     */
    public boolean shouldWarnUserAboutWeakPin() {
        if (this.pin.length() <= 4) { // future proofing in case we would evaluate short PINs.
            return issues.contains(PinTestIssue.FREQUENTLY_USED) || issues.contains(PinTestIssue.NOT_UNIQUE);
        } else if (this.pin.length() <= 6) {
            return issues.contains(PinTestIssue.FREQUENTLY_USED) || issues.contains(PinTestIssue.NOT_UNIQUE) || issues.contains(PinTestIssue.REPEATING_CHARACTERS);
        } else {
            return issues.contains(PinTestIssue.FREQUENTLY_USED) || issues.contains(PinTestIssue.NOT_UNIQUE) || issues.contains(PinTestIssue.REPEATING_CHARACTERS) || issues.contains(PinTestIssue.HAS_PATTERN);
        }
    }
}