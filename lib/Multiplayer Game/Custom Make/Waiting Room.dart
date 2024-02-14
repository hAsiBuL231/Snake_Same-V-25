import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Waiting_Room_Class {
  final int? playerCount;
  final List<String>? players;

  Waiting_Room_Class({this.playerCount, this.players});

  factory Waiting_Room_Class.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Waiting_Room_Class(
      playerCount: data?['playerCount'],
      players: data?['players'] is Iterable ? List.from(data?['players']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (playerCount != null) "playerCount": playerCount,
      if (players != null) "players": players,
    };
  }
}

/// //////////////////////////////////////////////    UI Part   ///////////////////////////

class waitingRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Waiting Room')),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Waiting for another player to join...'), CircularProgressIndicator()])),
      floatingActionButton: FloatingActionButton(onPressed: () async {}, child: Icon(Icons.arrow_forward)),
    );
  }
}
