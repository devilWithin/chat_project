
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../views/chat_screen.dart';

class ChatHead extends StatelessWidget {
  final String senderName;
  final String recentMessage;
  final Timestamp timestamp;
  final String chatId;
  final bool isRead;
  const ChatHead({Key? key, required this.senderName, required this.recentMessage, required this.timestamp, required this.chatId, required this.isRead}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatScreen(chatId: chatId),
        ));
      },
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.tealAccent[700],
              child: Text(
                String.fromCharCode(67),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(senderName,style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: !isRead ? FontWeight.w900 : null,
                  ),),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(recentMessage,style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: !isRead ? FontWeight.w900 : null,
                      ),),
                      Text(DateFormat('yyyy-MM-dd hh:mm a').format(
                          DateTime.parse(timestamp.toDate()
                              .toString())),style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: !isRead ? FontWeight.w900 : null,
                      ),),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
