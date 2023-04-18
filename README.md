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


#### Part 1: Install Firebase & FlutterFire CLIs  

```
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

#### Part 2: Configure Firebase in Flutter project using FlutterFire

```
# 1. Configure apps to use firebase - * Rerun this any time you add a new platform or firebase service *
flutterfire configure

# If you get an error, run the below and try again - https://github.com/invertase/flutterfire_cli/issues/127 
gem install xcodeproj

# 2. Install firebase_core plugin 
flutter pub add firebase_core

# 3. Re-run flutterfire configure 
flutterfire configure
```

#### Part 3: Add the initialisation code in main.dart

```
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