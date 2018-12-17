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

#include "wultra_pass_meter.h"
#include "pin_tester.h"
#include "zxcvbn.h"

#pragma mark - PIN

WPM_passcode_result_flags WPM_testPasscode(const char *pin)
{
    return PinTester_testPasscode(pin);
}


#pragma mark - Password

WPM_password_check_score WPM_testPassword(const char *password)
{
    double e = ZxcvbnMatch(password, NULL, NULL);
    double log = e * 0.301029996;
    if (log < 3) return VERY_WEAK_PASSWORD_SCORE_WPM;
    if (log < 6) return WEAK_PASSWORD_SCORE_WPM;
    if (log < 8) return MODERATE_PASSWORD_SCORE_WPM;
    if (log < 10) return GOOD_PASSWORD_SCORE_WPM;
    return STRONG_PASSWORD_SCORE_WPM;
}

/**
 Contains true, if paswword dictionary is loaded
 */
static bool s_HasDictionary = false;

static bool WPM_setPasswordDictionaryFile(FILE * file);

void WPM_freePasswordDictionary()
{
    ZxcvbnUnInit();
	s_HasDictionary = false;
}

bool WPM_hasPasswordDictionary()
{
	return s_HasDictionary;
}

#if defined(ANDROID)
// Declaration of extern
extern FILE * android_fopen(AAssetManager* manager, const char* fname, const char* mode);
// Android version, needs to use custom file open routine.
bool WPM_setPasswordDictionary(AAssetManager *manager, const char * assetName)
{
    FILE * file = android_fopen(manager, assetName, "rb");
    return WPM_setPasswordDictionaryFile(file);
}
#else
// POSIX version can use fopen()
bool WPM_setPasswordDictionary(const char * dictionary)
{
    FILE * file = fopen(dictionary, "rb");
    return WPM_setPasswordDictionaryFile(file);
}
#endif

#pragma mark - Private

static bool WPM_setPasswordDictionaryFile(FILE * file)
{
    WPM_freePasswordDictionary();
    if (file) {
        s_HasDictionary = ZxcvbnInit(file) == 1;
        fclose(file);
    }
    return s_HasDictionary;
}
