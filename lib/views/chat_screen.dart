import 'package:chat_project/models/message.dart';
import 'package:chat_project/providers/auth_provider.dart';
import 'package:chat_project/providers/chat_provider.dart';
import 'package:chat_project/widgets/chat_stream_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Service"),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChatStreamBuilder(chatId: widget.chatId),
              if (context.read<ChatProvider>().isReplyContainerShown)
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          context.read<ChatProvider>().closeReplyDialog();
                        },
                        child: const Icon(Icons.close),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                                    context.read<ChatProvider>().replyMessage.textMessage ?? '')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 30,
                        child: TextField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          controller: _textMessageController,
                          decoration: const InputDecoration(
                            hintText: 'Type your message...',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: IconButton(
                        onPressed: () async {
                          if (_textMessageController.text.isNotEmpty) {
                            String message = _textMessageController.text;
                            _textMessageController.clear();
                            await value.sendFirebaseMessage(
                              message: Message(
                                textMessage: message,
                                isRead: false,
                                receiverId: 'customer-service',
                                senderId: context
                                    .read<AuthProvider>()
                                    .userCredential!
                                    .user!
                                    .uid,
                                timestamp: Timestamp.now(),
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
