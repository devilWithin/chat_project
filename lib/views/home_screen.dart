import 'package:chat_project/providers/auth_provider.dart';
import 'package:chat_project/providers/chat_provider.dart';
import 'package:chat_project/views/chat_screen.dart';
import 'package:chat_project/widgets/chat_head.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await context.read<ChatProvider>().getUserAllChats();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Chats'),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          chatId: context
                              .read<AuthProvider>()
                              .userCredential!
                              .user!
                              .uid),
                    ));
                  },
                  child: const Icon(Icons.add))
            ],
          ),
          elevation: 0,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('customer-service')
              .orderBy('time')
              .snapshots(),
          builder: (context, snapshot) {
            List<Widget> chatWidgets = [];
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else {
              final chats = snapshot.data!.docs.reversed;
              for (var chat in chats) {
                final recentMessage = chat.get('text_message');
                final isRead = chat.get('is_read');
                final senderName = chat.get('sender_id');
                final recentMessageTime = chat.get('time');
                final chatHead = ChatHead(
                  recentMessage: recentMessage,
                  senderName: senderName,
                  timestamp: recentMessageTime,
                  chatId: chat.id,
                  isRead: isRead,
                );
                chatWidgets.add(chatHead);
              }
              return ListView(
                children: chatWidgets,
              );
            }
          },
        ),
      );
    });
  }
}
