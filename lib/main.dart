import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutterfire_cookbooks/screens/call_functions_screen.dart';
import 'package:flutterfire_cookbooks/screens/connect_screen.dart';
import 'package:flutterfire_cookbooks/screens/menu_screen.dart';
import 'package:flutterfire_cookbooks/screens/orders_list_screen.dart';
import 'package:flutterfire_cookbooks/shared/configure_emulators.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Use Firebase Local Emulator if USE_FIREBASE_EMULATOR env var is set
  if (const bool.fromEnvironment("USE_FIREBASE_EMU")) {
    await configureAuthEmulator();
    configureFirestoreEmulator();
    configureFunctionsEmulator();
    // await configureFirebaseStorage(); // not used currently
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var providers = [EmailAuthProvider()];

    return MaterialApp(
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/menu',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providers: providers,
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/menu');
              }),
            ],
          );
        },
        '/menu': (context) {
          return const MenuScreen();
        },
        '/connect': (context) {
          return const ConnectScreen();
        },
        '/orders': (context) {
          return const OrdersListScreen();
        },
        '/call-functions': (context) {
          return const CallFunctionsScreen();
        },
        '/profile': (context) {
          return ProfileScreen(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/menu');
                },
              ),
              title: const Text('Profile Screen'),
            ),
            providers: providers,
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          );
        },
      },
    );
  }
}
