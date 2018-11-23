LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
NDK_TOOLCHAIN_VERSION := clang
LOCAL_MODULE := libStrengthTester
LOCAL_C_INCLUDES += ../../../src_native/
LOCAL_SRC_FILES :=  ../../../src_native/zxcvbn.c \
                    ../../../src_native/wultra_pass_meter.c \
				    ../cpp/StrengthTester.cpp
LOCAL_CFLAGS := -DANDROID $(LOCAL_CFLAGS)
LOCAL_CPPFLAGS := $(EXTERN_CFLAGS) -std=c++11
LOCAL_LDLIBS += -landroid
LOCAL_LDLIBS += -llog
include $(BUILD_SHARED_LIBRARY)