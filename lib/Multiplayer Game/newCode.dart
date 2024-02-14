/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GameButton {
  final int id;
  String text;
  Color bg;
  bool enabled;

  GameButton({required this.id, this.text = "", this.bg = Colors.cyan, this.enabled = true});
}

class TikTakGame extends StatefulWidget {
  @override
  _TikTakGameState createState() => _TikTakGameState();
}

class _TikTakGameState extends State<TikTakGame> {
  late CollectionReference _gameRoomsCollection;
  late DocumentReference _gameRoomRef;
  late List<GameButton> buttonsList;
  var currentPlayerUid;
  var currentPlayerTurn;

  @override
  void initState() {
    super.initState();
    _gameRoomsCollection = FirebaseFirestore.instance.collection('gameRooms');
    currentPlayerUid = FirebaseAuth.instance.currentUser!.uid; // Replace with actual user authentication UID
    buttonsList = doInit();
    currentPlayerTurn = 1;
    //joinWaitingRoom();
  }

  List<GameButton> doInit() {
    var gameButtons = List.generate(9, (index) => GameButton(id: index + 1));
    return gameButtons;
  }

*/
/*
  Future<void> joinWaitingRoom() async {
    QuerySnapshot waitingRooms = await _gameRoomsCollection.where('status', isEqualTo: 'waiting').limit(1).get();

    if (waitingRooms.docs.isNotEmpty) {
      _gameRoomRef = waitingRooms.docs.first.reference;
      _gameRoomRef.update({
        'status': 'playing',
        'players': {'player1': currentPlayerUid, 'player2': ''},
        'currentPlayerTurn': 1,
      });
      listenToChanges();
    } else {
      _gameRoomRef = await _gameRoomsCollection.add({
        'status': 'waiting',
        'players': {'player1': currentPlayerUid, 'player2': ''},
        'currentPlayerTurn': 1,
      });
      listenToChanges();
    }
  }
*/ /*


  void listenToChanges() {
    _gameRoomRef.snapshots().listen((DocumentSnapshot snapshot) {
      var data = snapshot.data() as Map<String, dynamic>;

      if (data['players']['player2'] != '' && data['status'] == 'playing') {
        // Both players are in, start the game
        startGame();
      }
    });
  }

  void startGame() {
    setState(() {
      // Your logic to start the game
    });
  }

  void playGame(GameButton gb) {
    if (currentPlayerUid ==
        _gameRoomRef.get().then((DocumentSnapshot snapshot) {
          _gameRoomRef.collection('board').doc('${gb.id}').set({'value': currentPlayerTurn});
          checkWinner();
          _gameRoomRef.update({'currentPlayerTurn': 3 - currentPlayerTurn}); // Switch player turn
        })) ;
  }

  void checkWinner() {
    // Your logic to check for a winner
  }

  void resetGame() {
    // Your logic to reset the game
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Tic-Tac'),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: Center(
        child: GridView.builder(
          padding: const EdgeInsets.only(
            left: 10.0,
            top: 150.0,
            bottom: 10.0,
            right: 10.0,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: buttonsList.length,
          itemBuilder: (context, i) => SizedBox(
            width: 100.0,
            height: 100.0,
            child: MaterialButton(
              onPressed: buttonsList[i].enabled ? () => playGame(buttonsList[i]) : null,
              child: Text(
                getSymbolFromBoardState(buttonsList[i].id),
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              color: buttonsList[i].bg,
              disabledColor: buttonsList[i].bg,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10.0,
        label: Text('Restart'),
        icon: Icon(Icons.all_inclusive),
        onPressed: () {
          resetGame();
        },
      ),
    );
  }

  String getSymbolFromBoardState(int buttonId) {
    // Your logic to fetch the symbol from the Firestore board state based on the buttonId
    return '';
  }
}
*/
