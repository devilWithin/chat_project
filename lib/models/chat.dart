import 'user.dart';

class Chat {
  int? id;
  String? recentMessage;
  String? recentMessageTime;
  User? sender;
  User? receiver;

  Chat({
    this.id,
    this.recentMessage,
    this.recentMessageTime,
    this.sender,
    this.receiver,
  });
}
