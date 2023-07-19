import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_game_v_25/Authentication/SignInPage.dart';

import '../Database/GameScores.dart';
import '../Database/UserProfile.dart';
import '../UI Design Folder/Functions.dart';
import 'GameSettings.dart';
import 'InfoPage.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Flexible(
            child: ListView(children: <Widget>[
              UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('Assets/cover.png'),
                          fit: BoxFit.cover)),
                  accountName: Text(userName ?? 'No Data',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.white)),
                  accountEmail: Text(userEmail ?? 'No Data',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.white)),
                  currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(userImage!),
                      backgroundColor: Colors.blue)),
              const Divider(),
              ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text("Profile"),
                  onTap: () => nextPage(const UserProfile(), context)),
              ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("Info"),
                  onTap: () => nextPage(const InfoPage(), context)),
              ListTile(
                  leading: const Icon(Icons.leaderboard),
                  title: const Text("Leaderboard"),
                  onTap: () => nextPage(GameScores(), context)),
              const ListTile(
                  leading: Icon(Icons.help_outline),
                  title: TextButton(
                      child: Text("Help & Support"), onPressed: null)),
              const ListTile(
                  leading: Icon(Icons.feedback_outlined),
                  title: TextButton(child: Text("Feedback"), onPressed: null)),
              ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Settings"),
                  onTap: () => nextPage(GameSettings(), context)),
              ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    nextPage(context, SignInPage());
                  }),
              ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Exit'),
                  onTap: () => SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop')),
            ]),
          ),
        ],
      ),
    );
  }
}
