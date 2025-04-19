#!/bin/bash

echo "🧼 Pulizia progetto Flutter..."

flutter clean
echo "✅ flutter clean fatto"

echo "🧹 Rimozione Pods, Podfile.lock e Flutter iOS cache..."
rm -rf ios/Pods ios/Podfile.lock ios/Flutter/Flutter.framework ios/Flutter/Flutter.podspec

echo "🔄 flutter pub get..."
flutter pub get

echo "📦 Reinstallazione dei Pod iOS..."
cd ios
pod deintegrate
pod install --repo-update
cd ..

echo "✅ Tutto pronto. Ora puoi fare 'flutter run' 🚀"
