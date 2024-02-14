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

class GameRoom {
  String board;
  int currentPlayerTurn;
  String player1;
  String player2;

  GameRoom({this.board = "", this.currentPlayerTurn = 1, this.player1 = "", this.player2 = ""});
}

class TikTakGame extends StatefulWidget {
  @override
  _TikTakGameState createState() => _TikTakGameState();
}

class _TikTakGameState extends State<TikTakGame> {
  late var _gameRoomRef;
  late List<GameButton> buttonsList;
  GameRoom room = GameRoom();
  var currentPlayerUid;
  var currentPlayerTurn;

  @override
  void initState() {
    super.initState();
    _gameRoomRef = FirebaseFirestore.instance.doc("gameRooms/your_game_room_id");
    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    currentPlayerUid = userEmail; // Replace with actual user authentication UID
    room.player1 = currentPlayerUid;
    //_gameRoomRef.update({'player1': currentPlayerUid});
    buttonsList = doInit();
    room.currentPlayerTurn = 1;
    _gameRoomRef.set(room);
  }

  List<GameButton> doInit() {
    var gameButtons = List.generate(9, (index) => GameButton(id: index + 1));
    return gameButtons;
  }

  void playGame(GameButton gb) {
    if (currentPlayerUid == true) {
      _gameRoomRef.update({'${gb.id}': currentPlayerTurn});
      checkWinner();
      _gameRoomRef.update({'currentPlayerTurn': 3 - currentPlayerTurn}); // Switch player turn
    }
  }

  void checkWinner() {
    var board = List.filled(9, 0); // Initialize an empty board
    _gameRoomRef.collection('board').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        Map<dynamic, dynamic>? boardData = doc.data() as Map?;
        if (boardData != null) {
          boardData.forEach((key, value) {
            board[int.parse(key) - 1] = value;
          });

          // Check for the winner
          var winner = -1;
          for (var i = 0; i < 3; i++) {
            if (board[i] != 0 && board[i] == board[i + 3] && board[i] == board[i + 6]) {
              winner = board[i];
            }
            if (board[i * 3] != 0 && board[i * 3] == board[i * 3 + 1] && board[i * 3] == board[i * 3 + 2]) {
              winner = board[i * 3];
            }
          }
          if (board[0] != 0 && board[0] == board[4] && board[0] == board[8]) {
            winner = board[0];
          }
          if (board[2] != 0 && board[2] == board[4] && board[2] == board[6]) {
            winner = board[2];
          }

          if (winner != -1) {
            String won = (winner == 1) ? 'X won' : 'O won';
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: Text(won),
                  content: Text('Tap to play again!'),
                  actions: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) Navigator.pop(context);
                          resetGame();
                        },
                        child: Text('Play again'))
                  ]),
            );
          }
        }
      });
    });
  }

  void resetGame() {
    _gameRoomRef.update({'board': '', 'winner': '', 'player1': '', 'player2': '', 'currentPlayerTurn': 1});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Tic-Tac'), backgroundColor: Colors.cyan, centerTitle: true),
      body: Center(
        child: GridView.builder(
          padding: const EdgeInsets.only(left: 10.0, top: 150.0, bottom: 10.0, right: 10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.0, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0),
          itemCount: buttonsList.length,
          itemBuilder: (context, i) => SizedBox(
            width: 100.0,
            height: 100.0,
            child: MaterialButton(
                onPressed: buttonsList[i].enabled ? () => playGame(buttonsList[i]) : null,
                child: Text(getSymbolFromBoardState(buttonsList[i].id), style: TextStyle(color: Colors.white, fontSize: 20.0)),
                color: buttonsList[i].bg,
                disabledColor: buttonsList[i].bg),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10.0,
        label: Text('Restart'),
        icon: Icon(Icons.all_inclusive),
        onPressed: () => resetGame(),
      ),
    );
  }

  String getSymbolFromBoardState(int buttonId) {
    // Fetch the symbol from the Firestore board state based on the buttonId
    // Example: return 'X' or 'O'
    return '';
  }
}
*/
