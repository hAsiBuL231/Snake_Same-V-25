import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Functions/Functions.dart';
import 'ScoreHistory.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Score Leaderboard')),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('user_list').snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length < 1) {
                        return const Center(child: Text('No User!'));
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            int id = index + 1;
                            String email = snapshot.data.docs[index].id;
                            String name = snapshot.data.docs[index]['name'];
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
                                    child: Row(children: [
                                      Container(
                                          margin: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 5),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.amber, borderRadius: BorderRadius.circular(10)),
                                          child: Text("$id", style: const TextStyle(fontSize: 24))),
                                      Expanded(
                                          child: Container(
                                              margin: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 20),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.lightBlueAccent,
                                                  borderRadius: BorderRadius.circular(20)),
                                              child: Column(children: [
                                                Text(name,
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                                SizedBox(height: 5),
                                                StreamBuilder(
                                                    stream: FirebaseFirestore.instance
                                                        .collection('user_list')
                                                        .doc(email)
                                                        .collection('scores')
                                                        .orderBy("score", descending: true)
                                                        .limit(1)
                                                        .snapshots(),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.waiting)
                                                        return Center(child: CircularProgressIndicator());
                                                      if (snapshot.hasData) {
                                                        if (snapshot.data!.docs.length < 1) {
                                                          return Text('No data available');
                                                        }
                                                        return ListView.builder(
                                                            physics: NeverScrollableScrollPhysics(),
                                                            padding: EdgeInsets.all(0),
                                                            shrinkWrap: true,
                                                            itemCount: snapshot.data?.docs.length,
                                                            itemBuilder: (context, index) {
                                                              int score = snapshot.data?.docs[index]['score'];
                                                              return Center(
                                                                  child: Text('$score',
                                                                      style: TextStyle(
                                                                          fontSize: 20,
                                                                          fontWeight: FontWeight.bold)));
                                                            });
                                                      }
                                                      return Text('Something went wrong');
                                                    })
                                              ])))
                                    ])));
                          });
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () => nextPage(const ScoreHistory(), context),
                  child: Text('See Your History', style: TextStyle(fontSize: 20))),
            )
          ],
        ));
  }
}
