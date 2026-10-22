# Spec — AI Super App (user: Mehdi, 2026-10-23)

## DELIVERY FORMAT: Android APP (APK), NOT a website — user confirmed.
## Assistant name: Accio. User name: Mehdi.

## Final app modules (one APK):
1. Chat — OpenRouter, free model selection (468 live models, uncensored options like dolphin-mistral-24b-venice-edition) ✅ built in AIChat-Android-v1.0.0.apk
2. Video — uncensored video generation via **Livepeer Studio** (https://livepeer.studio/); UUID key received, stored in video_service_creds.txt
3. Voice — vocal separation + voice cloning (location: TBD, possibly Colab)
4. Settings — user enters: OpenRouter key + video service key + GitHub token (for login)

## Stack (unchanged): Flutter + Kotlin + C++ (NDK/JNI) + Java — native Android.
## Keys: stored in Android Keystore, user-entered in-app, never passed to me.

## Open items:
- VIDEO SERVICE: identified as **Livepeer Studio** (https://livepeer.studio/); next: read its API docs + validate the key.
- VOICE: confirm Demucs (separation) + RVC (cloning) on Colab.
- Video model names user mentioned: "Mochi 1" (genmo) + one unconfirmed ("notch one"?).
- Clean download delivery: gofile/tmpfiles are flaky/advertised; best permanent option = GitHub release (needs user repo+PAT) OR builder serving APK directly.

## Build env on this server: JDK17, Flutter, Android SDK (platform 34), NDK — working.
## Last APK: deliverables/AIChat-Android-v1.0.0.apk (52MB, md5 e71be74c72f6b4f15e02dba2a505b37b, signed, minified).
