import 'package:chat_project/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'message_bubble.dart';

class ChatStreamBuilder extends StatefulWidget {
  final String chatId;

  const ChatStreamBuilder({Key? key, required this.chatId}) : super(key: key);

  @override
  State<ChatStreamBuilder> createState() => _ChatStreamBuilderState();
}

class _ChatStreamBuilderState extends State<ChatStreamBuilder> {
  final _fireStore = FirebaseFirestore.instance;
  bool isReplyContainerShown = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('customer-service')
          .doc(widget.chatId)
          .collection('messages')
          .orderBy('time')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
              child: Center(child: CircularProgressIndicator.adaptive()));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No Data'));
        }
        return Expanded(
          child: ListView(
            reverse: true,
            shrinkWrap: true,
            children: snapshot.data!.docs.reversed
                .map(
                  (DocumentSnapshot documentSnapshot) {
                    return MessageBubble(
                      emoji: documentSnapshot["emoji"],
                      message: documentSnapshot["text_message"],
                      isCustomerService: context
                          .read<AuthProvider>()
                          .userCredential!
                          .user!
                          .uid !=
                          documentSnapshot["sender_id"],
                      isRead: documentSnapshot["is_read"],
                      messageId: documentSnapshot.id,
                      chatId: widget.chatId,
                    );
                  }
                )
                .toList(),
          ),
        );
      },
    );
  }
}
