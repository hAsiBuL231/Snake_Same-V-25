import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../All Functions Page/Functions.dart';

import '../All Functions Page/FirebaseFunction.dart';
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
  bool _obscureText = true;
  void _toggle() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          const BoxDecoration(image: DecorationImage(image: AssetImage("Assets/login.png"), fit: BoxFit.fitWidth)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 20, bottom: 20, right: 25, left: 25),
            child: Column(
              children: [
                const Image(image: AssetImage('Assets/Images/image1.png'), height: 180, fit: BoxFit.cover),
                const Text("Welcome Back!\nLogin",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, color: Colors.black, fontFamily: "Raleway")),
                const SizedBox(height: 20),
                Form(
                    key: formKey2,
                    child: Column(children: [
                      TextFormField(
                          validator: (value) {
                            if (value!.contains('@gmail.com')) {
                              return null;
                            }
                            return 'Please enter a valid Gmail!';
                          },
                          //textAlignVertical: TextAlignVertical.top,
                          //textAlign: TextAlign.start,
                          //maxLength: 500,
                          //expands: true,
                          onChanged: (value) => _email = value,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.mail, color: Colors.blue),
                              hintText: 'Email',
                              labelText: 'Email',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)))),
                      const SizedBox(height: 20),
                      TextFormField(
                          validator: (input) {
                            if (input!.length < 6) {
                              return 'Your password needs to be at least 6 character';
                            }
                            return null;
                          },
                          onChanged: (value) => _password = value,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.vpn_key, color: Colors.blue),
                              suffixIcon: IconButton(
                                  icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                                  onPressed: _toggle),
                              hintText: 'Password',
                              labelText: 'Password',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))))
                    ])),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                      onPressed: () => nextPage(const ForgetPasswordPage(), context),
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                          textStyle: MaterialStatePropertyAll(TextStyle(decoration: TextDecoration.underline))),
                      child: const Text("Forgot Password?",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans')))
                ]),
                const SizedBox(height: 10),
                /*Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  const Text("Sign In", style: TextStyle(color: Colors.blue, fontSize: 32, fontFamily: "Raleway")),
                  IconButton(
                      color: Colors.blue,
                      iconSize: 60,
                      onPressed: () async {
                        if (formKey2.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(email: _email.trim(), password: _password.trim());
                          } catch (e) {
                            snackBar(e.toString(), context);
                            return;
                          }
                          authentication(context);
                        }
                      },
                      icon: const Icon(Icons.arrow_circle_right))
                ]),
                ElevatedButton(
                    onPressed: () {},
                    child:
                        Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 32, fontFamily: "Raleway"))),*/
                InkWell(
                    onTap: () async {
                      if (formKey2.currentState!.validate()) {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(email: _email.trim(), password: _password.trim());
                        } catch (e) {
                          snackBar(e.toString(), context);
                          return;
                        }
                        authentication(context);
                      }
                    },
                    child: Ink(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                          child: Text("Sign In",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32))),
                    )),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('New User! ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[700])),
                  TextButton(
                      onPressed: () => nextPage(const SignUpPage(), context),
                      child: Text('Register now',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)))
                ]),
                Row(children: [
                  Expanded(child: Divider(thickness: 1, color: Colors.black)),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Or', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  Expanded(child: Divider(thickness: 1, color: Colors.black))
                ]),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  FloatingActionButton(
                      heroTag: 'GoogleSingIn',
                      onPressed: () async {
                        try {
                          final googleUser = await GoogleSignIn().signIn();
                          if (googleUser == null) return;
                          final googleAuth = await googleUser.authentication;
                          final credential = GoogleAuthProvider.credential(
                              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
                          await FirebaseAuth.instance.signInWithCredential(credential);
                        } catch (e) {
                          snackBar(e.toString(), context);
                          return;
                        }
                        authentication(context);
                      },
                      child: Image.asset('Assets/Images/google_logo.png', height: 60, width: 60),
                      //icon: Image.asset('Assets/Images/google_logo.png', height: 28, width: 28),
                      //label: const Text('Continue with Google'),
                      //foregroundColor: Colors.black,
                      backgroundColor: Colors.white),
                  FloatingActionButton(
                      heroTag: 'FacebookSignIn',
                      onPressed: () {},
                      child: Image.asset('Assets/Images/facebook_logo.png', height: 60, width: 60),
                      backgroundColor: Colors.white),
                  FloatingActionButton(
                      heroTag: 'AppleSignIn',
                      onPressed: () {},
                      child: Image.asset('Assets/Images/apple_logo.png', height: 60, width: 60),
                      backgroundColor: Colors.white),
                ]),
                /*SizedBox(height: 15),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              elevation: 5,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Image.asset('Assets/Images/google_logo.png', height: 40),
                                    const SizedBox(width: 20),
                                    Text('Continue with Google', style: const TextStyle(fontSize: 20))
                                  ]))),
                          SizedBox(height: 10),
                          Material(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              elevation: 5,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Image.asset('Assets/Images/facebook_logo.png', height: 40),
                                    const SizedBox(width: 20),
                                    Text('Continue with Facebook', style: const TextStyle(fontSize: 20))
                                  ]))),
                          SizedBox(height: 10),
                          Material(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              elevation: 5,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Image.asset('Assets/Images/apple_logo.png', height: 40),
                                    const SizedBox(width: 20),
                                    Text('Continue with Apple', style: const TextStyle(fontSize: 20))
                                  ])))
                        ])),*/
                SizedBox(height: 20),
                Hero(
                    tag: 'footer',
                    child: Text('Made with ♥ by MD. Hasibul Hossain',
                        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
