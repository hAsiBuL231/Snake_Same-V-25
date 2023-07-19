import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snake_game_v_25/Database/ScoreHistory.dart';

import '../UI Design Folder/Functions.dart';

class GameScores extends StatefulWidget {
  @override
  GameScoresState createState() => GameScoresState();
}

class GameScoresState extends State<GameScores> {
  int highestScore = 0;

  Future<List<DocumentSnapshot>> _getDataFromFirebase() async {
    CollectionReference scores =
        FirebaseFirestore.instance.collection('scores');
    var snapshot = await scores.where(FieldPath(['$userEmail'])).get();

    return snapshot.docs;
  }

  //Stream<QuerySnapshot> _scoresStream =
  //    FirebaseFirestore.instance.collection('scores').where(FieldPath(['$userEmail'])).get().snapshots();

  @override
  Widget build(BuildContext context) {
    int profileH = MediaQuery.of(context).size.height.toInt();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Scores'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: profileH - 150,
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: _getDataFromFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Something went wrong'));
                }

                return ListView(
                  children: snapshot.data!.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    highestScore = data['score'];
                    return ListTile(
                      title: Text(data['player']),
                      subtitle: Text('Highest Score: $highestScore'),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          ElevatedButton(
              onPressed: () => nextPage(const ScoreHistory(), context),
              child: const Text('See Your History')),
        ],
      ),
    );
  }
}
