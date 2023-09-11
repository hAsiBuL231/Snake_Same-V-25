import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../All Functions Page/Functions.dart';

class ScoreHistory extends StatefulWidget {
  const ScoreHistory({super.key});

  @override
  State<ScoreHistory> createState() => _ScoreHistoryState();
}

class _ScoreHistoryState extends State<ScoreHistory> {
  String? userEmail = FirebaseAuth.instance.currentUser!.email;
  int highestScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Score History')),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('user_list')
              .doc(userEmail)
              .collection('scores')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              if (snapshot.data.docs.length < 1) {
                return const Center(child: Text('Play a game to see history'));
              }
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  int id = snapshot.data.docs.length - index;
                  int score = snapshot.data.docs[index]['score'];
                  String time = timeFormat(snapshot.data.docs[index]['time']);
                  var level = snapshot.data.docs[index]['level'];
                  String mode = snapshot.data.docs[index]['mode'];
                  String system = snapshot.data.docs[index]['system'];
                  if (level == 200) level = 'Easy';
                  if (level == 150) level = 'Medium';
                  if (level == 100) level = 'Hard';
                  return Card(
                      color: Colors.blue,
                      elevation: 20,
                      margin: EdgeInsets.all(20),
                      borderOnForeground: true,
                      semanticContainer: true,
                      surfaceTintColor: Colors.amber,
                      shape: OutlineInputBorder(borderRadius: BorderRadius.zero),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration:
                                      BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)),
                                  child: Text("$id", style: const TextStyle(fontSize: 24))),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 20),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent, borderRadius: BorderRadius.circular(20)),
                                  child: Column(children: [
                                    Text("Time: $time", style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Score: $score", style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Level: $level", style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Mode: $mode", style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text("System: $system", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ]),
                                ),
                              ),
                            ],
                          )));
                },
              );
            }
            return const Center(
              child: Text('Sorry! Something went wrong!'),
            );
          }),
    );
  }
}
