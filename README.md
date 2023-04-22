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
```sh
Encountered error while creating the IPA:
error: exportArchive: "Runner.app" requires a provisioning profile.

# Follow this - https://stackoverflow.com/a/55521074
sudo gem update cocoapods --pre
pod update
# In Xcode, clean and build.
```

After this step, any push will build and deploy IOS to testflight.

## 4-Firebase-UI-Firestore

We now integrate with firestore using (FlutterFire's) firebase firestore UI kit.

```sh
fvm flutter pub add cloud_firestore
fvm flutter pub add firebase_ui_firestore
```

And view `orders_list_screen.dart` which retrieves Firestore collection 'orders' into a list view.

This part is relatively simple - just install the packages, enable firestore in Firebase console, add some test documents to the 'orders' collection and add the `orders_list_screen.dart`.

`flutterfire configure` which we ran in previous steps already took care of all the Firebase integration/configuration to our Flutter app.

## 5-Firebase-Cloud-Functions

### Part 1: Set up cloud functions

We are following this guide roughly - https://firebase.google.com/docs/functions/get-started (Some parts are already done, such as firebase initialisation and project set up)

To integrate with a 3rd party API that uses OAuth 2.0 flows, we need to retrieve the OAuth Bearer Token. We don't want to expose this token to the client/front-end Flutter app, so we utilise functions for both the OAuth flow as well as any other subsequent calls to the 3rd party API.

In contrast to a server-based backend, we now have a serverless-based backend which ensures sensitive data (such as 3rd party bearer tokens) are never exposed to the client. This topic is a whole bag of worms in itself, some may argue that due to the inbuilt security mechanisms of certain bearer tokens (i.e. ability to invalidate a token, time-based expiration of the token) that it is OK to bypass the usage of a backend and store the tokens directly on the client, it will be up to the developer to weigh the trade-offs of their individual use case and make a decision.

```sh
# 1. Enable Billing and Cloud Functions for the firebase project from Google Cloud Console (not the Firebase Console)
https://console.cloud.google.com/

# 2. From the project root, select the existing firebase project, creates functions/ directory in the project root.
firebase init functions # Language=Typescript, ESLint=Yes, Install deps with npm=Yes

# (Optional) If any issues with the above step, try
firebase logout
firebase login

# 3. Re-run flutterfire configure
flutterfire configure

# 4. Open the functions/ directory in a new VSCode window so ESLint works properly
code functions/

# 5. Uncomment the sample function and deploy to firebase
firebase deploy --only functions

# 6. Access the function from the console output link (yours will be different)
https://us-central1-flutterfire-cookbooks.cloudfunctions.net/helloWorld

# 7. Deploy the function locally, within the functions/ directory
npm run serve
http://localhost:4000             # Emulator UI
http://localhost:4000/functions   # Emulator UI for functions
http://localhost:5001/flutterfire-cookbooks/us-central1/helloWorld # Sample function
```

### Part 2: Set up functions to get authenticated user context

Having a function that displays "Hello World" is all well and good, however our purpose is to use functions to perform actions with sensitive data without exposing that data to the front-end. This sensitive data (OAuth Bearer Token) is linked to a user of our app - every user will have their own OAuth Bearer Token which provides access to their 3rd party app account/data. So we need our functions to authenticate a user logged in to our app in order to retrieve and perform actions with their specific Bearer token.

As our Flutter app is already set up with Firebase authentication and firestore client libraries, we can use a similar Firebase client library for functions to handle passing of an authentication context from our Flutter front end app to our backend cloud functions. This is done through a special type of cloud function called [**Callable Functions**](https://firebase.google.com/docs/functions/callable).

As per the [Cloud Functions docs](https://firebase.google.com/docs/functions/callable), callable functions differ from HTTP functions by:
> - With callables, Firebase Authentication tokens, FCM tokens, and App Check tokens, when available, are automatically included in requests.
>
> - The functions.https.onCall trigger automatically deserializes the request body and validates auth tokens.

As we can see, the inclusion and parsing of the authentication context between our Flutter front end and the cloud function is automatically handled.

```sh
# 1. Write the callable function in functions/src/index.ts
export const getUserDetails = functions.https.onCall((data, context) => {
  // Message text passed from the client.
  const text = data.text;
  // Authentication / user information is automatically added to the request.
  const uid = context.auth?.uid;
  const name = context.auth?.token.name || null;
  const picture = context.auth?.token.picture || null;
  const email = context.auth?.token.email || null;

  console.log("getUserDetails", {text, uid, name, picture, email});

  return {
    text: text,
    uid: uid,
    name: name,
    picture: picture,
    email: email,
  };
});

# 2. Re-deploy to cloud
firebase deploy --only functions

# (Optional) If any errors
# Error: Failed to fetch Run service undefined
npm install firebase-functions@latest firebase-admin@latest --save
npm install -g firebase-tools
# Ensure we close and open a new shell after any new installs
# Try also deleting the existing functions from Firebase console
```

### Part 3: Set up flutter app to call cloud functions

We use this package - https://pub.dev/packages/cloud_functions/example

```sh
# 1. Add the cloud_functions flutter package
fvm flutter pub add cloud_functions

# 2. Create a new sample main() to call the function (refer lib/screens/call_functions.dart)

# 3. Run it and view the console output as well as the function logs, we should see the authenticated user's details
Launching lib/screens/call_functions.dart on iPhone 14 Pro Max in debug mode...
call_functions.dart:1
Xcode build done.                                           17.8s
Connecting to VM Service at ws://127.0.0.1:54935/tvZ3mRYjLTY=/ws
flutter: {email: test@gmail.com, picture: null, uid: xxvBOIWcuyYL54v2FHeiZg9wOfU2, name: test, text: my test message}
```

### Part 4: Set up local Firebase emulator

So we want to test Firestore, Functions and Authentication without having to wait a long time to deploy / edit live production data. In order to do that we can use a local firebase emulator which essentially creates a local firebase "instance" on localhost which we can use to simulate our actual firebase.

We will follow this guide - https://firebase.google.com/docs/functions/local-emulator

Simplified setup for functions only testing is as follows:

```sh
# 1. Start the emulator, from project root
cd functions && npm run serve

# 2. Add instrumentation to point app to localhost emulators -> refer new file lib/shared/configure_emulators.dart

# 3. In lib/screens/call_functions.dart, configure to run on emulator instead of production functions:
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // ADD THIS LINE
  configureFunctionsEmulator(); // Start functions emulation with `cd functions && npm run serve`
```

### Part 5: Set up Local Firebase Emulator for Auth, Firestore and Functions

Setting up the local Firebase emulator in Part 4 will make testing and development with Firebase products a lot easier going forward, as we don't have to re-deploy after every change!

Now that we have set up cloud functions and a sample call from our Flutter front-end which passes the the authenticated user context, we can now create/update our functions to use the user context to retrieve the user's data from Firestore (security rules, and App Check to be set up later)

Unlike in Part 4, we now need to emulate all Firebase products and not just functions:

```sh
# 1. Add the following to firebase.json
 "emulators": {
    "auth": {
      "port": 9099
    },
    "firestore": {
      "port": 8080
    },
    "functions": {
      "port": 5001
    }
  }

# 2. Start all emulators
firebase emulators:start

# (Optional) If errors
# ⬢  emulators: firebase-tools no longer supports Java version before 11. Please upgrade to Java version 11 or above to continue using the emulators.
# I have sdkman installed - https://sdkman.io/ , simply switch to java 11.
sdk install java 11.0.17-tem
sdk use java 11.0.17-tem
java -version # openjdk version "11.0.17" 2022-10-18
firebase emulators:start # try again, works for me now

#  functions/lib/index.js does not exist, can't deploy Cloud Functions
cd functions/
npm run build

# 3. Add a test user in the emulator Auth console
http://127.0.0.1:4000/auth

# 4. Add some test user data for our test user in Firestore
http://127.0.0.1:4000/firestore # Take the userId from your test user in step 3, then create a collection 'userData' with a documentId=userId, and add some key-values to the document, i.e. testData="my test data for user Id k4NQ3dqOKN4zlURAiQtvQKlMbroL"

# 5. Export/persist the emulator data for future use. Ensure we run from project root
firebase emulators:start --import .emulators --export-on-exit .emulators
```

### Part 6: Call Function from Flutter app and use Authenticated user context to retrieve from the user's data from Firestore

Now that we have started up our Auth, Functions and Firestore emulators and set up some emulated data, we need to create a screen in Flutter which calls the function and retrieves that data from Firestore.

We roughly follow this guide - https://firebase.google.com/docs/functions/get-started

```sh
# 1. Ensure we import and initialise firebase-admin in functions/src/index.ts

# 2. Create a new callable function getUserData which retrieves data from Firestore, then rebuild
# See file: functions/src/index.ts
cd functions 
npm run build # IMPORTANT - firebase emulators:start doesn't build functions us, unlike npm run serve

# 3. From project root, the emulators again after rebuild 
firebase emulators:start --import .emulators --export-on-exit .emulators

# 4. Add a new Flutter screen which calls the function getUserData and displays the response
# See file: lib/screens/call_functions_screen.dart

# 5. After testing all ok deploy the function to prod
firebase deploy --only functions
```

