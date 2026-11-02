# google_mlkit_text_recognition references every script's recognizer. The app
# ships only Latin (bundled) and Devanagari (added in build.gradle.kts), so
# the CJK ones are intentionally absent.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
