import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../UI Design Folder/Functions.dart';

class UserChatDetailPage extends StatefulWidget {
  final String email;
  const UserChatDetailPage({super.key, required this.email});

  @override
  State<UserChatDetailPage> createState() => _UserChatDetailPageState();
}

class _UserChatDetailPageState extends State<UserChatDetailPage> {
  TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
              child: Container(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(children: <Widget>[
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon:
                            const Icon(Icons.arrow_back, color: Colors.black)),
                    const SizedBox(width: 2),
                    const CircleAvatar(
                        //backgroundImage: AssetImage('images/snake.png'),
                        backgroundColor: Colors.blue,
                        maxRadius: 20,
                        child: Icon(Icons.person,
                            size: 40.0, color: Colors.white)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(widget.email,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            const Text("Online", style: TextStyle(fontSize: 13))
                          ]),
                    ),
                    const Icon(Icons.settings, color: Colors.black54),
                  ])))),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('user_list')
                .doc(userEmail)
                .collection('inbox')
                .doc(widget.email)
                .collection('messages')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length < 1) {
                  return const Center(child: Text('Say Hi!'));
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  reverse: true,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    String messageType = snapshot.data.docs[index]['type'];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                          alignment: (messageType == "receive"
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (messageType == "receive"
                                    ? Colors.grey.shade200
                                    : Colors.blue[200])),
                            padding: const EdgeInsets.all(16),
                            child: Text(snapshot.data.docs[index]['message'],
                                style: const TextStyle(fontSize: 16)),
                          )),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                      child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(30)),
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 20))),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: message,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  FloatingActionButton(
                      onPressed: () async {
                        String msg = message.text;
                        message.clear();
                        var user1inbox = FirebaseFirestore.instance
                            .collection('user_list')
                            .doc(userEmail)
                            .collection('inbox')
                            .doc(widget.email);
                        var user2inbox = FirebaseFirestore.instance
                            .collection('user_list')
                            .doc(widget.email)
                            .collection('inbox')
                            .doc(userEmail);

                        await user1inbox.collection('messages').add({
                          "message": msg,
                          "type": 'send',
                          "time": DateTime.now(),
                        }).then((value) => user1inbox.set({
                              "last_message": msg,
                              "last_time": DateTime.now(),
                            }));
                        await user2inbox.collection('messages').add({
                          "message": msg,
                          "type": 'receive',
                          "time": DateTime.now(),
                        }).then((value) => user2inbox.set({
                              "last_message": msg,
                              "last_time": DateTime.now(),
                            }));
                      },
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      child: const Icon(Icons.send,
                          color: Colors.white, size: 18)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
