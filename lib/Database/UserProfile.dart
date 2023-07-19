import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snake_game_v_25/Database/UserForm.dart';
import 'package:snake_game_v_25/UI%20Design%20Folder/Functions.dart';
import 'package:snake_game_v_25/UI%20Design%20Folder/HomePage.dart';

import '../Authentication/SignInPage.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  String name = 'loading..';
  String phone = 'loading..';
  String profession = 'loading..';
  String location = 'loading..';
  String dob = 'loading..';
  String language = 'loading..';
  String joined = 'loading..';
  String difference = 'loading..';

  _getData() async {
    userEmail = FirebaseAuth.instance.currentUser?.email;
    var querySnapshot = await FirebaseFirestore.instance
        .collection('user_list')
        .doc(userEmail)
        .get();
    var data = querySnapshot.data();
    if (data == null) {
      name = 'Please set data..';
      phone = 'Please set data..';
      profession = 'Please set data..';
      location = 'Please set data..';
      dob = 'Please set data..';
      language = 'Please set data..';
      joined = 'Please set data..';
      difference = 'Please set data..';
    } else {
      setState(() {
        name = data['name'];
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
  }

  @override
  Widget build(BuildContext context) {
    _getData();
    return Scaffold(
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 50, 5, 16),
                  height: 250,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue, Colors.purple]),
                  ),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage('$userImage')),
                      const SizedBox(width: 10.0),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8.0),
                            Text(name,
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8.0),
                            Text(profession,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white))
                          ]),
                    ]),
                    const SizedBox(height: 16.0),
                    Row(children: [
                      const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Followers',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            SizedBox(height: 4.0),
                            Text('1.2k',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ]),
                      const SizedBox(width: 16.0),
                      const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Following',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            SizedBox(height: 4.0),
                            Text('980',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))
                          ]),
                      const SizedBox(width: 100.0),
                      FloatingActionButton(
                          onPressed: () => nextPage(const UserForm(), context),
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.edit_outlined,
                              color: Colors.white, size: 45))
                    ]),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Name'),
                          subtitle: Text(name)),
                      ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text('Email'),
                          subtitle: Text('$userEmail')),
                      ListTile(
                          leading: const Icon(Icons.phone),
                          title: const Text('Phone'),
                          subtitle: Text(phone)),
                      ListTile(
                          leading: const Icon(Icons.location_on),
                          title: const Text('Location'),
                          subtitle: Text(location)),
                      ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: const Text('Date of Birth'),
                          subtitle: Text(dob)),
                      ListTile(
                          leading: const Icon(Icons.language),
                          title: const Text('Languages'),
                          subtitle: Text(language)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'App Usage',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: const Text('Joined'),
                          subtitle: Text(joined)),
                      ListTile(
                          leading: const Icon(Icons.timer),
                          title: const Text('Total App Usage'),
                          subtitle: Text('Days: $difference')),
                      const ListTile(
                          leading: Icon(Icons.star),
                          title: Text('Favorite Feature'),
                          subtitle: Text('Push Notifications')),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        child: const Text(
                          'Home',
                          style: TextStyle(fontSize: 28, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        }),
                    ElevatedButton(
                        child: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 28, color: Colors.white),
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInPage()));
                        }),
                  ],
                ),
              ],
            )));
  }
}
