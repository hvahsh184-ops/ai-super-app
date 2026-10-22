# Spec — AI Super App (from user, 2026-10-23)

Modules the user expects (only #1 built so far):
1. OpenRouter chat — free model selection (468 live models) ✅ built in AIChat-Android-v1.0.0.apk
2. Voice: vocal separation (vocals from track) + voice cloning — NOT built
3. Video: 2 models — "Mochi 1" (genmo/mochi-1) + one other (user said "notch one" — name unconfirmed) — runs on Google Colab or Liberto (user has a Liberto key) — NOT built
4. GitHub: token field in app settings so user can log in — NOT built
5. Liberto: user obtained an API key for "Liberto" (site unconfirmed — web search found no such AI platform) — NOT built

User constraints:
- Stack: Flutter + Kotlin + Java + C++ (NDK) — done in v1
- OpenRouter key stored in Android Keystore (user enters in app) — done
- Uncensored models preferred (dolphin-mistral-24b-venice-edition recommended)
- User frustrated by ad-hosted file links; wants clean direct download
- 52MB APK size questioned — explained as Flutter engine + 3 ABIs + native libs (normal)

Open questions for user:
- Liberto: site link + key value
- Video: exact name of 2nd model; Colab account availability
- Voice: confirm Demucs (separation) + RVC (cloning) on Colab is what was meant
