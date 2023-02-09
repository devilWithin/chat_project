import 'package:chat_project/models/user.dart';

import '../models/chat.dart';

class ChatGenerator {

  List<Chat> generateChats() {
    return List.generate(
      10,
      (index) => Chat(
        id: index,
        recentMessage: "This is message number ${index + 1}",
        recentMessageTime: DateTime.now().toString(),
        sender: User(
            id: index + 100,
            name: 'Sender no ${index + 1}',
            profileImage: String.fromCharCode(index + 65)),
        receiver: User(
          id: index + 200,
          name: 'User number ${index + 2}',
          profileImage: String.fromCharCode(index + 65),
        ),
      ),
    );
  }
}
