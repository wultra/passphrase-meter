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

#ifndef wultra_android_file_h
#define wultra_android_file_h

#if !defined(ANDROID)
#error "Available only for Android platform"
#endif

#include <android/asset_manager.h>
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif
/**
 * Opens asset in provided asset manager and returns FILE object.
 * Returns NULL if asset cannot be opened. In that case, the errno constant is set
 * to an appropriate error code.
 */
FILE * android_fopen(AAssetManager* manager, const char* filename, const char* mode);

#ifdef __cplusplus
}
#endif

#endif /* wultra_android_file_h */
