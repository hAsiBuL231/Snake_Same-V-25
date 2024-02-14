import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameRoom {
  final String id;
  final String player1;
  final String player2;

  GameRoom({required this.id, required this.player1, required this.player2});
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createGameRoom(String playerId) async {
    try {
      // Create a new game room
      DocumentReference roomRef = await _firestore.collection('game_rooms').add({'player1': playerId, 'player2': null});

      return roomRef.id;
    } catch (e) {
      print('Error creating game room: $e');
      return '';
    }
  }

  Stream<List<GameRoom>> getGameRooms() {
    try {
      // Stream of available game rooms
      return _firestore.collection('game_rooms').snapshots().map((snapshot) {
        return snapshot.docs
            .where((doc) => doc.data()['player2'] == null)
            .map((doc) => GameRoom(id: doc.id, player1: doc.data()['player1'], player2: doc.data()['player2']))
            .toList();
      });
    } catch (e) {
      print('Error getting game rooms: $e');
      return Stream.value([]);
    }
  }

  Future<void> joinGameRoom(String roomId, String playerId) async {
    try {
      // Join a game room
      await _firestore.collection('game_rooms').doc(roomId).update({'player2': playerId});
    } catch (e) {
      print('Error joining game room: $e');
    }
  }
}

class MyApp2 extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Tic-Tac-Toe')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  // Create a new game room
                  String roomId = await firestoreService.createGameRoom('player1');
                  print('Created Game Room: $roomId');
                },
                child: Text('Create Game Room'),
              ),
              StreamBuilder<List<GameRoom>>(
                stream: firestoreService.getGameRooms(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  List<GameRoom> gameRooms = snapshot.data!;
                  return Column(
                    children: gameRooms.map((gameRoom) {
                      return ElevatedButton(
                        onPressed: () async {
                          // Join a game room
                          await firestoreService.joinGameRoom(gameRoom.id, 'player2');
                          print('Joined Game Room: ${gameRoom.id}');
                        },
                        child: Text('Join Game Room ${gameRoom.id}'),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
