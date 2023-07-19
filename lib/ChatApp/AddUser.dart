import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../UI Design Folder/Functions.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Add User'),
        content: const Text('Tap to select:'),
        scrollable: true,
        actionsAlignment: MainAxisAlignment.start,
        actions: [
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('user_list').snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length < 1) {
                  return const Center(child: Text('No User!'));
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 16),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    String email = snapshot.data.docs[index].id;
                    _getName(email);

                    /*FirebaseFirestore.instance
                        .collection('user_list')
                        .doc(email)
                        .get()
                        .then((value) => setState(() {
                      if (value is String) {
                        name = value.toString();
                      }
                    }));*/

                    return TextButton(
                      onPressed: () async {
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
                      },
                      child: Text(email),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ]);
  }
}

String name = "NoData";
_getName(String value) async {
  var querySnapshot =
      await FirebaseFirestore.instance.collection('user_list').doc(value).get();
  var data = querySnapshot.data();
  if (data != null) name = data['name'];
}