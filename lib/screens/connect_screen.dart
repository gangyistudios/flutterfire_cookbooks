import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import '../firebase_options.dart';
import 'package:flutter/material.dart';

// Leave main method here so we can run in isolation
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ConnectScreen());
}

Future<bool> canLaunch(String url) async {
  return await UrlLauncherPlatform.instance.canLaunch(url);
}

Future<void> launch(String url, {bool useSafariVC = false}) async {
  await UrlLauncherPlatform.instance.launch(
    url,
    enableDomStorage: false,
    useSafariVC: useSafariVC,
    enableJavaScript: false,
    universalLinksOnly: false,
    webOnlyWindowName: '_blank',
    headers: <String, String>{},
    useWebView: false,
  );
}

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Connect')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              const url = 'https://www.ebay.com/';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: const Text('Connect'),
          ),
        ),
      ),
    );
  }
}
