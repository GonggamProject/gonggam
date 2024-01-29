# gonggam

gonggam

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Get android key tool
keytool -exportcery -alias upload -keystore upload-keystore.jks | openssl sha1 -binary | openssl base64

## dto change
flutter pub run build_runner build

## ios build error
sudo arch -x86_64 gem install ffi                                                                                                                         
cd ios
rm -rf build
rm -rf Pods
rm -rf Podfile.lock
rm -rf ~/.pub-cache/hosted/pub.dartlang.org
pod cache clean --all
flutter clean
flutter pub get
arch -x86_64 pod repo update
arch -x86_64 pod install
