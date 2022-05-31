/*
 * Copyright 2022 Wultra s.r.o.
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
 * See the License for the specific language governing permissions
 * and limitations under the License.
 */

plugins {
    id("com.android.library")
    id("kotlin-android")
}

android {

    compileSdk = Constants.compileSdkVersion

    defaultConfig {
        minSdk = Constants.minSdkVersion
        targetSdk = Constants.targetSdkVersion

        vectorDrawables.useSupportLibrary = true

        externalNativeBuild {
            ndkBuild {
                abiFilters("armeabi-v7a", "arm64-v8a", "x86", "x86_64")
            }
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    dependencies {
        implementation("com.android.support:support-annotations:28.0.0")
    }

    sourceSets["main"].jniLibs.srcDirs("libs")
    //sourceSets["main"].jni.srcDirs("")

    buildTypes {
        getByName("release") {
            consumerProguardFiles("proguard-rules.pro")
        }
    }

    externalNativeBuild {
        ndkBuild {
            path = File("${projectDir}/jni/Android.mk")
        }
    }

    lint {
        checkDependencies = true
    }
}

apply("../android-release-aar.gradle")