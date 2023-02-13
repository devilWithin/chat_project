import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/emoji.dart';

class EmojiContainer extends StatefulWidget {
  final String chatId;
  final String messageId;
  final VoidCallback onPickingEmoji;

  const EmojiContainer(
      {Key? key,
      required this.chatId,
      required this.messageId,
      required this.onPickingEmoji})
      : super(key: key);

  @override
  State<EmojiContainer> createState() => _EmojiContainerState();
}

class _EmojiContainerState extends State<EmojiContainer>
    with SingleTickerProviderStateMixin {
  final _fireStore = FirebaseFirestore.instance;
  bool isEmojiSelected = false;
  Emoji emoji = Emoji();
  List<Emoji> emojis = [
    Emoji(
      isSelected: false,
      emoji: "😂",
    ),
    Emoji(
      isSelected: false,
      emoji: "♥️",
    ),
    Emoji(
      isSelected: false,
      emoji: "🥺",
    ),
    Emoji(
      isSelected: false,
      emoji: "😡",
    ),
    Emoji(
      isSelected: false,
      emoji: "💋",
    ),
    Emoji(
      isSelected: false,
      emoji: "😋",
    ),
  ];

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  )..forward();
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, 0.2),
    end: const Offset(-0.1, 0.1),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final result = await _fireStore
        .collection('customer-service')
        .doc(widget.chatId)
        .collection('messages')
        .doc(widget.messageId)
        .get();
    emoji.emoji = result.data()!['emoji'];
    for (var oneEmo in emojis) {
      if (emoji.emoji == oneEmo.emoji) {
        setState(() {
          emoji.isSelected = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
              emojis.length,
              (index) => GestureDetector(
                    onTap: () async {
                      if (emoji.emoji == emojis[index].emoji) {
                        widget.onPickingEmoji();
                        await _fireStore
                            .collection('customer-service')
                            .doc(widget.chatId)
                            .collection('messages')
                            .doc(widget.messageId)
                            .update({'emoji': null});
                        await _fireStore
                            .collection('customer-service')
                            .doc(widget.chatId)
                            .update({
                          'emoji': null,
                        });
                      } else {
                        widget.onPickingEmoji();
                        await _fireStore
                            .collection('customer-service')
                            .doc(widget.chatId)
                            .collection('messages')
                            .doc(widget.messageId)
                            .update({'emoji': emojis[index].emoji});
                        await _fireStore
                            .collection('customer-service')
                            .doc(widget.chatId)
                            .update({
                          'emoji': emojis[index].emoji,
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: (emoji.emoji != null &&
                                emojis[index].emoji!.contains(emoji.emoji!) &&
                                emoji.isSelected)
                            ? Colors.grey
                            : null,
                      ),
                      child: Text(emojis[index].emoji!,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  )),
        ),
      ),
    );
  }
}
