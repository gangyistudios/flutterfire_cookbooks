# flutterfire_cookbooks

A new Flutter project.

## 1-Getting-Started

We just follow this guide to set up the pre-requisites: [Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup?platform=ios)

### Current environment

Macbook Air M2, 2022 
8 GB Memory
macOS Ventura 13.2.1 

Flutter 3.7.11 • channel stable • https://github.com/flutter/flutter.git
Framework • revision f72efea43c (7 days ago) • 2023-04-11 11:57:21 -0700
Engine • revision 1a65d409c7
Tools • Dart 2.19.6 • DevTools 2.20.1


### Part 1: Install Firebase & FlutterFire CLIs  

```sh
# 1. Install Firebase CLI
curl -sL https://firebase.tools | bash

# 2. Login to Firebase CLI
firebase login

# 3. Test Firebase CLI 
firebase projects:list

# 4. (Optional) Upgrade Firebase CLI 
curl -sL https://firebase.tools | upgrade=true bash

# 5. (Optional) Headless Firebase login 
# https://firebase.google.com/docs/cli#cli-ci-systems 

# 6. Install the FlutterFire CLI 
dart pub global activate flutterfire_cli

# 7. Add the following line to the bottom of ~/.zshrc
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### Part 2: Configure Firebase in Flutter project using FlutterFire

```sh
# 1. Configure apps to use firebase - * Rerun this any time you add a new platform or firebase service *
flutterfire configure

# If you get an error, run the below and try again - https://github.com/invertase/flutterfire_cli/issues/127 
gem install xcodeproj

# 2. Install firebase_core plugin 
flutter pub add firebase_core

# 3. Re-run flutterfire configure 
flutterfire configure
```

### Part 3: Add the initialisation code in main.dart

```sh
# 1. Add this at top of main.dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


# 2. Add this in main()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ...

# 3. If issues running on ios or macos
sudo gem install activesupport -v 6.1.7.3
sudo gem install cocoapods  
cd ios 
pod install
cd ../macos
pod install
```

## 2-Firebase-UI-Auth

Follow this guide - https://github.com/firebase/flutterfire/tree/master/packages/firebase_ui_auth/doc

Github - https://github.com/firebase/flutterfire/tree/master/packages

Discussion - https://github.com/firebase/flutterfire/discussions/6978 

StoryBook - https://flutterfire-ui.web.app/#/ 

### Part 1: Setup 

```sh
# 1. Install libraries
flutter pub add firebase_auth
flutter pub add firebase_dynamic_links
flutter pub add firebase_ui_auth

# 2. Re-run flutterfire configure 
flutterfire configure

# 3. Go to Firebase Console and enable email/password authentication

# 4. Run and test register, sign in, verification link and profile page
```

## 3-CircleMagic-CI/CD

Current Flutter environment 

```sh
~/Projects/flutterfire_cookbooks % flutter doctor
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.7.11, on macOS 13.2.1 22D68 darwin-arm64, locale
    en-AU)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.2)
[✓] Xcode - develop for iOS and macOS (Xcode 14.3)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2022.2)
[✓] IntelliJ IDEA Ultimate Edition (version 2022.2.2)
[✓] VS Code (version 1.75.1)
[✓] Connected device (2 available)
[✓] HTTP Host Availability

• No issues found!
```

### Part 1: Install and configure Flutter Version Management (FVM) 

```sh
# 1. Install Flutter version management 
https://fvm.app/docs/getting_started/installation 

# 2. Add to gitignore
.fvm/flutter_sdk

# 3. Add to .vscode/settings.json
{
    "dart.flutterSdkPath": ".fvm/flutter_sdk",
    // Remove .fvm files from search
    "search.exclude": {
        "**/.fvm": true
    },
    // Remove from file watching
    "files.watcherExclude": {
        "**/.fvm": true
    }
}

# 3. Use stable channel flutter (run from project root)
fvm use stable
```

### Part 2: Configure codemagic.yaml

Follow this guide - https://docs.codemagic.io/yaml-quick-start/building-a-flutter-app/ 

Check the new file/directory added in this branch, `codemagic.yaml` and `.fvm`

Error in codemagic build.
```
Encountered error while creating the IPA:
error: exportArchive: "Runner.app" requires a provisioning profile.

# Follow this - https://stackoverflow.com/a/55521074 
sudo gem update cocoapods --pre 
pod update 
# In Xcode, clean and build. 
```

After this step, any push will build and deploy IOS to testflight. 
