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

#ifndef wultra_pass_meter_h
#define wultra_pass_meter_h

#include <stdio.h>
#include <stdbool.h>
#include "wpm_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 Checks, if the passcode has any possible issues in it.

 @param passcode String with the passcode (needs to be degits only)
 @return Returns issues found in the passcode
*/
WPM_PasscodeResult WPM_testPasscode(const char * passcode);

#ifdef ANDROID
/* AAssetManager forward declaration */
struct AAssetManager;
typedef struct AAssetManager AAssetManager;

/**
 Sets dictionary with poorly rated words. When dictionary is no longer needed, call `WPM_freePasswordDictionary` to free resources

 @param assetName Name of the asset with password 'blacklist' dictionary.
 @param manager Asset manager where the asset is stored
 @return true if dictionary is set successfully
 */
bool WPM_setPasswordDictionary(AAssetManager *manager, const char * assetName);
#else
/**
 Sets dictionary with poorly rated words. When dictionary is no longer needed, call `WPM_freePasswordDictionary` to free resources

 @param dictionary Path to the password 'blacklist' dictionary.
 @return true if dictionary is set successfully
 */
bool WPM_setPasswordDictionary(const char * dictionary);
#endif

/**
 Free resources needed for password classification
 */
void WPM_freePasswordDictionary(void);
	
/**
 Returns true if dictionary for passwords is loaded.
 */
bool WPM_hasPasswordDictionary(void);

/**
 Returns strength of the given password
 
 @param password Passwords that you want to classify
 @return Strength classification
 */
WPM_PasswordResult WPM_testPassword(const char * password);

#ifdef __cplusplus
}
#endif
    
#endif /* wultra_pass_meter_h */
