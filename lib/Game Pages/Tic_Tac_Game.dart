import 'package:flutter/material.dart';

class GameButton {
  final id;
  String text;
  Color bg;
  bool enabled;
  GameButton(
      {this.id, this.text = "", this.bg = Colors.cyan, this.enabled = true});
}

class Tik_Tak_Game extends StatefulWidget {
  @override
  _Tik_Tak_GameState createState() => new _Tik_Tak_GameState();
}

class _Tik_Tak_GameState extends State<Tik_Tak_Game> {
  late List<GameButton> buttonsList;
  var player1;
  var player2;
  var currentPlayer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonsList = doInit();
  }

  List<GameButton> doInit() {
    player1 = [];
    player2 = [];
    currentPlayer = 1;
    var gameButtons = <GameButton>[
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (currentPlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.green;
        currentPlayer = 2;
        player1.add(gb.id);
      } else {
        gb.text = "O";
        gb.bg = Colors.deepOrange;
        currentPlayer = 1;
        player2.add(gb.id);
      }
      gb.enabled = false;
      checkWinner();
    });
  }

  checkWinner() {
    var winner = -1;
    if (player1.contains(1) && player1.contains(2) && player1.contains(3)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(2) && player2.contains(3)) {
      winner = 2;
    }

    // row 2
    if (player1.contains(4) && player1.contains(5) && player1.contains(6)) {
      winner = 1;
    }
    if (player2.contains(4) && player2.contains(5) && player2.contains(6)) {
      winner = 2;
    }

    // row 3
    if (player1.contains(7) && player1.contains(8) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(7) && player2.contains(8) && player2.contains(9)) {
      winner = 2;
    }

    // col 1
    if (player1.contains(1) && player1.contains(4) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(4) && player2.contains(7)) {
      winner = 2;
    }

    // col 2
    if (player1.contains(2) && player1.contains(5) && player1.contains(8)) {
      winner = 1;
    }
    if (player2.contains(2) && player2.contains(5) && player2.contains(8)) {
      winner = 2;
    }

    // col 3
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }

    //diagonal
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }

    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }

    if (winner != -1) {
      String won = '';
      if (winner == 1) {
        won = 'X won';
      } else {
        won = '0 won';
      }
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: Text(won),
                  content: Text('Tap to play again!'),
                  actions: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) Navigator.pop(context);
                          resetGame();
                        },
                        child: Text('Play again'))
                  ]));
    }
  }

  void resetGame() {
    setState(() {
      buttonsList = doInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
              left: 10.0, top: 150.0, bottom: 10.0, right: 10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0),
          itemCount: buttonsList.length,
          itemBuilder: (context, i) => SizedBox(
            width: 100.0,
            height: 100.0,
            child: MaterialButton(
              elevation: 10.0,
              splashColor: Colors.white,
              padding: const EdgeInsets.all(10.0),
              onPressed: buttonsList[i].enabled
                  ? () => playGame(buttonsList[i])
                  : null,
              child: Text(
                buttonsList[i].text,
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
}
