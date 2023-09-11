import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../All Functions Page/Functions.dart';
import 'package:snake_game_v_25/Database/GetImage.dart';
import 'package:snake_game_v_25/UI%20Page/HomePage.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  UserFormState createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  final GlobalKey<FormState> formKey5 = GlobalKey<FormState>();

  final userName = FirebaseAuth.instance.currentUser?.displayName;
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  final imageURL = FirebaseAuth.instance.currentUser?.photoURL;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();

  /*@override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _dobController.dispose();
    _languageController.dispose();
    super.dispose();
  }*/

  Future<void> _submitForm() async {
    if (formKey5.currentState!.validate()) {
      try {
        CollectionReference users = FirebaseFirestore.instance.collection('user_list');
        DateTime now = DateTime.now();
        DateTime date = DateTime(now.year, now.month, now.day);
        // Add the user data to Firestore
        await users.doc(userEmail).update({
          //'imageUrl': imageURL,
          'name': _nameController.text,
          'profession': _professionController.text,
          'phone': _phoneController.text,
          'location': _locationController.text,
          'dob': _dobController.text,
          'language': _languageController.text,
          'joined': date,
        }).then((value) {
          SnackBar(content: Text('Data added'));
          //FirebaseAuth.instance.currentUser?.updatePhotoURL(imageURL);
        }).onError((error, stackTrace) {
          SnackBar(content: Text('Error: $error'));
        });
        //.catchError((error) => SnackBar(content: Text('Error: $error')));

        FirebaseAuth.instance.currentUser!.updateDisplayName(_nameController.text);

        // Clear the form fields
        _nameController.clear();
        _professionController.clear();
        _phoneController.clear();
        _locationController.clear();
        _dobController.clear();
        _languageController.clear();
        _photoController.clear();
      } catch (e) {
        setState(() => snackBar(e.toString(), context));
      }

      // Show a success dialog
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: const Text('Success'),
                  content: Text("Personal information saved successfully!"),
                  actions: [
                    TextButton(onPressed: () => newPage(const HomePage(), context), child: const Text('OK'))
                  ]));
    }
  }

  /*_selectPhoto() async {
    setState(() {
      imageURL = 'Failed';
    });
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    final Reference storageReference =
        FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
    final UploadTask uploadTask = storageReference.putFile(File(pickedFile!.path));
    await uploadTask.whenComplete(() => snackBar('Photo uploaded', context));
    setState(() async {
      imageURL = await storageReference.getDownloadURL();
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Personal Information'),
          backgroundColor: Colors.blueAccent,
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: formKey5,
                child: Column(children: [
                  //Image.asset('Assets/cover.png', height: 150.0),
                  const SizedBox(height: 16.0),
                  Container(
                      decoration:
                          ShapeDecoration(shape: CircleBorder(side: BorderSide(color: Colors.blue, width: 10))),
                      child: CircleAvatar(radius: 80, backgroundImage: NetworkImage(imageURL!))),
                  TextButton(onPressed: () => nextPage(GetImage(), context), child: Text('Change Photo')),
                  const SizedBox(height: 10.0),
                  TextFormField(
                      validator: (value) {
                        if (value == '')
                          return 'Please enter your Name!';
                        else
                          return null;
                      },
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: '$userName',
                          prefixIcon: const Icon(Icons.account_circle, color: Colors.blue))),
                  const SizedBox(height: 16.0),
                  TextFormField(
                      validator: (value) {
                        if (value == '')
                          return 'Please enter your Profession!';
                        else
                          return null;
                      },
                      controller: _professionController,
                      decoration: const InputDecoration(
                          labelText: 'Profession', prefixIcon: Icon(Icons.work, color: Colors.blue))),
                  const SizedBox(height: 16.0),
                  TextFormField(
                      validator: (value) {
                        if (value!.length < 11 || int.tryParse(value) == null)
                          return 'Please enter your number!';
                        else
                          return null;
                      },
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          labelText: 'Phone', prefixIcon: Icon(Icons.phone, color: Colors.blue))),
                  const SizedBox(height: 16.0),
                  TextFormField(
                      validator: (value) {
                        if (value == '')
                          return 'Please enter a location!';
                        else
                          return null;
                      },
                      controller: _locationController,
                      keyboardType: TextInputType.streetAddress,
                      decoration: const InputDecoration(
                          labelText: 'Location', prefixIcon: Icon(Icons.location_on, color: Colors.blue))),
                  const SizedBox(height: 16.0),
                  TextFormField(
                      validator: (value) {
                        if (value == '')
                          return 'Please enter your Date of Birth!';
                        else
                          return null;
                      },
                      readOnly: true,
                      controller: _dobController,
                      //keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                          labelText: 'Date of Birth', prefixIcon: Icon(Icons.date_range, color: Colors.blue)),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now());
                        String formattedDate = '';
                        if (pickedDate != null) {
                          //String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                          formattedDate = DateFormat(pickedDate);
                        }
                        setState(() => _dobController.text = formattedDate);
                      }),
                  const SizedBox(height: 16.0),
                  TextFormField(
                      validator: (value) {
                        if (value == '')
                          return 'Please enter a language!';
                        else
                          return null;
                      },
                      controller: _languageController,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                          labelText: 'Languages', prefixIcon: Icon(Icons.language, color: Colors.blue))),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Submit', style: TextStyle(fontSize: 28, color: Colors.white)))
                ]))));
  }
}

DateFormat(DateTime time) {
  DateTime now = time;
  //String convertedTime = "${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
  String convertedDate =
      "${now.year.toString()}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}";
  return convertedDate;
}
