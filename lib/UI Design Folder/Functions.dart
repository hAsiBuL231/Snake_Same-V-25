import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Database/GameScores.dart';
import '../Database/UserData.dart';
import '../Database/UserForm.dart';
import '../Database/UserProfile.dart';
import '../Database/globals.dart';
import '../Game Pages/Tic_Tac_Game.dart';
import 'AllPagesClass.dart';
import 'HomePage.dart';

String? userEmail = FirebaseAuth.instance.currentUser?.email;
String? userName = FirebaseAuth.instance.currentUser?.displayName;
String? userImage = FirebaseAuth.instance.currentUser?.photoURL;

PopupMenuButton popUpMenu() {
  return PopupMenuButton(itemBuilder: (BuildContext context) {
    return [
      PopupMenuItem(
          child: TextButton(
              onPressed: () => nextPage(const UserProfile(), context),
              child: const Text("Profile"))),
      PopupMenuItem(
          child: TextButton(
              onPressed: () => nextPage(UserData(), context),
              child: const Text("User Data"))),
      PopupMenuItem(
          child: TextButton(
              onPressed: () => nextPage(const AllPagesClass(), context),
              child: const Text("All Pages"))),
      PopupMenuItem(
          child: ElevatedButton(
              onPressed: () => nextPage(Tik_Tak_Game(), context),
              child: const Text("Tic-Tac Game"))),
    ];
  });
}

void nextPage(page, context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void newPage(page, context) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page), (route) => false);
}

snackBar(String message, context) {
  var snackDemo = SnackBar(
    content: Text(message),
    backgroundColor: Colors.red[700],
    elevation: 15,
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.all(20),
    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    margin: const EdgeInsets.all(20),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackDemo);
}

authentication(context) async {
  userEmail = '';
  userEmail = FirebaseAuth.instance.currentUser?.email;

  String phone = "NoData";
  var querySnapshot = await FirebaseFirestore.instance
      .collection('user_list')
      .doc(userEmail)
      .get();
  var data = querySnapshot.data();
  if (data != null) phone = data['phone'];

  if (kDebugMode) {
    print('\n User is Signed in as: $userEmail! \n');
  }
  if (kDebugMode) {
    print('\n Phone Number data is: $phone \n\n');
  }
  if (phone == "NoData") {
    newPage(const UserForm(), context);
  } else {
    newPage(const HomePage(), context);
  }
  return;
}

/*Future<void> getHighestScore() async {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('scores');
  // Get docs from collection reference
  QuerySnapshot querySnapshot =
      await _collectionRef.where(FieldPath(['$userEmail'])).get();
  // Get data from docs and convert map to List
  querySnapshot.docs.map((DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // Assign the value of the 'score' field to the 'highestScore' variable
    highestScore = data['score'] as int;
  });
}*/

Future<void> addHeightsScore(int score) async {
  if (score > GameScoresState().highestScore) {
    String? userName = FirebaseAuth.instance.currentUser?.displayName;
    CollectionReference scores =
        FirebaseFirestore.instance.collection('scores');
    await scores
        .doc('$userEmail')
        .set({
          'player': userName.toString(),
          'score': score,
        })
        .then((value) => const SnackBar(content: Text('Score added')))
        .catchError((error) => SnackBar(content: Text('Error: $error')));
  }
}

addScore(int score) async {
  userName = FirebaseAuth.instance.currentUser?.displayName;
  userEmail = FirebaseAuth.instance.currentUser?.email;
  CollectionReference scores = FirebaseFirestore.instance
      .collection('user_list')
      .doc(userEmail)
      .collection('scores');
  await scores
      .doc()
      .set({
        'time': DateTime.now(),
        'score': score,
        'level': gLevel,
        'mode': gMode,
        'system': gSystem,
      })
      .then((value) => const SnackBar(content: Text('Score added')))
      .catchError((error) => SnackBar(content: Text('Error: $error')));
}
