import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snake_game_v_25/ChatApp/UserChatDetailPage.dart';
import 'package:snake_game_v_25/UI%20Design%20Folder/Functions.dart';

class ShowConversationList extends StatefulWidget {
  final String email;
  final String name;
  final String messageText;
  final Timestamp time;
  const ShowConversationList(
      {super.key,
      required this.name,
      required this.messageText,
      required this.time,
      required this.email});
  @override
  ShowConversationListState createState() => ShowConversationListState();
}

class ShowConversationListState extends State<ShowConversationList> {
  timeFormat(Timestamp time) {
    DateTime now = time.toDate();
    String convertedTime =
        "${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
    String convertedDate =
        "${now.year.toString()}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}";
    String convertedDateTime = "$convertedTime\n$convertedDate";
    return convertedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => nextPage(
          UserChatDetailPage(
            email: widget.email,
          ),
          context),
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.white60),
        child: Expanded(
          child: Row(
            children: <Widget>[
              const CircleAvatar(
                //backgroundImage: AssetImage(widget.imageUrl),
                backgroundColor: Colors.blue,
                maxRadius: 25,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18)),
                        //const SizedBox(height: 6),
                        Text(widget.messageText,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                    Text(timeFormat(widget.time),
                        style: const TextStyle(fontSize: 12))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
