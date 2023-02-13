import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? textMessage;
  String? senderId;
  String? receiverId;
  String? emoji;
  Timestamp? timestamp;
  bool isRead;
  String? replyText;
  String? replyTextId;

  Message({
    this.textMessage,
    this.receiverId,
    this.senderId,
    this.emoji,
    this.timestamp,
    this.isRead = false,
    this.replyText,
    this.replyTextId,
  });
}