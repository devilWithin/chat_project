import 'package:chat_project/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  bool isReplyContainerShown = false;

  Future<void> sendFirebaseMessage({
    required Message message,
  }) async {
    await _fireStore.collection('customer-service').doc(message.senderId).set({
      'is_read': message.isRead,
      'time': message.timestamp,
      'sender_id': message.senderId,
      'receiver_id': message.receiverId,
      'text_message': message.textMessage,
      'emoji': message.emoji,
      'reply_text': message.replyText,
      'reply_text_id': message.replyTextId,
    });
    await updateRecentMessage(message: message);
  }

  Future<void> updateRecentMessage({
    required Message message,
}) async {
    await _fireStore
        .collection('customer-service')
        .doc(message.senderId)
        .collection('messages')
        .doc()
        .set({
      'is_read': message.isRead,
      'time': message.timestamp,
      'sender_id': message.senderId,
      'receiver_id': message.receiverId,
      'text_message': message.textMessage,
      'emoji': message.emoji,
      'reply_text': message.replyText,
      'reply_text_id': message.replyTextId,
    });
  }

  List<Map<String, dynamic>> chats = [];

  Future<void> getUserAllChats() async {
    final result = await _fireStore.collection('customer-service').get();
    for (var oneChat in result.docs) {
      chats.add(oneChat.data());
    }
    notifyListeners();
  }

  void openReplyDialog({
  required String textMessage,
  required String messageId,
}) async {
    isReplyContainerShown = true;
    notifyListeners();
    setReplyMessage(textMessage: textMessage,messageId: messageId);
  }

  Message replyMessage = Message();

  Future<void> setReplyMessage({
  required String textMessage,
  required String messageId,
}) async {
    if(isReplyContainerShown) {
      replyMessage.textMessage = textMessage;
    }
  }

  void closeReplyDialog() {
    isReplyContainerShown = false;
    notifyListeners();
  }
}
