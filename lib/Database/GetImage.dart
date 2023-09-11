import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snake_game_v_25/Database/UserForm.dart';

import '../All Functions Page/Functions.dart';

class GetImage extends StatefulWidget {
  const GetImage({super.key});

  @override
  State<GetImage> createState() => _GetImageState();
}

class _GetImageState extends State<GetImage> {
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  String imageURL = '';

  _selectPhoto(ImageSource) async {
    setState(() {
      imageURL = 'Failed';
    });
    final pickedFile = await ImagePicker().pickImage(source: ImageSource);

    if (pickedFile == null) {
      snackBar('Image Picking Failed', context);
      return;
    }

    final croppedFile = await ImageCropper().cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: pickedFile.path,
        compressQuality: 100,
        uiSettings: [WebUiSettings(context: context), IOSUiSettings(), AndroidUiSettings()]);

    if (croppedFile == null) {
      snackBar('Image Cropping Failed', context);
      return;
    }

    final Reference storageReference =
        FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
    final UploadTask uploadTask = storageReference.putFile(File(croppedFile.path));
    await uploadTask.whenComplete(() => snackBar('Photo uploaded. Wait to load the image.', context));
    String url = await storageReference.getDownloadURL();
    setState(() {
      imageURL = url;
    });
    FirebaseFirestore.instance.collection('user_list').doc(userEmail).set({
      'imageUrl': imageURL,
    }).then((value) {
      SnackBar(content: Text('Image added'));
      FirebaseAuth.instance.currentUser?.updatePhotoURL(imageURL);
    }).onError((error, stackTrace) {
      SnackBar(content: Text('Error: $error'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(children: [
                      if (imageURL == '')
                        Column(children: [
                          CircleAvatar(radius: 100, backgroundImage: AssetImage('Assets/Images/profile.jpg')),
                          SizedBox(height: 30),
                          TextButton(onPressed: () => showImagePicker(context), child: const Text('Select Image'))
                        ])
                      else if (imageURL == 'Failed')
                        Column(children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 30),
                          TextButton(onPressed: () => showImagePicker(context), child: const Text('Select Again!'))
                        ])
                      else
                        Column(children: [
                          Container(
                              decoration: ShapeDecoration(
                                  shape: CircleBorder(side: BorderSide(color: Colors.blue, width: 10))),
                              child: CircleAvatar(radius: 130, backgroundImage: NetworkImage(imageURL))),
                          SizedBox(height: 30),
                          FilledButton(
                              onPressed: () => nextPage(UserForm(), context),
                              child: const Text('OK', style: TextStyle(fontSize: 20))),
                          SizedBox(height: 30),
                          TextButton(onPressed: () => showImagePicker(context), child: const Text('Select Again!'))
                        ])
                    ])))));
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5.2,
                  margin: const EdgeInsets.only(top: 8.0),
                  padding: const EdgeInsets.all(12),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                        child: InkWell(
                            child: Column(children: const [
                              Icon(Icons.image, size: 60.0),
                              SizedBox(height: 12.0),
                              Text("Gallery",
                                  textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black))
                            ]),
                            onTap: () {
                              _selectPhoto(ImageSource.gallery);
                              Navigator.pop(context);
                            })),
                    Expanded(
                        child: InkWell(
                            child: SizedBox(
                                child: Column(children: const [
                              Icon(Icons.camera_alt, size: 60.0),
                              SizedBox(height: 12.0),
                              Text("Camera",
                                  textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black))
                            ])),
                            onTap: () {
                              _selectPhoto(ImageSource.camera);
                              Navigator.pop(context);
                            }))
                  ])));
        });
  }
}
