import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScoreHistory extends StatefulWidget {
  const ScoreHistory({super.key});

  @override
  State<ScoreHistory> createState() => _ScoreHistoryState();
}

class _ScoreHistoryState extends State<ScoreHistory> {
  String? userEmail = FirebaseAuth.instance.currentUser!.email;
  int highestScore = 0;

  timeFormat(Timestamp time) {
    DateTime now = time.toDate();
    String convertedTime =
        "${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
    String convertedDate =
        "${now.year.toString()}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}";
    String convertedDateTime = "$convertedTime  $convertedDate";
    return convertedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Score History'),
      ),
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

                  return Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text("$id",
                              style: const TextStyle(fontSize: 24))),
                      Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Time: $time",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text("Score: $score",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text("Level: $level",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text("Mode: $mode",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text("System: $system",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ]),
                      ),
                    ],
                  );
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
