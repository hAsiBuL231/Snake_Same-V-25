import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_game_v_25/Authentication/SignInPage.dart';
import '../Database/UserData.dart';
import '../Database/UserProfile.dart';
import '../Game Pages/Tic_Tac_Game.dart';
import '../UI Page/AllPagesClass.dart';


PopupMenuButton popUpMenu() {
  return PopupMenuButton(itemBuilder: (BuildContext context) {
    return [
      PopupMenuItem(
          child: TextButton(
              onPressed: () => nextPage(const UserProfile(), context),
              child: const Text("Profile"))),
      if(FirebaseAuth.instance.currentUser?.email=='hossainhasibul2@gmail.com')
      PopupMenuItem(
          child: TextButton(
              onPressed: () => nextPage(UserData(), context),
              child: const Text("User Data"))),
      if(FirebaseAuth.instance.currentUser?.email=='hossainhasibul2@gmail.com')
        PopupMenuItem(
          child: TextButton(
              onPressed: () => nextPage(const AllPagesClass(), context),
              child: const Text("All Pages"))),
      PopupMenuItem(
          child: TextButton(
              onPressed: () => nextPage(SignInPage(), context),
              child: const Text("Logout"))),

      PopupMenuItem(
          child: TextButton(
              onPressed: () => nextPage(Tik_Tak_Game(), context),
              child: const Text("Tic-Tac Game"))),
      PopupMenuItem(
          child: FilledButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text("Exit"))),

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
    duration: Duration(seconds: 2),
    content: Text(message),
    backgroundColor: Colors.blue,
    elevation: 15,
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.all(20),
    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    margin: const EdgeInsets.all(20),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackDemo);
}

timeFormat(Timestamp time) {
  DateTime now = time.toDate();
  String convertedTime = "${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
  String convertedDate =
      "${now.year.toString()}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}";
  String convertedDateTime = "$convertedTime  $convertedDate";
  return convertedDateTime;
}

/*(Timestamp _time) {
  DateTime joinTime = _time.toDate();
  //var joinTime = _time.toString();
  DateTime time = DateTime.now();
  DateTime currentDate = DateTime(time.year, time.month, time.day);
  int diff1 = time.difference(joinTime).inDays;
  joinTime = joinTime.subtract(Duration(days: diff1));
  int diff2 = time.difference(joinTime).inHours;
  //String diff2 = time.difference(joinTime).inHours.toString();
  //String diff2 = DateTime.now().difference(time).inHours.toString();
  String diff= "$diff1.$diff2";
  return diff;
}*/








/*_getData() async {
    userEmail = FirebaseAuth.instance.currentUser?.email;
    var querySnapshot = await FirebaseFirestore.instance
        .collection('user_list')
        .where(FieldPath([userEmail!]))
        .get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      var data = queryDocumentSnapshot.data();
      setState(() {
        phone = data['phone'];
        profession = data['profession'];
        location = data['location'];
        dob = data['dob'];
        language = data['language'];
        Timestamp getTime = data['joined'];
        DateTime joinTime = getTime.toDate();
        joined = joinTime.toString();
        DateTime time = DateTime.now();
        DateTime currentDate = DateTime(time.year, time.month, time.day);
        difference = currentDate.difference(joinTime).inDays.toString();
      });
    }
    return;
  }*/

