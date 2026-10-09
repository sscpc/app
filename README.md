# FOCUS AI — Flutter starter

A futuristic dark-themed student productivity app starter with:
- Home dashboard and daily task progress
- Task planner (add tasks and mark them complete)
- Working 25-minute focus timer
- Assistant chat demo with sample responses (not connected to a live AI service)
- Profile/settings placeholder
- Bottom navigation

## Run it

1. Install Flutter SDK and configure Android development tools:
   https://docs.flutter.dev/get-started/install
2. Create a fresh Flutter project:
   `flutter create focus_ai`
3. Replace the generated `lib/main.dart` with this package's `lib/main.dart`.
4. Replace the generated `pubspec.yaml` with this package's `pubspec.yaml` (or keep the generated one and ensure Flutter SDK dependency is present).
5. From the project folder run:
   `flutter pub get`
   `flutter run`

## Build an Android APK

From the project folder:
`flutter build apk --release`

The APK is usually created at:
`build/app/outputs/flutter-apk/app-release.apk`

## Important notes

- Tasks and session counts are held in memory; they reset when the app restarts.
- The assistant replies are local demo responses. To use real AI, connect a provider securely through a backend; do not put secret API keys directly in a shipped mobile app.
- This is source code, not a prebuilt APK. Building an APK requires a Flutter build environment.
- For iOS, build on macOS with Xcode and follow Apple's signing/distribution requirements.
