/*_getData() async {
    userEmail = FirebaseAuth.instance.currentUser?.email;
    var querySnapshot = await FirebaseFirestore.instance
        .collection('user_list')
        .where(FieldPath([userEmail!]))
        .get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      var data = queryDocumentSnapshot.data();
      setState(() {
        phone = data['phone'];
        profession = data['profession'];
        location = data['location'];
        dob = data['dob'];
        language = data['language'];
        Timestamp getTime = data['joined'];
        DateTime joinTime = getTime.toDate();
        joined = joinTime.toString();
        DateTime time = DateTime.now();
        DateTime currentDate = DateTime(time.year, time.month, time.day);
        difference = currentDate.difference(joinTime).inDays.toString();
      });
    }
    return;
  }*/

/*sdsfdsf(Timestamp _time) {
  DateTime joinTime = _time.toDate();
  //var joinTime = _time.toString();
  DateTime time = DateTime.now();
  DateTime currentDate = DateTime(time.year, time.month, time.day);
  int diff1 = time.difference(joinTime).inDays;
  joinTime = joinTime.subtract(Duration(days: diff1));
  int diff2 = time.difference(joinTime).inHours;
  //String diff2 = time.difference(joinTime).inHours.toString();
  //String diff2 = DateTime.now().difference(time).inHours.toString();
  String diff= "$diff1.$diff2";
  return diff;
}*/