# Beta Release Checklist (Android)

1. Run fast checks:
```bash
./tool/dev_check.sh
```

2. Configure signing and app id:
```bash
./tool/fix_key_properties.sh
./tool/set_signing_passwords.sh
```

3. Verify release preflight:
```bash
./tool/preflight_release.sh
```
Requirement: `Preflight result: PASS` with **0 errors**.

4. Build release APK:
```bash
flutter build apk --release
```

5. Smoke test on device/emulator:
- Open app
- Grant microphone permission
- Start recording
- Stop recording and save
- Check records list
- Check transcription list

6. Archive artifact:
- `build/app/outputs/flutter-apk/app-release.apk`

7. Tag release notes:
- version from `pubspec.yaml`
- known limitations (if any)
