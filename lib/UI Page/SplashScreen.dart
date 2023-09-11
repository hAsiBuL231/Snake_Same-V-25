import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Authentication/SignInPage.dart';
import '../All Functions Page/FirebaseFunction.dart';
import '../All Functions Page/Functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // await for for the widget to mount
    await Future.delayed(const Duration(seconds: 2));

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('\n User is currently signed out! \n\n');
      newPage(const SignInPage(), context);
    } else {
      authentication(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('Assets/cover.png'),
                      fit: BoxFit.fitHeight))),
          const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Image(
                    image: AssetImage('Assets/cover.png'),
                    height: 100,
                    width: 200),
                SizedBox(height: 60),
                Text(
                  'SnakeHost\nVersion-2.0',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.brown,
                      fontFamily: 'GideonRoman'),
                  textScaleFactor: 2,
                ),
                SizedBox(height: 130),
                CircularProgressIndicator(),
                SizedBox(height: 30),
                Text("Loading",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                        fontFamily: 'GideonRoman')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
