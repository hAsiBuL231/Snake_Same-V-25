import 'package:cloud_firestore/cloud_firestore.dart';

class Game_Room_Class {
  final List<String>? players;

  Game_Room_Class({this.players});

  factory Game_Room_Class.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Game_Room_Class(
      players: data?['regions'] is Iterable ? List.from(data?['regions']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (players != null) "regions": players,
    };
  }
}
