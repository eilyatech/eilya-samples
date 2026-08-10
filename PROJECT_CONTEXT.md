# Eilya Samples — Project Context

## Project purpose

`eilya-samples` provides small reference applications showing how to integrate Eilya OTP and Eilya Chat on Android, iOS, and Flutter. The examples cover SDK initialization, requesting and verifying an OTP, creating a chat session, and sending a chat message.

## Structure and technologies

- `android/`: Kotlin Android application using Gradle, AndroidX, View Binding, Eilya OTP `1.0.0`, and Eilya Chat `1.1.0`.
- `ios/`: SwiftUI executable Swift package targeting iOS 15+, using the two SDKs through Swift Package Manager.
- `flutter/`: Dart/Flutter application using `eilya_otp ^1.0.0` and `eilya_chat ^1.1.0`.
- `README.md`: cross-platform setup and credential instructions.

## Running and developing

Credentials must be supplied externally. Client applications may use an OTP public API key and a Chat widget embed token; a Chat management API key must never be embedded in an app.

- Android: set `EILYA_OTP_API_KEY` and `EILYA_CHAT_EMBED_TOKEN` as Gradle properties or environment variables, then run `gradle installDebug` from `android/`.
- iOS: open `ios/Package.swift` in Xcode, add the same two names to the Run scheme environment, and build the `EilyaSample` scheme.
- Flutter: run `flutter pub get`, then `flutter run --dart-define=EILYA_OTP_API_KEY=... --dart-define=EILYA_CHAT_EMBED_TOKEN=...` from `flutter/`.

The repository has no standalone automated test suites. Validation is performed with platform analyzers and sample builds.

## Work completed before this review

The repository already contained one concise example per platform and basic setup documentation. A previous change attempted to align calls with the published SDK APIs, but several Chat initialization names and credential examples still targeted an obsolete API.

## Review and corrections in this round

- Updated every Chat dependency and example to the current `1.1.0` client API and `embedToken` terminology.
- Replaced invalid/source-edited credential placeholders with build-time or environment configuration on all three platforms.
- Prevented samples from rendering the full OTP authentication token in the UI after verification.
- Corrected the iOS OTP call from the obsolete `phone:` argument to `phoneNumber:`.
- Replaced an iOS 16.1-only font modifier so the sample compiles for its declared iOS 15 deployment target.
- Updated the README commands and security guidance and resolved/pinned Swift package dependencies.

## Important files and components

- `android/app/build.gradle.kts`: Android SDK dependencies and safe BuildConfig credential injection.
- `android/app/src/main/java/com/eilyatech/sample/MainActivity.kt`: Android OTP/Chat flow.
- `ios/Package.swift` and `ios/Package.resolved`: iOS package definition and resolved SDK revisions.
- `ios/EilyaSample/ContentView.swift`: SwiftUI OTP/Chat flow.
- `flutter/pubspec.yaml`: Flutter SDK constraints.
- `flutter/lib/main.dart`: Flutter OTP/Chat flow and compile-time definitions.

## Technical decisions

- Chat uses a public widget embed token (`ew_...`), not a privileged management API key. This matches SDK `1.1.0` and avoids placing server credentials in distributed apps.
- Valid zero-value placeholders remain only to let the code initialize structurally; real requests require externally supplied credentials.
- Authentication tokens are deliberately not displayed. Applications should store/use them securely instead of exposing them in UI or logs.
- The iOS simulator build through Xcode is authoritative because the package declares an iOS executable; plain `swift build` attempts to compile it as a macOS command-line executable.

## Test and build status

- Flutter: `flutter pub get` succeeded; `flutter analyze` completed with no issues; formatting check is clean.
- iOS: Swift package resolution succeeded and `xcodebuild` for a generic iOS Simulator completed successfully with signing disabled.
- Android resource XML: manifests/layouts passed `xmllint` parsing.
- Android application build: not runnable in this environment because `ANDROID_HOME` points to the unavailable `/Volumes/MyPassport/Android/sdk` volume. This is an environment prerequisite, not a confirmed project defect.
- No platform contains an automated test target in this sample repository.

## Known issues and risks

- Real end-to-end OTP and Chat calls require valid service credentials and network access and were not exercised.
- Android remains uncompiled until an Android SDK is mounted/configured.
- Zero placeholders intentionally fail against production services; they must not be mistaken for working credentials.

## Remaining work

- Run the Android debug build after restoring the Android SDK.
- Exercise each app against non-production test credentials.
- Add lightweight UI/unit tests if these samples grow beyond documentation examples.

## Ordered next steps

1. Restore or configure a local Android SDK and run `gradle assembleDebug` from `android/`.
2. Supply test OTP and Chat embed credentials externally and smoke-test request, verify, session, and message flows on each platform.
3. Confirm the published Android and Flutter packages remain compatible whenever SDK versions are upgraded.
4. Add CI builds for Flutter analysis, iOS Simulator, and Android debug assembly.

## Git handoff

- Current branch: `main`.
- Commit before this review: `2279c03`.
- Final delivery commit: the commit containing this file; its exact hash is recorded in the delivery report because a Git commit cannot contain its own hash.
- Remote: `origin` (existing repository remote). No force-push, merge, or history rewrite is permitted.

This document is the handoff source of truth for another Codex account; no prior conversation is required to continue the work.
