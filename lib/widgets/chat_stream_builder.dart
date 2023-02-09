import 'package:chat_project/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'message_bubble.dart';

class ChatStreamBuilder extends StatefulWidget {
  const ChatStreamBuilder({Key? key}) : super(key: key);

  @override
  State<ChatStreamBuilder> createState() => _ChatStreamBuilderState();
}

class _ChatStreamBuilderState extends State<ChatStreamBuilder> {
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('customer-service')
          .doc(context.read<AuthProvider>().userCredential!.user!.uid)
          .collection('messages')
          .orderBy('time')
          .snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble> messageWidgets = [];
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageText = message.get('text_message');
          final senderId = message.get('sender_id');
          final messageWidget = MessageBubble(
            message: messageText,
            isCustomerService: context.read<AuthProvider>().userCredential!.user!.uid != senderId,
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            shrinkWrap: true,
            children: messageWidgets,
          ),
        );
      },
    );
  }
}
