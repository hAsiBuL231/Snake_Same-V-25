import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snake_game_v_25/Functions/Functions.dart';

class ForContext extends StatefulWidget {
  final String email;
  const ForContext({super.key, required this.email});

  @override
  State<ForContext> createState() => ForContextState();
}

class ForContextState extends State<ForContext> {
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  late File imageFile;

  bool isLoading = false;

  String imageUrl = '';

  TextEditingController textEditingController = TextEditingController();

  ScrollController scrollController = ScrollController();

  /*UploadTask uploadImageFile(File image, String filename) {
    Reference reference = FirebaseStorage.instance.ref().child(filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }*/

  Future getImage(email, ImageSource) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      /*setState(() {
        isLoading = true;
      });*/
      _uploadImageFile(email);
    }
  }

  void _uploadImageFile(email) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child('$userEmail/$fileName');
    UploadTask uploadTask = reference.putFile(imageFile);
    //UploadTask uploadTask = uploadImageFile(imageFile, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      /*setState(() {
        isLoading = false;
        //onSendMessage(imageUrl, MessageType.image);
      });*/
      urlMessage(email, imageUrl);
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      snackBar(e.message.toString(), context);
    }
  }

  urlMessage(email, imageUrl) async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    var user1inbox =
        FirebaseFirestore.instance.collection('user_list').doc(userEmail).collection('inbox').doc(email);
    var user2inbox =
        FirebaseFirestore.instance.collection('user_list').doc(email).collection('inbox').doc(userEmail);

    await user1inbox.collection('messages').add({
      "url": imageUrl,
      "type": 'send',
      "time": DateTime.now(),
    }).then((value) => user1inbox.set({
          "last_message": 'Sent a photo',
          "last_time": DateTime.now(),
        }));

    var doc_ref = user1inbox.collection('messages').orderBy("time", descending: true).limit(1);
    //FirebaseFirestore.instance.collection("data").snapshots().last
    var docSnap = await doc_ref.get();
    var doc_id = docSnap.docs[0].id;

    await user2inbox.collection('messages').doc(doc_id).set({
      "url": imageUrl,
      "type": 'receive',
      "time": DateTime.now(),
    }).then((value) => user2inbox.set({
          "last_message": 'Sent a photo',
          "last_time": DateTime.now(),
        }));
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.add, color: Colors.white, size: 25),
      itemBuilder: (context) => [
        PopupMenuItem(value: 1, child: Row(children: [Icon(Icons.photo), SizedBox(width: 10), Text("Photo")])),
        PopupMenuItem(
            value: 2, child: Row(children: [Icon(Icons.photo_camera), SizedBox(width: 10), Text("Camera")])),
      ],
      offset: Offset(0, 100),
      //color: Colors.grey,
      elevation: 2,
      onSelected: (value) {
        if (value == 1) {
          getImage(widget.email, ImageSource.gallery);
        } else if (value == 2) {
          getImage(widget.email, ImageSource.camera);
        }
      },
    );
  }
}

/*Future<void> getLostData() async {
    final LostDataResponse response = await ImagePicker().retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    final List<XFile>? files = response.files;
    if (files != null) {
      //_handleLostFiles(files);
    } else {
      //_handleError(response.exception);
    }
  }

  Future<void> _selectPhoto() async {
    //List<Media>? pickedFile =
    //    await ImagesPicker.pick(count: 1, pickType: PickType.image);
    //var image = pickedFile?.first;
    XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    //XFile image = await ImagePickerAndroid.pickImage(source: Images);
    final LostDataResponse response = await ImagePicker().retrieveLostData();
    if (!response.isEmpty) {
      final List<XFile>? files = response.files;
      if (files != null) {
        pickedImage = files.first;
      }
    }
    if (pickedImage != null) {
      try {
        Reference ref = FirebaseStorage.instance.ref().child('profile.jpg');
        await ref.putString(pickedImage.path);
        ref.getDownloadURL().then((value) {
          if (kDebugMode) {
            print(value);
          }
          FirebaseAuth.instance.currentUser?.updatePhotoURL(value);
          userImage = FirebaseAuth.instance.currentUser?.photoURL;
        });
      } catch (e) {
        setState(() {
          error = e.toString();
        });
      }
    }
  }*/

/*void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      //sendChatMessage(content, type, groupChatId, currentUserId, widget.peerId);
      scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      snackBar('Nothing to send', context);
    }
  }*/

/*void sendChatMessage(String content, int type, String groupChatId, String currentUserId, String peerId) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    ChatMessages chatMessages = ChatMessages(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: type);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatMessages.toJson());
    });
  }*/
