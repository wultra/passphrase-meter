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

// "__USE_BDS" makes funopen() function visible. The define must be set before the first system
// header is included, otherwise the configuration is ignored.
#define __USE_BSD
#include <stdio.h>
#include "android_file.h"
#include <errno.h>

static int android_read(void* cookie, char* buf, int size)
{
	if (!cookie || !buf) {
		errno = EFAULT;
		return -1;
	}
    return AAsset_read((AAsset*)cookie, buf, size);
}

static int android_write(void * cookie, const char* buf, int size)
{
    // can't provide write access
    errno = EACCES;
	return -1;
}

static fpos_t android_seek(void * cookie, fpos_t offset, int whence)
{
	if (!cookie) {
		errno = EFAULT;
		return -1;
	}
    return AAsset_seek((AAsset*)cookie, offset, whence);
}

static int android_close(void * cookie)
{
	if (!cookie) {
		errno = EFAULT;
		return -1;
	}
    AAsset_close((AAsset*)cookie);
    return 0;
}

FILE * android_fopen(AAssetManager* manager, const char* filename, const char* mode)
{
    if (!manager || !filename || !mode) {
        errno = EFAULT;
        return NULL;
    }
    if (mode[0] == 'w' || mode[0] == 'a') {
    	// can't write or append to the file
        errno = EACCES;
        return NULL;
    }
    
    AAsset* asset = AAssetManager_open(manager, filename, 0);
    if(!asset) {
        return NULL;
    }
    
    return funopen(asset, android_read, android_write, android_seek, android_close);
}

