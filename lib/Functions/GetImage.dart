import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snake_game_v_25/Database/UserForm.dart';

import 'Functions.dart';

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
                  TextButton(
                      onPressed: () => _selectPhoto(ImageSource.gallery),
                      child: const Text('Select Image From Gallery')),
                  SizedBox(height: 30),
                  TextButton(
                      onPressed: () => _selectPhoto(ImageSource.camera),
                      child: const Text('Select Image From Camera')),
                ])
              else if (imageURL == 'Failed')
                Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 30),
                    TextButton(
                        onPressed: () => _selectPhoto(ImageSource.gallery),
                        child: const Text('Select Again From Gallery')),
                    SizedBox(height: 30),
                    TextButton(
                        onPressed: () => _selectPhoto(ImageSource.camera),
                        child: const Text('Select Again From Camera')),
                  ],
                )
              else
                Column(children: [
                  Container(
                      decoration: ShapeDecoration(shape: CircleBorder(side: BorderSide(color: Colors.blue,width: 10))),
                      child: CircleAvatar(radius: 130, backgroundImage: NetworkImage(imageURL))),
                  SizedBox(height: 30),
                  FilledButton(
                      onPressed: () => UserForm(), child: const Text('OK', style: TextStyle(fontSize: 20))),
                  SizedBox(height: 30),
                  TextButton(
                      onPressed: () => _selectPhoto(ImageSource.gallery),
                      child: const Text('Select Again From Gallery')),
                  TextButton(
                      onPressed: () => _selectPhoto(ImageSource.camera),
                      child: const Text('Select Again From Camera')),
                ]),
            ]),
          ),
        ),
      ),
    );
  }
}
