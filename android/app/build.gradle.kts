plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle Plugin harus ditaruh setelah Android dan Kotlin plugin
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // kalau kamu pakai Firebase
}

android {
    namespace = "com.example.tangsugar"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.tangsugar"
        minSdk = 23
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true
    }

    buildTypes {
        getByName("release") {
            // sementara pakai debug key agar bisa jalan
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
