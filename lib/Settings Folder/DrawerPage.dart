import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_game_v_25/Authentication/SignInPage.dart';
import 'package:snake_game_v_25/ChatApp/ChatPage.dart';
import 'package:snake_game_v_25/Database/Leaderboard.dart';

import '../ChatApp/UserChatDetailPage.dart';
import '../Database/UserProfile.dart';
import '../All Functions Page/Functions.dart';
import 'GameSettings.dart';
import 'InfoPage.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    String? userName = FirebaseAuth.instance.currentUser?.displayName;
    String? userImage = FirebaseAuth.instance.currentUser?.photoURL;

    return Drawer(
        child: Column(children: [
      Flexible(
          child: ListView(children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('Assets/cover.png'), fit: BoxFit.cover)),
          accountName: Text(userName ?? 'No Data',
              style: const TextStyle(
                  color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, backgroundColor: Colors.white)),
          accountEmail: Text(userEmail ?? 'No Data',
              style: const TextStyle(
                  color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold, backgroundColor: Colors.white)),
          currentAccountPicture: //"$userImage",
              CachedNetworkImage(
            imageUrl: '$userImage',
            imageBuilder: (context, imageProvider) =>
                CircleAvatar(backgroundImage: imageProvider, backgroundColor: Colors.blue),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        const Divider(),
        ListTile(
            splashColor: Colors.amber,
            iconColor: Colors.blue,
            textColor: Colors.blue,
            leading: const Icon(Icons.account_circle),
            title: const Text("Profile"),
            onTap: () => nextPage(const UserProfile(), context)),
        ListTile(
            splashColor: Colors.amber,
            iconColor: Colors.blue,
            textColor: Colors.blue,
            leading: const Icon(Icons.info_outline),
            title: const Text("Info"),
            onTap: () => nextPage(const InfoPage(), context)),
        ListTile(
            splashColor: Colors.amber,
            iconColor: Colors.blue,
            textColor: Colors.blue,
            leading: const Icon(Icons.leaderboard),
            title: const Text("Leaderboard"),
            onTap: () => nextPage(Leaderboard(), context)),
        ListTile(
            splashColor: Colors.amber,
            iconColor: Colors.blue,
            textColor: Colors.blue,
            leading: Icon(Icons.help_outline),
            title: Text("Help & Support"),
            onTap: () => nextPage(ChatPage(), context)),
        ListTile(
          splashColor: Colors.amber,
          iconColor: Colors.blue,
          textColor: Colors.blue,
          leading: Icon(Icons.feedback_outlined),
          title: Text("Feedback"),
          onTap: () => nextPage(
              UserChatDetailPage(
                  email: 'hossainhasibul2@gmail.com', imageUrl: 'gs://project1-be966.appspot.com/profile.jpg'),
              context),
        ),
        ListTile(
            splashColor: Colors.amber,
            iconColor: Colors.blue,
            textColor: Colors.blue,
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () => nextPage(GameSettings(), context)),
        ListTile(
            splashColor: Colors.amber,
            iconColor: Colors.blue,
            textColor: Colors.blue,
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              newPage(SignInPage(), context);
            }),
        ListTile(
            splashColor: Colors.amber,
            iconColor: Colors.blue,
            textColor: Colors.blue,
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Exit'),
            onTap: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop')),
        SizedBox(height: 15),
        Center(
            child: Hero(
                tag: 'footer',
                child: Text('Made with ♥ by MD. Hasibul Hossain',
                    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700))))
      ]))
    ]));
  }
}
