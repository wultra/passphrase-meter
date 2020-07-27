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

#if !defined(ANDROID)
#error "Available only for Android platform"
#endif

#include <jni.h>
#include <string>
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include "wultra_pass_meter.h"

extern "C" {
	
// Java package : com.wultra.android.passphrasemeter
// Java class   : PasswordTester

JNIEXPORT jboolean JNICALL Java_com_wultra_android_passphrasemeter_PasswordTester_loadDictionary(JNIEnv *jenv, jobject self, jobject manager, jstring dictionaryAsset)
{
    bool result = false;
    if (dictionaryAsset != NULL &&  manager != NULL) {
        // Get CPP objects from parameters
        AAssetManager * cppManager = AAssetManager_fromJava(jenv, manager);
        const char *cppDictionaryAsset = jenv->GetStringUTFChars(dictionaryAsset, JNI_FALSE);
        if (cppDictionaryAsset != NULL && cppManager != NULL) {
            // Load dictionary
            result = WPM_setPasswordDictionary(cppManager, cppDictionaryAsset);
            jenv->ReleaseStringUTFChars(dictionaryAsset, cppDictionaryAsset);
        }
    }
    return (jboolean) result;
}

JNIEXPORT void JNICALL Java_com_wultra_android_passphrasemeter_PasswordTester_freeLoadedDictionary(JNIEnv *jenv, jobject self)
{
    WPM_freePasswordDictionary();
}

JNIEXPORT jboolean JNICALL Java_com_wultra_android_passphrasemeter_PasswordTester_hasLoadedDictionary(JNIEnv *jenv, jobject self)
{
    return (jboolean) WPM_hasPasswordDictionary();
}


JNIEXPORT jint JNICALL Java_com_wultra_android_passphrasemeter_PasswordTester_testPasswordJNI(JNIEnv *jenv, jobject self, jstring password)
{
    jint result = WPM_PasscodeResult_WrongInput;
    if (password != NULL) {
        const char * cppPassword = jenv->GetStringUTFChars(password, JNI_FALSE);
        if (cppPassword != NULL) {
            result = WPM_testPassword(cppPassword);
            jenv->ReleaseStringUTFChars(password, cppPassword);
        }
    }
    return result;
}

JNIEXPORT jint JNICALL Java_com_wultra_android_passphrasemeter_PasswordTester_testPinJNI(JNIEnv *jenv, jobject self, jstring pin)
{
    const char * cppPin = jenv->GetStringUTFChars(pin, JNI_FALSE);
    jint result;
    if (cppPin) {
        result = WPM_testPasscode(cppPin);
        jenv->ReleaseStringUTFChars(pin, cppPin);
    } else {
        result = WPM_PasscodeResult_WrongInput;
    }
    return result;
}

} // extern "C"
