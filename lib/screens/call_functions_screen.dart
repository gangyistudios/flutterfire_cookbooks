import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterfire_cookbooks/shared/configure_emulators.dart';
import '../firebase_options.dart';
import 'package:flutter/material.dart';

// Leave main method here so we can run in isolation
// Need to start emulators first with `firebase emulators:start`
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureFunctionsEmulator(); // (Optional) We can also start functions emulation with `cd functions && npm run serve`

  try {
    final result =
        await FirebaseFunctions.instance.httpsCallable('getUserDetails').call(
      {
        "text": "my test message",
        "push": true,
      },
    );

    var response = result.data;

    if (kDebugMode) {
      print("response + $response");
    }
  } on FirebaseFunctionsException catch (error) {
    if (kDebugMode) {
      print("Error occurred calling function");
      print(error.code);
      print(error.details);
      print(error.message);
    }
  }

  runApp(const CallFunctionsScreen());
}

class CallFunctionsScreen extends StatelessWidget {
  const CallFunctionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser?.uid ?? 'Not logged in';

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/menu');
            },
          ),
          title: const Text('Call Functions Screen'),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Calling functions for authenticated user $uid',
                  textAlign: TextAlign.center,
                ),
              ),
              const GetUserDetails(),
              const Padding(padding: EdgeInsets.all(8.0)),
              const GetUserData(),
            ],
          ),
        ),
      ),
    );
  }
}

class GetUserDetails extends StatelessWidget {
  const GetUserDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HttpsCallableResult>(
      future: FirebaseFunctions.instance.httpsCallable('getUserDetails').call(
        {
          "text": "my test message",
          "push": true,
        },
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(child: Text('Loading getUserDetails...'));
        }

        final response = snapshot.data!.data;

        return Text(
          'getUserDetails: $response',
          textAlign: TextAlign.center,
        );
      },
    );
  }
}

class GetUserData extends StatelessWidget {
  const GetUserData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HttpsCallableResult>(
      future: FirebaseFunctions.instance.httpsCallable('getUserData').call(
        {
          "text": "my test messages",
          "push": true,
        },
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(child: Text('Loading getUserData...'));
        }

        final response = snapshot.data!.data;

        return Text(
          'getUserData: $response',
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
