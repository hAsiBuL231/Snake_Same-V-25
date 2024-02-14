import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class GameRoom {
  final String id;
  final String player1;
  final String player2;

  GameRoom({required this.id, required this.player1, required this.player2, required List<String?> board, required player1Turn});
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createGameRoom(String playerId) async {
    try {
      DocumentReference roomRef = await _firestore.collection('game_rooms').add({'player1': playerId, 'player2': null});

      return roomRef.id;
    } catch (e) {
      print('Error creating game room: $e');
      rethrow;
    }
  }

  Stream<List<GameRoom>> getGameRooms(String roomId) {
    try {
      return _firestore.collection('game_rooms').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return GameRoom(id: doc.id, player1: doc['player1'], player2: doc['player2'], board: [], player1Turn: null);
        }).toList();
      });
    } catch (e) {
      print('Error getting game rooms: $e');
      rethrow;
    }
  }

  Future<void> joinGameRoom(String roomId, String playerId) async {
    try {
      await _firestore.collection('game_rooms').doc(roomId).update({'player2': playerId});
    } catch (e) {
      print('Error joining game room: $e');
      rethrow;
    }
  }


  Future<void> updateGameState(String roomId, List<String?> board, bool player1Turn) async {
    try {
      await _firestore.collection('game_rooms').doc(roomId).update({
        'board': board,
        'player1Turn': player1Turn,
      });
    } catch (e) {
      print('Error updating game state: $e');
      rethrow;
    }
  }

  Stream<GameRoom> watchGameRoom(String roomId) {
    return _firestore.collection('game_rooms').doc(roomId).snapshots().map((snapshot) {
      return GameRoom(
        id: snapshot.id,
        player1: snapshot['player1'],
        player2: snapshot['player2'],
        board: List<String?>.from(snapshot['board'] ?? List.filled(9, null)),
        player1Turn: snapshot['player1Turn'] ?? true,
      );
    });
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
    } catch (e) {
      print('Error creating game room: $e');
    }
  }

  Stream<List<GameRoom>> getGameRooms() {
    return _firestoreService.getGameRooms(_roomId);
  }

  Future<void> joinGameRoom(String roomId) async {
    try {
      await _firestoreService.joinGameRoom(roomId, _playerId);
      _roomId = roomId;
      notifyListeners();
    } catch (e) {
      print('Error joining game room: $e');
    }
  }
}

class MyApp3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(home: HomeScreen3()),
    );
  }
}

class HomeScreen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tic-Tac-Toe Game')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            onPressed: () async {
              await Provider.of<GameProvider>(context, listen: false).createGameRoom();
            },
            child: Text('Create Game Room'),
          ),
          StreamBuilder<List<GameRoom>>(
            stream: Provider.of<GameProvider>(context).getGameRooms(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No available game rooms');
              }

              return Column(
                children: snapshot.data!.map((room) {
                  return ElevatedButton(
                    onPressed: () async {
                      await Provider.of<GameProvider>(context, listen: false).joinGameRoom(room.id);
                    },
                    child: Text('Join Room ${room.id}'),
                  );
                }).toList(),
              );
            },
          ),
        ]),
      ),
    );
  }
}
