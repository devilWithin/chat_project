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
      'time' : Timestamp.now(),
    });
    await _firestore
        .collection('customer-service')
        .doc(uID)
        .collection('messages')
        .doc()
        .set({
      'sender_id': uID,
      'text_message': textMessage,
      'receiver_id': 'customer-service',
      'is_recent_message': true,
      'time': Timestamp.now(),
    });
  }
}
