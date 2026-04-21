# Eilya SDK Samples

Sample apps demonstrating **Eilya OTP** and **Eilya Chat** SDKs across all platforms.

## Projects

| Directory | Platform | SDKs Used |
|-----------|----------|-----------|
| [`android/`](android/) | Android (Kotlin) | `com.eilyatech:eilya-otp-android:1.0.0` + `com.eilyatech:eilya-chat-android:1.0.0` |
| [`ios/`](ios/) | iOS (SwiftUI) | `EilyaOTP` + `EilyaChat` via Swift Package Manager |
| [`flutter/`](flutter/) | Flutter (Dart) | `eilya_otp: ^1.0.0` + `eilya_chat: ^1.0.0` |

## Getting Started

### 1. Get your API keys

- **OTP API key**: [otp.eilyatech.com](https://otp.eilyatech.com)
- **Chat API key**: [chat.eilyatech.com](https://chat.eilyatech.com)

### 2. Replace placeholder keys

In each sample app, find and replace:
- `ek_test_your_api_key_here` → your Eilya OTP API key
- `ec_test_your_api_key_here` → your Eilya Chat API key

### 3. Run

**Android:**
```bash
cd android
./gradlew installDebug
```

**iOS:**
```bash
cd ios
open Package.swift  # Opens in Xcode
# Build & Run
```

**Flutter:**
```bash
cd flutter
flutter pub get
flutter run
```

## SDK Documentation

- [Eilya OTP Docs](https://otp.eilyatech.com/docs)
- [Eilya Chat Docs](https://chat.eilyatech.com/docs)
- [eilyatech.com](https://eilyatech.com)

## SDK Installation

### Android (Maven Central)
```kotlin
dependencies {
    implementation("com.eilyatech:eilya-otp-android:1.0.0")
    implementation("com.eilyatech:eilya-chat-android:1.0.0")
}
```

### iOS (Swift Package Manager)
In Xcode → File → Add Package Dependencies:
- `https://github.com/MohsenAbdelkareem/eilya-otp` (version 1.0.0)
- `https://github.com/MohsenAbdelkareem/eilya-chat` (version 1.0.0)

### Flutter (pub.dev)
```yaml
dependencies:
  eilya_otp: ^1.0.0
  eilya_chat: ^1.0.0
```

## License

MIT License — Copyright (c) 2024 EilyaTech
