plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.varnika_app"
    // Note: compileSdk 36 is very new; ensure your build tools are updated.
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.varnika_app"
        minSdk = 24 // FFmpeg usually requires at least 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

    }


    buildTypes {
        getByName("debug") {
            isMinifyEnabled = false
        }
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Fixed Dependency Resolution for Kotlin DSL
configurations.all {
    resolutionStrategy.eachDependency {
        if (requested.group == "com.arthenica" && requested.name.contains("ffmpeg-kit")) {
            useVersion("6.0")
        }
    }
}