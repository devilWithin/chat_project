import 'package:chat_project/providers/auth_provider.dart';
import 'package:chat_project/providers/chat_provider.dart';
import 'package:chat_project/widgets/chat_stream_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
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
              const ChatStreamBuilder(),
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
                          if(_textMessageController.text.isNotEmpty){
                            String message = _textMessageController.text;
                            _textMessageController.clear();
                            await value.sendFirebaseMessage(
                              textMessage: message,
                              uID: context
                                  .read<AuthProvider>()
                                  .userCredential!
                                  .user!
                                  .uid,
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
