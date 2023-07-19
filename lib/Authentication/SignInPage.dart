import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snake_game_v_25/UI%20Design%20Folder/Functions.dart';

import 'ForgetPasswordPage.dart';
import 'SignUpPage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("Assets/login.png"), fit: BoxFit.fitWidth)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding:
              const EdgeInsets.only(top: 55, bottom: 20, right: 25, left: 25),
          child: Column(
            children: [
              const Image(
                  image: AssetImage('Assets/Images/image1.png'),
                  height: 180,
                  fit: BoxFit.cover),
              const Text("Welcome Back!\nLogin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 36,
                      color: Colors.black,
                      fontFamily: "Raleway")),
              TextButton(
                  onPressed: () => nextPage(const SignUpPage(), context),
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                  child: const Text("New User? Register",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans'))),
              const SizedBox(height: 20),
              Form(
                key: formKey2,
                child: Column(
                  children: [
                    TextFormField(
                        validator: (value) {
                          if (value!.contains('@gmail.com')) {
                            return null;
                          }
                          return 'Please enter a valid Gmail!';
                        },
                        onChanged: (value) => _email = value,
                        decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.mail, color: Colors.blue),
                            hintText: 'Email',
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)))),
                    const SizedBox(height: 20),
                    TextFormField(
                        validator: (input) {
                          if (input!.length < 6) {
                            return 'Your password needs to be at least 6 character';
                          }
                          return null;
                        },
                        obscureText: true,
                        onChanged: (value) => _password = value,
                        decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.vpn_key, color: Colors.blue),
                            hintText: 'Password',
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)))),
                  ],
                ),
              ),
              TextButton(
                  onPressed: () =>
                      nextPage(const ForgetPasswordPage(), context),
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.transparent),
                      textStyle: MaterialStatePropertyAll(
                          TextStyle(decoration: TextDecoration.underline))),
                  child: const Text("Forgot Password?",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans'))),
              const SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                const Text("Sign In",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 32,
                        fontFamily: "Raleway")),
                IconButton(
                    color: Colors.blue,
                    iconSize: 60,
                    onPressed: () async {
                      if (formKey2.currentState!.validate()) {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _email.trim(),
                                  password: _password.trim());
                        } catch (e) {
                          snackBar(e.toString(), context);
                          return;
                        }
                        authentication(context);
                      }
                    },
                    icon: const Icon(Icons.arrow_circle_right)),
              ]),
              const SizedBox(height: 10),
              FloatingActionButton.extended(
                onPressed: () async {
                  try {
                    final googleUser = await GoogleSignIn().signIn();
                    if (googleUser == null) return;
                    final googleAuth = await googleUser.authentication;
                    final credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken);
                    await FirebaseAuth.instance
                        .signInWithCredential(credential);
                  } catch (e) {
                    snackBar(e.toString(), context);
                    return;
                  }
                  authentication(context);
                },
                icon: Image.asset('Assets/Images/google_logo.png',
                    height: 28, width: 28),
                label: const Text('Sign in with Google'),
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
