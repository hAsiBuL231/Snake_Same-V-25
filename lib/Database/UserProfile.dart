import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:snake_game_v_25/Database/UserForm.dart';
import '../All Functions Page/Functions.dart';
import 'package:snake_game_v_25/UI%20Page/HomePage.dart';

import '../Authentication/SignInPage.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  String? userEmail = FirebaseAuth.instance.currentUser!.email;
  String? userImage = FirebaseAuth.instance.currentUser!.photoURL;
  Reference ref = FirebaseStorage.instance.ref().child('profile.jpg');

  String imageUrl = 'loading..';
  String name = 'loading..';
  String phone = 'loading..';
  String profession = 'loading..';
  String location = 'loading..';
  String dob = 'loading..';
  String language = 'loading..';
  String joined = 'loading..';
  String difference = 'loading..';

  _getData() async {
    //.where(FieldPath([userEmail!]))
    userEmail = FirebaseAuth.instance.currentUser!.email;
    var querySnapshot = await FirebaseFirestore.instance.collection('user_list').doc(userEmail).get();
    var data = querySnapshot.data();
    if (data == null) {
      setState(() {
        imageUrl = 'Please set data..';
        name = 'Please set data..';
        phone = 'Please set data..';
        profession = 'Please set data..';
        location = 'Please set data..';
        dob = 'Please set data..';
        language = 'Please set data..';
        joined = 'Please set data..';
        difference = 'Please set data..';
      });
    } else {
      setState(() {
        imageUrl = data['imageUrl'];
        name = data['name'];
        phone = data['phone'];
        profession = data['profession'];
        location = data['location'];
        dob = data['dob'];
        language = data['language'];
        Timestamp getTime = data['joined'];
        DateTime joinTime = getTime.toDate();
        joined = timeFormat(getTime);
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
                          colors: [Colors.blue, Colors.purple])),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                            decoration: ShapeDecoration(
                                shape: CircleBorder(side: BorderSide(color: Colors.blue, width: 5))),
                            child:
                                CircleAvatar(radius: 50, backgroundImage: CachedNetworkImageProvider(imageUrl))),
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => CircleAvatar(
                            child: Icon(Icons.account_circle,size: 50), radius: 50, backgroundColor: Colors.blue),
                      ),
                      /*CachedNetworkImage(
                        imageUrl: imageUrl,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            CircularProgressIndicator(value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      if (imageUrl.isNotEmpty)
                        Container(
                            decoration: ShapeDecoration(
                                shape: CircleBorder(side: BorderSide(color: Colors.blue, width: 5))),
                            child: CircleAvatar(radius: 50, backgroundImage: CachedNetworkImageProvider(imageUrl)))
                      else
                        CircleAvatar(radius: 50, backgroundImage: AssetImage('Assets/logo.png')),*/
                      const SizedBox(width: 10.0),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(height: 8.0),
                        Text(name,
                            style:
                                const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8.0),
                        Text(profession, style: const TextStyle(fontSize: 16, color: Colors.white))
                      ])
                    ]),
                    const SizedBox(height: 16.0),
                    Row(children: [
                      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Followers', style: TextStyle(fontSize: 16, color: Colors.white)),
                        SizedBox(height: 4.0),
                        Text('1.2k',
                            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold))
                      ]),
                      const SizedBox(width: 16.0),
                      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Following', style: TextStyle(fontSize: 16, color: Colors.white)),
                        SizedBox(height: 4.0),
                        Text('980',
                            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold))
                      ]),
                      const SizedBox(width: 100.0),
                      FloatingActionButton(
                          onPressed: () => nextPage(const UserForm(), context),
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.edit_outlined, color: Colors.white, size: 45))
                    ])
                  ])),
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
                    ListTile(leading: const Icon(Icons.person), title: const Text('Name'), subtitle: Text(name)),
                    ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text('$userEmail')),
                    ListTile(leading: const Icon(Icons.phone), title: const Text('Phone'), subtitle: Text(phone)),
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
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('user_list')
                            .doc(userEmail)
                            .collection('scores')
                            .orderBy("score", descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.length < 1) {
                              return ListTile(
                                  leading: Icon(Icons.leaderboard_outlined),
                                  title: Text('Highest Score'),
                                  subtitle: Text('No data available'));
                            }
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  int score = snapshot.data?.docs[index]['score'];
                                  return ListTile(
                                      leading: Icon(Icons.leaderboard_outlined),
                                      title: Text('Highest Score'),
                                      subtitle: Text('Score: $score'));
                                });
                          }
                          return ListTile(
                              leading: Icon(Icons.leaderboard_outlined),
                              title: Text('Highest Score'),
                              subtitle: Text('Something went wrong'));
                        }),
                    ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('Joined'),
                        subtitle: Text(joined)),
                    ListTile(
                        leading: const Icon(Icons.timer),
                        title: const Text('Total App Usage'),
                        subtitle: Text('Days: $difference')),
                    ListTile(
                        leading: Icon(Icons.star),
                        title: Text('Favorite Feature'),
                        subtitle: Text('Push Notifications')),
                  ],
                ),
              ),
              Center(
                  child: FilledButton(
                onPressed: () {},
                child: TextButton.icon(
                    onPressed: () => nextPage(HomePage(), context),
                    icon: Icon(Icons.home_sharp, size: 35, color: Colors.amber),
                    label: Text('Home', style: TextStyle(fontSize: 30, color: Colors.white))),
              ))
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          newPage(SignInPage(), context);
        },
        tooltip: 'Logout',
        child: Icon(Icons.logout_rounded),
        backgroundColor: Colors.green,
      ),
    );
  }
}
