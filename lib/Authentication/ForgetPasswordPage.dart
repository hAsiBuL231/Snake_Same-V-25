import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  String _email = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SignUpPage',
      home: Builder(
        builder: (context) => Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('Assets/login.png'), fit: BoxFit.fill)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  top: 180, bottom: 20, right: 20, left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Reset\nPassword',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Raleway',
                          fontSize: 38,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 50),
                  Column(
                    children: [
                      TextFormField(
                          validator: (input) {
                            if (input == null &&
                                input!.contains('@gmail.com')) {
                              return 'Please enter a valid Gmail';
                            }
                            return null;
                          },
                          onChanged: (value) => _email = value,
                          decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.email, color: Colors.blue),
                              hintText: 'Email',
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)))),
                    ],
                  ),
                  const SizedBox(height: 150),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Send Request",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                        FloatingActionButton(
                            onPressed: () async {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: _email);
                              const SnackBar(
                                  content:
                                      Text('A mail is sent to your email.'));
                            },
                            child: const Icon(Icons.arrow_forward))
                      ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
