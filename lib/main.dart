import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:snake_game_v_25/UI%20Page/SplashScreen.dart';
import 'package:snake_game_v_25/firebase_options.dart';

//99371F24-9978-4784-9248-2E6DFCEB4CA1
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        webRecaptchaSiteKey: 'recaptcha-v3-site-key',
        appleProvider: AppleProvider.appAttest);
  } catch (e) {
    if (kDebugMode) {
      print('\n\nPrinting From App: \n Error during Firebase initialization: $e\n\n');
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game V-2.5',
      /*theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),*/
      home: SplashScreen(),
    );
  }
}
