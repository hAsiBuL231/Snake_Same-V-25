import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData extends StatefulWidget {
  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  Future<List<DocumentSnapshot>> _getDataFromFirebase() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    CollectionReference users = FirebaseFirestore.instance.collection('user_list');

    // Query the collection to get all documents
    var snapshot = await users.where(FieldPath(['$userEmail'])).get();

    // Return the list of documents
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Data')),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _getDataFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No user data available'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('Profession')),
                DataColumn(label: Text('Location')),
                DataColumn(label: Text('Date of Birth')),
                DataColumn(label: Text('Language')),
                DataColumn(label: Text('First Login')),
              ],
              rows: snapshot.data!.map((document) {
                Map<String, dynamic>? data =
                    document.data() as Map<String, dynamic>?;
                Timestamp time = data!['joined'];
                DateTime joined = time.toDate();
                return DataRow(
                  cells: [
                    DataCell(Text(data['name'] ?? '')),
                    DataCell(Text(data['email'] ?? '')),
                    DataCell(Text(data['phone'] ?? '')),
                    DataCell(Text(data['profession'] ?? '')),
                    DataCell(Text(data['location'] ?? '')),
                    DataCell(Text(data['dob'] ?? '')),
                    DataCell(Text(data['language'] ?? '')),
                    DataCell(Text(joined.toString())),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
