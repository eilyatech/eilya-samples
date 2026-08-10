plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.eilyatech.sample"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.eilyatech.sample"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"

        val otpApiKey = providers.gradleProperty("EILYA_OTP_API_KEY")
            .orElse(providers.environmentVariable("EILYA_OTP_API_KEY"))
            .orElse("ek_test_${"0".repeat(48)}")
            .get()
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
        val chatEmbedToken = providers.gradleProperty("EILYA_CHAT_EMBED_TOKEN")
            .orElse(providers.environmentVariable("EILYA_CHAT_EMBED_TOKEN"))
            .orElse("ew_${"0".repeat(48)}")
            .get()
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
        buildConfigField("String", "EILYA_OTP_API_KEY", "\"$otpApiKey\"")
        buildConfigField("String", "EILYA_CHAT_EMBED_TOKEN", "\"$chatEmbedToken\"")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    buildFeatures {
        viewBinding = true
        buildConfig = true
    }
}

repositories {
    google()
    mavenCentral()
}

dependencies {
    // Eilya SDKs
    implementation("com.eilyatech:eilya-otp-android:1.0.0")
    implementation("com.eilyatech:eilya-chat-android:1.1.0")

    // Android
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
}
