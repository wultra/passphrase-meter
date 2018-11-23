#include <jni.h>
#include <string>
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include "../../../src_native/wultra_pass_meter.h"

extern "C" {

    JNIEXPORT void JNICALL Java_com_wultra_utils_StrengthTester_init(JNIEnv *jenv, jobject self, jobject manager, jstring dictionaryAsset) {
        if (dictionaryAsset != NULL && manager != NULL) {

            jobject globalManager = jenv->NewGlobalRef(manager);
            AAssetManager* manager = AAssetManager_fromJava(jenv, globalManager);

            const char *nativeString = jenv->GetStringUTFChars(dictionaryAsset, JNI_FALSE);

            WPM_setPasswordDictionary(nativeString, manager);

            jenv->ReleaseStringUTFChars(dictionaryAsset, nativeString);
        }
    }

    JNIEXPORT void JNICALL Java_com_wultra_utils_StrengthTester_deinit(JNIEnv *jenv, jobject self) {
        WPM_freePasswordDictionary();
    }

    JNIEXPORT jint JNICALL Java_com_wultra_utils_StrengthTester_testPasswordJNI(JNIEnv *jenv, jobject self, jstring password) {
        const char *nativeString = jenv->GetStringUTFChars(password, JNI_FALSE);
        const WPM_password_check_score result = WPM_testPassword(nativeString);
        jenv->ReleaseStringUTFChars(password, nativeString);
        return result;
    }

    JNIEXPORT jint JNICALL Java_com_wultra_utils_StrengthTester_testPinJNI(JNIEnv *jenv, jobject self, jstring pin) {
        const char *nativeString = jenv->GetStringUTFChars(pin, JNI_FALSE);
        const WPM_passcode_result_flags result = WPM_testPasscode(nativeString);
        jenv->ReleaseStringUTFChars(pin, nativeString);
        return result;
    }
}
