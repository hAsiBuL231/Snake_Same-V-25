import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Functions/Functions.dart';
import 'UserChatDetailPage.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    return AlertDialog(
        title: const Text('Add User'),
        content: const Text('Tap to select:'),
        scrollable: true,
        actionsAlignment: MainAxisAlignment.start,
        actions: [
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection('user_list').snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length < 1) {
                    return const Center(child: Text('No User!'));
                  }
                  return SizedBox(
                      height: 180,
                      width: 300,
                      child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 5),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (snapshot.connectionState == ConnectionState.waiting)
                              return Center(child: CircularProgressIndicator());
                            String email = snapshot.data.docs[index].id;
                            String name = snapshot.data.docs[index]['name'];
                            if ('$email' == '$userEmail') return SizedBox.shrink();
                            return FilledButton(
                                /*onPressed: () async {
                          var user1inbox = FirebaseFirestore.instance
                              .collection('user_list')
                              .doc(userEmail)
                              .collection('inbox')
                              .doc(email);
                          var user2inbox = FirebaseFirestore.instance
                              .collection('user_list')
                              .doc(email)
                              .collection('inbox')
                              .doc(userEmail);

                          await user1inbox.collection('messages').add({
                            "message": 'Hello',
                            "type": 'send',
                            "time": DateTime.now(),
                          }).then((value) => user1inbox.set({
                                "last_message": 'Hello',
                                "last_time": DateTime.now(),
                              }));
                          await user2inbox.collection('messages').add({
                            "message": 'Hello',
                            "type": 'receive',
                            "time": DateTime.now(),
                          }).then((value) => user2inbox.set({
                                "last_message": 'Hello',
                                "last_time": DateTime.now(),
                              }));
                          Navigator.pop(context);
                        },*/
                                onPressed: () => nextPage(
                                    UserChatDetailPage(
                                      email: email,
                                      imageUrl: snapshot.data.docs[index]['imageUrl'],
                                    ),
                                    context),
                                child: Row(children: [
                                  CachedNetworkImage(
                                      imageUrl: snapshot.data.docs[index]['imageUrl'],
                                      imageBuilder: (context, imageProvider) => CircleAvatar(
                                          backgroundImage: imageProvider,
                                          maxRadius: 15,
                                          backgroundColor: Colors.blue),
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => CircleAvatar(
                                          child: Icon(Icons.account_circle,size: 32), maxRadius: 15, backgroundColor: Colors.blue)),
                                  SizedBox(width: 10),
                                  Text("$name"),
                                ]));
                          }));
                }
                return const Center(child: CircularProgressIndicator());
              })
        ]);
  }
}
