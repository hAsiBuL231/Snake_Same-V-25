import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Functions.dart';

class DeleteUser extends StatelessWidget {
  final String user;
  const DeleteUser({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(Icons.account_circle, color: Colors.blue, size: 50),
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Are you sure?'),
      content: Text('This will delete this conversation!'),
      actions: [
        ElevatedButton(
            onPressed: () {
              String? userEmail = FirebaseAuth.instance.currentUser?.email;
              FirebaseFirestore.instance
                  .collection('user_list')
                  .doc(userEmail)
                  .collection('inbox')
                  .doc(user)
                  .delete()
                  .then((value) => snackBar('Conversation is deleted.', context));
            },
            child: Text('Yes')),
        ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('No')),
      ],
    );
  }
}

class DeleteMessage extends StatelessWidget {
  final String user;
  final String id;
  const DeleteMessage({super.key, required this.user, required this.id});

  @override
  Widget build(BuildContext context) {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    var user1inbox = FirebaseFirestore.instance
        .collection('user_list')
        .doc(userEmail)
        .collection('inbox')
        .doc(user)
        .collection('messages')
        .doc(id);
    var user2inbox = FirebaseFirestore.instance
        .collection('user_list')
        .doc(user)
        .collection('inbox')
        .doc(userEmail)
        .collection('messages')
        .doc(id);

    return AlertDialog(
      icon: Icon(Icons.dangerous_outlined, color: Colors.blue, size: 50),
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Are you sure?'),
      content: Text('This will delete this message!'),
      actions: [
        ElevatedButton(
            onPressed: () {
              user1inbox.delete();
              user2inbox.delete().then((value) {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: Text('Message is deleted!'),
                        actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Ok'))]));
              });
            },
            child: Text('Unsent Message')),
        ElevatedButton(
            onPressed: () {
              user1inbox.delete().then((value) {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: Text('Message deleted!'),
                        actions: [ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Ok'))]));
              });
            },
            child: Text('Delete from you only')),
        ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
      ],
    );
  }
}
