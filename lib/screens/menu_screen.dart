import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:flutter/material.dart';

// Leave main method here so we can run in isolation
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MenuScreen());
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String displayName = auth.currentUser?.displayName ?? 'Not logged in';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Hello, $displayName',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/connect');
              },
              child: const Text('Launch URL'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/call-functions');
              },
              child: const Text('Call Functions'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/profile');
              },
              child: const Text('Profile Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
