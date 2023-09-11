import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Database/UserData.dart';
import '../Database/UserForm.dart';
import '../Database/UserProfile.dart';
import '../Authentication/ForgetPasswordPage.dart';
import '../Authentication/SignInPage.dart';
import '../Authentication/SignUpPage.dart';
import '../All Functions Page/Functions.dart';
import 'WelcomePage.dart';

class AllPagesClass extends StatefulWidget {
  const AllPagesClass({Key? key}) : super(key: key);

  @override
  State<AllPagesClass> createState() => _AllPagesClassState();
}

class _AllPagesClassState extends State<AllPagesClass> {
  List<DropdownMenuItem<Object>> hi = [];
  // Initial Selected Value
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          bottomOpacity: 0.5,
          elevation: 80,
          foregroundColor: Colors.amber,
          shadowColor: Colors.black,
          leading: IconButton(onPressed: () => nextPage(WelcomePage(), context), icon: const Icon(Icons.cabin)),
          backgroundColor: Colors.blue,
          shape: const RoundedRectangleBorder(
              //borderRadius: BorderRadiusDirectional.circular(20)),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(25), right: Radius.circular(25))),
          title: const Text('All Pages'),
          actions: const [Icon(Icons.ac_unit)],
          bottom: const PreferredSize(preferredSize: Size(20, 20), child: Text('Appbar'))),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                var doc_ref = FirebaseFirestore.instance
                    .collection('user_list')
                    .doc('hossainhasibul2@gmail.com')
                    .collection('inbox')
                    .doc('test@gmail.com')
                    .collection('messages')
                    .orderBy("time", descending: true)
                    .limit(1);
                var docSnap = await doc_ref.get();
                var doc_id2 = docSnap.docs[0].id;
                print("\n\n $doc_id2 \n\n");
                print('object');
              },
              child: const Text("ElevatedButton : Page"),
            ),
            ElevatedButton(
              onPressed: () => nextPage(const SignInPage(), context),
              child: const Text("ElevatedButton : SignInPage"),
            ),
            TextButton(
                onPressed: () => nextPage(const SignUpPage(), context),
                child: const Text("TextButton : SignUpPage")),
            TextButton(
                onPressed: () => nextPage(const ForgetPasswordPage(), context),
                child: const Text('TextButton : ForgetPasswordPage')),
            FilledButton(
                onPressed: () => nextPage(const UserForm(), context),
                child: const Text("FilledButton : UserForm")),
            TextButton(onPressed: () => nextPage(UserData(), context), child: const Text("TextButton : UserData")),
            OutlinedButton(
                onPressed: () => nextPage(const UserProfile(), context),
                child: const Text("OutlinedButton : UserProfile")),
            IconButton(onPressed: () => nextPage(WelcomePage(), context), icon: const Icon(Icons.login)),
            DropdownButton(
                // Initial Value
                value: dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(value: items, child: Text(items));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() => dropdownvalue = newValue!);
                }),
            DropdownButton(items: const [
              DropdownMenuItem(value: 1, child: Text('Option 1')),
              DropdownMenuItem(value: 2, child: Text('Option 2')),
              DropdownMenuItem(value: 3, child: Text('Option 3')),
              DropdownMenuItem(value: 4, child: Text('Option 4')),
              DropdownMenuItem(value: 5, child: Text('Option 5')),
            ], onChanged: (int? value) {}),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              BackButton(onPressed: () => Navigator.pop(context)),
              CloseButton(onPressed: () => SystemNavigator.pop())
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              FilledButton(onPressed: () => nextPage(WelcomePage(), context), child: const Text("FilledButton")),
              MaterialButton(
                  onPressed: () => nextPage(WelcomePage(), context), child: const Text('Material Button'))
            ]),
          ],
        ),
      ),
    );
  }
}
