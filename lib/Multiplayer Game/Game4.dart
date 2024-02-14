/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game 3.dart';

class TicTacToeGame {
  List<String?> board = List.filled(9, null);
  bool player1Turn = true;

  bool makeMove(int index) {
    if (board[index] == null) {
      board[index] = player1Turn ? 'X' : 'O';
      player1Turn = !player1Turn;
      return true;
    }
    return false;
  }

  bool checkWin() {
    // Check rows, columns, and diagonals for a win
    for (int i = 0; i < 3; i++) {
      if (board[i * 3] != null && board[i * 3] == board[i * 3 + 1] && board[i * 3 + 1] == board[i * 3 + 2]) {
        return true; // Check rows
      }
      if (board[i] != null && board[i] == board[i + 3] && board[i + 3] == board[i + 6]) {
        return true; // Check columns
      }
    }
    if (board[0] != null && board[0] == board[4] && board[4] == board[8]) {
      return true; // Check diagonal \
    }
    if (board[2] != null && board[2] == board[4] && board[4] == board[6]) {
      return true; // Check diagonal /
    }

    return false;
  }

  bool checkDraw() {
    return !board.contains(null) && !checkWin();
  }

  void resetGame() {
    board = List.filled(9, null);
    player1Turn = true;
  }
}

class GameProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  late String _playerId;
  late String _roomId;

  String get playerId => _playerId;
  String get roomId => _roomId;

  Future<void> createGameRoom() async {
    try {
      _roomId = await _firestoreService.createGameRoom(_playerId);
      notifyListeners();
      _watchGameRoom();
    } catch (e) {
      print('Error creating game room: $e');
    }
  }

  StreamSubscription<GameRoom> _watchGameRoom() {
    return _firestoreService.watchGameRoom(_roomId).listen((gameRoom) {
      // Update local game state and UI based on Firestore changes
      // You can access gameRoom.board, gameRoom.player1Turn, etc.
      // and update the UI accordingly
      notifyListeners();
    });
  }

  Future<void> joinGameRoom(String roomId) async {
    try {
      await _firestoreService.joinGameRoom(roomId, _playerId);
      _roomId = roomId;
      notifyListeners();
      _watchGameRoom();
    } catch (e) {
      print('Error joining game room: $e');
    }
  }

  Future<void> makeMove(int index) async {
    try {
      final gameRoom = await _firestoreService.getGameRooms(_roomId);
      if (gameRoom != null && gameRoom.canMakeMove(_playerId, index)) {
        gameRoom.makeMove(_playerId, index);
        await _firestoreService.updateGameState(
          _roomId,
          gameRoom.board,
          gameRoom.player1Turn,
        );
      }
    } catch (e) {
      print('Error making move: $e');
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(home: HomeScreen()),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tic-Tac-Toe Game')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        gameProvider.makeMove(index);
                        */
/*if (gameProvider.makeMove(index)) {
                          // Move successful
                        } else {
                          // Invalid move (cell already filled)
                        }*//*

                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(border: Border.all()),
                        child: Center(
                          child: Text(gameProvider.board[index] ?? '', style: TextStyle(fontSize: 24)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<GameProvider>(context, listen: false).resetGame();
              },
              child: Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
