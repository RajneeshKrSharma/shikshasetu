.PHONY: help pubGet clean format analyze test check run runRelease \
	buildApk buildApkArm64 buildApkSplit buildBundle buildIos buildIpa \
	install devices outdated upgrade icons splash branding

help: ## Show all commands
	@grep -E '^[a-zA-Z0-9_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

# ---------- Setup ----------

pubGet: ## Fetch dependencies
	flutter pub get

clean: ## Clean build and fetch dependencies again
	flutter clean
	flutter pub get

outdated: ## List outdated packages
	flutter pub outdated

upgrade: ## Upgrade packages within constraints
	flutter pub upgrade

# ---------- Branding ----------

icons: ## Regenerate app icons from assets/logo
	dart run flutter_launcher_icons

splash: ## Regenerate native splash screen from assets/logo
	dart run flutter_native_splash:create

branding: icons splash ## Regenerate icons and splash

# ---------- Code quality ----------

format: ## Format all Dart code
	dart format lib test

analyze: ## Run static analysis
	flutter analyze

test: ## Run unit/widget tests
	flutter test

check: format analyze test ## Format, analyze and test

# ---------- Run ----------

devices: ## List connected devices
	flutter devices

run: ## Run debug build on connected device
	flutter run

runRelease: ## Run release build on connected device
	flutter run --release

# ---------- Android builds ----------

buildApk: ## Release APK (all architectures)
	flutter build apk --release
	@echo "APK: build/app/outputs/flutter-apk/app-release.apk"

buildApkArm64: ## Release APK for arm64 phones only (smaller)
	flutter build apk --release --target-platform android-arm64
	@echo "APK: build/app/outputs/flutter-apk/app-release.apk"

buildApkSplit: ## Separate release APK per architecture
	flutter build apk --release --split-per-abi
	@echo "APKs: build/app/outputs/flutter-apk/"

buildBundle: ## Release App Bundle for Play Store
	flutter build appbundle --release
	@echo "AAB: build/app/outputs/bundle/release/app-release.aab"

install: ## Install the release APK on connected device
	flutter install --release

# ---------- iOS builds ----------

buildIos: ## Release iOS build (no IPA)
	flutter build ios --release

buildIpa: ## Release IPA for App Store / TestFlight
	flutter build ipa --release
	@echo "IPA: build/ios/ipa/"
