plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.narau"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.narau"
        minSdk = 26                             // ← set API 21 minimum :contentReference[oaicite:7]{index=7}
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Prevent .tflite (and .lite) from being compressed in the APK
    androidResources {
        noCompress += "tflite"                  // your TFLite model :contentReference[oaicite:8]{index=8}
        noCompress += "lite"                    // TFLite runtime files (optional) :contentReference[oaicite:9]{index=9}
    }
}

flutter {
    source = "../.."
}
