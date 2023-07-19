import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snake_game_v_25/UI%20Design%20Folder/Functions.dart';
import 'package:snake_game_v_25/UI%20Design%20Folder/HomePage.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  UserFormState createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  final GlobalKey<FormState> formKey5 = GlobalKey<FormState>();

  final userName = FirebaseAuth.instance.currentUser?.displayName;
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  var userImage = FirebaseAuth.instance.currentUser?.photoURL;

  final String _message = 'Personal information saved successfully!';
  String error = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _dobController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (formKey5.currentState!.validate()) {
      try {
        CollectionReference users =
            FirebaseFirestore.instance.collection('user_list');
        DateTime now = DateTime.now();
        DateTime date = DateTime(now.year, now.month, now.day);
        // Add the user data to Firestore
        await users
            .doc(userEmail)
            .set({
              'name': _nameController.text,
              'email': userEmail.toString(),
              'profession': _professionController.text,
              'phone': _phoneController.text,
              'location': _locationController.text,
              'dob': _dobController.text,
              'language': _languageController.text,
              'joined': date,
            })
            .then((value) => const SnackBar(content: Text('Data added')))
            .catchError((error) => SnackBar(content: Text('Error: $error')));

        FirebaseAuth.instance.currentUser!
            .updateDisplayName(_nameController.text);

        // Clear the form fields
        _nameController.clear();
        _professionController.clear();
        _phoneController.clear();
        _locationController.clear();
        _dobController.clear();
        _languageController.clear();
      } on FirebaseException catch (e) {
        setState(() {
          error = e.message.toString();
        });
      }

      // Show a success dialog
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: const Text('Success'),
                  content: Text(_message),
                  actions: [
                    TextButton(
                        onPressed: () {
                          newPage(const HomePage(), context);
                        },
                        child: const Text('OK'))
                  ]));
    }
  }

  Future<void> _selectPhoto() async {
    //List<Media>? pickedFile =
    //    await ImagesPicker.pick(count: 1, pickType: PickType.image);
    //var image = pickedFile?.first;
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    //XFile image = await ImagePickerAndroid.pickImage(source: Images);

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
  }

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
          child: Column(
            children: [
              Image.asset('Assets/cover.png', height: 150.0),
              const SizedBox(height: 16.0),
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage('$userImage'),
              ),
              TextButton(
                  onPressed: () {
                    _selectPhoto();
                  },
                  child: const Text('Select Image')),
              const SizedBox(height: 10.0),
              Text(error),
              TextFormField(
                validator: (value) {
                  if (value == '') {
                    return 'Please enter your Name!';
                  } else {
                    return null;
                  }
                },
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.account_circle, color: Colors.blue),
                  labelText: 'Name',
                  hintText: '$userName',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                validator: (value) {
                  if (value == '') {
                    return 'Please enter your Profession!';
                  } else {
                    return null;
                  }
                },
                controller: _professionController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.work, color: Colors.blue),
                  labelText: 'Profession',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                validator: (value) {
                  if (value!.length < 11 && int.tryParse(value) == null) {
                    return 'Please enter a valid number!';
                  } else {
                    return null;
                  }
                },
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                validator: (value) {
                  if (value == '') {
                    return 'Please enter a location!';
                  } else {
                    return null;
                  }
                },
                controller: _locationController,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                validator: (value) {
                  if (value == '') {
                    return 'Please enter your Date of Birth!';
                  } else {
                    return null;
                  }
                },
                controller: _dobController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: Icon(Icons.date_range, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                validator: (value) {
                  if (value == '') {
                    return 'Please enter a language!';
                  } else {
                    return null;
                  }
                },
                controller: _languageController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Languages',
                  prefixIcon: Icon(Icons.language, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
