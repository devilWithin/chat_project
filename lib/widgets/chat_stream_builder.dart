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
        List<MessageBubble> messageWidgets = [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(child: Center(child: CircularProgressIndicator.adaptive()));
        }
        if(!snapshot.hasData) {
          return const Center(child: Text('No Data'));
        }
        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageId = message.id;
          final messageText = message.get('text_message');
          final senderId = message.get('sender_id');
          final isRead = message.get('is_read');
          final messageWidget = MessageBubble(
            messageId: messageId,
            chatId: widget.chatId,
            message: messageText,
            isRead: isRead,
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
