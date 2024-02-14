/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'usingOOP.dart';

class WaitingRoomScreen extends StatelessWidget {
  final CollectionReference _waitingRoomRef = FirebaseFirestore.instance.collection('waitingRoom');
  final CollectionReference _gameRoomsRef = FirebaseFirestore.instance.collection('gameRooms');
  final String? currentPlayerUid = FirebaseAuth.instance.currentUser!.email;

  Future<void> joinWaitingRoom(BuildContext context) async {
    await _waitingRoomRef.doc(currentPlayerUid).set({'isWaiting': true});

    // Check if there's another player in the waiting room
    var snapshot = await _waitingRoomRef.count();
    int cnt = snapshot;
    Map<String, dynamic>? waitingRoomData = snapshot.data() as Map<String, dynamic>?;

    if (waitingRoomData != null && waitingRoomData.length > 1) {
      startGame(context);
    } else {
      // Wait for another player to join
      _waitingRoomRef.doc().snapshots().listen((event) async {
        // Retrieve the updated data from the event snapshot directly
        Map<String, dynamic>? updatedData = event.data() as Map<String, dynamic>?;
        if (updatedData != null && updatedData.length > 1) {
          startGame(context);
        }
      });
    }
  }

  void startGame(BuildContext context) async {
    // Create a game room
    DocumentReference gameRoomRef = await _gameRoomsRef.add({'player1': currentPlayerUid});

    // Remove player from the waiting room
    await _waitingRoomRef.doc(currentPlayerUid).delete();

    // Navigate to the game room
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TikTakGame()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Waiting Room')),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Waiting for another player to join...'), CircularProgressIndicator()])),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await joinWaitingRoom(context);
          },
          child: Icon(Icons.arrow_forward)),
    );
  }
}
*/
