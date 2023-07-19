import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snake_game_v_25/UI%20Design%20Folder/Functions.dart';

import 'SignInPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("Assets/login.png"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding:
              const EdgeInsets.only(top: 35, bottom: 20, right: 20, left: 20),
          child: Column(
            children: [
              const Image(
                  image: AssetImage('Assets/Images/image2.png'),
                  height: 230,
                  fit: BoxFit.cover),
              const Text("Create New\nAccount",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontFamily: "Raleway")),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()));
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                child: const Text("Already Registered? Login",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    /*TextFormField(
                      onChanged: (value) => _name = value,
                      decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          filled: true,
                          labelText: 'Name',
                          hintText: 'Your name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    const SizedBox(height: 15),*/
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
                          labelText: 'Email',
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Your password needs to be at least 6 character!';
                        }
                        return null;
                      },
                      onChanged: (value) => _password = value,
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.vpn_key, color: Colors.blue),
                          labelText: 'Password',
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (input) {
                        if (input != _password) {
                          return 'Your password needs to be matched previous one!';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.vpn_key, color: Colors.blue),
                          labelText: 'Confirm Password',
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    const SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                          FloatingActionButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: _email.trim(),
                                            password: _password.trim());
                                  } catch (e) {
                                    snackBar(e.toString(), context);
                                    return;
                                  }
                                  authentication(context);
                                }
                              },
                              child: const Icon(Icons.arrow_forward))
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
