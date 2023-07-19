import 'package:flutter/material.dart';
import '../Database/GameScores.dart';
import '../Game%20Pages/ManualPageOpen.dart';
import '../Game%20Pages/Tic_Tac_Game.dart';
import '../Settings%20Folder/GameSettings.dart';
import '../Settings%20Folder/InfoPage.dart';
import 'Functions.dart';
import '../Game Pages/GamePageBoxed.dart';
import '../Game Pages/GamePageOpen.dart';
import '../Game Pages/ManualPageBoxed.dart';
import '../Settings Folder/DrawerPage.dart';
import '../Database/globals.dart';

class SnakeGamePage extends StatefulWidget {
  const SnakeGamePage({Key? key}) : super(key: key);
  @override
  SnakeGamePageState createState() => SnakeGamePageState();
}

class SnakeGamePageState extends State<SnakeGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        drawer: const DrawerPage(),
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: const Text("Flutter Snake Game",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            actions: <Widget>[
              /*IconButton(
                onPressed: () => nextPage(const AllPagesClass(), context),
                icon: const Icon(Icons.list_alt)),*/
              popUpMenu(),
            ]),
        body: Center(
          child: Column(children: <Widget>[
            const SizedBox(height: 280),
            Column(children: [
              GestureDetector(
                onTap: () {
                  if (gSystem == 'Touch') {
                    if (gMode == 'Opened') {
                      return nextPage(const GamePageOpen(), context);
                    } else {
                      return nextPage(const GamePageBoxed(), context);
                    }
                  } else {
                    if (gMode == 'Opened') {
                      return nextPage(const ManualPageOpen(), context);
                    } else {
                      return nextPage(const ManualPageBoxed(), context);
                    }
                  }
                },
                child: const Image(
                    image: AssetImage('Assets/Buttons/play.png'),
                    height: 80,
                    width: 80),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => nextPage(GameScores(), context),
                    child: const Image(
                        image: AssetImage('Assets/Buttons/leader.png'),
                        height: 80,
                        width: 80),
                  ),
                  const SizedBox(width: 30),
                  GestureDetector(
                    onTap: () => nextPage(GameSettings(), context),
                    child: const Image(
                        image: AssetImage('Assets/Buttons/settings.png'),
                        height: 80,
                        width: 80),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(
                  onTap: () => nextPage(Tik_Tak_Game(), context),
                  child: const Image(
                      image: AssetImage('Assets/Buttons/games.png'),
                      height: 80,
                      width: 80),
                ),
                const SizedBox(width: 30),
                GestureDetector(
                    onTap: () => nextPage(const InfoPage(), context),
                    child: const Image(
                        image: AssetImage('Assets/Buttons/about.png'),
                        height: 80,
                        width: 80)),
              ]),
            ]),
          ]),
        ));
  }
}
