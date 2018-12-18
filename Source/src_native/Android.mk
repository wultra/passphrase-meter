# -------------------------------------------------------------------------
# Copyright 2018 Wultra s.r.o.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# -------------------------------------------------------------------------

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
NDK_TOOLCHAIN_VERSION := clang
LOCAL_MODULE := libWultraPasswordTester

LOCAL_C_INCLUDES += . jni
		            
LOCAL_SRC_FILES  := zxcvbn.c \
                    pin_tester.c \
                    wultra_pass_meter.c \
                    jni/android_file.c \
                    jni/PasswordTester.cpp

LOCAL_CFLAGS	 := $(EXTERN_CFLAGS) -DANDROID
LOCAL_CPPFLAGS   := $(LOCAL_CFLAGS) -std=c++11
LOCAL_LDLIBS     += -landroid -llog

include $(BUILD_SHARED_LIBRARY)