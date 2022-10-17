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


#define TAG "JNI TEST PASS"
JNIEXPORT jint JNICALL Java_com_wultra_android_passphrasemeter_PasswordTester_testPasswordJNI(JNIEnv *jenv, jobject self,
                                                                                                  jobject buffer, jint length)
{
    jint result = WPM_PasscodeResult_WrongInput;
    char* pw_buf = (char*) jenv->GetDirectBufferAddress(buffer);

    if (pw_buf != NULL) {
        result = WPM_testPassword(pw_buf);
        for(int i = 0; i < length; i++) {
            *(pw_buf + i) = 0;
        }
    }
    return result;
}

JNIEXPORT jint JNICALL Java_com_wultra_android_passphrasemeter_PasswordTester_testPinJNI(JNIEnv *jenv, jobject self,
                                                                                             jobject buffer, jint length)
{
    char* pin_buf = (char*) jenv->GetDirectBufferAddress(buffer);
    jint result;

    if (pin_buf) {
        result = WPM_testPasscode(pin_buf);
        for(int i = 0; i < length; i++) {
            *(pin_buf + i) = 0;
        }
    } else {
        result = WPM_PasscodeResult_WrongInput;
    }
    return result;
}

} // extern "C"
