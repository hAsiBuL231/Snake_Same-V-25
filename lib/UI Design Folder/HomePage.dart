import 'package:flutter/material.dart';
import 'package:snake_game_v_25/UI%20Design%20Folder/SnakeGamePage.dart';

import '../ChatApp/ChatPage.dart';
import '../Database/UserProfile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const ChatPage(),
    const SnakeGamePage(),
    const UserProfile(),
  ];
  decoration() {
    if (_selectedIndex == 1) {
      return const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("Assets/background.png"), fit: BoxFit.cover));
    } else {
      return const BoxDecoration(color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: decoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 30,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey.shade600,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: "Chats",
                //activeIcon: ChatPage()
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.videogame_asset),
                label: "Games",
                //activeIcon: Tik_Tak_Game()
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box),
                label: "Profile",
                //activeIcon: UserProfile()
              ),
            ],
          ),
        ));
  }
}
