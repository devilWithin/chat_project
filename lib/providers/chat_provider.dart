import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendFirebaseMessage({
    required String textMessage,
    required String uID,
  }) async {
    await _firestore.collection('customer-service').doc(uID).set({
      'is_read': false,
      'time': Timestamp.now(),
      'sender_id': uID,
      'receiver_id': 'customer-service',
      'text_message': textMessage,
    });
    await _firestore
        .collection('customer-service')
        .doc(uID)
        .collection('messages')
        .doc()
        .set({
      'sender_id': uID,
      'is_read': false,
      'text_message': textMessage,
      'receiver_id': 'customer-service',
      'time': Timestamp.now(),
    });
  }

  List<Map<String, dynamic>> chats = [];

  Future<void> getUserAllChats() async {
    final result = await _firestore.collection('customer-service').get();
    for (var oneChat in result.docs) {
      chats.add(oneChat.data());
    }
    notifyListeners();
  }
}
