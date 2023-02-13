import 'package:chat_project/providers/chat_provider.dart';
import 'package:chat_project/widgets/emoji_container.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'emoji_widget.dart';

class MessageBubble extends StatefulWidget {
  final String message;
  final bool isCustomerService;
  final bool isRead;
  final String messageId;
  final String chatId;
  final String? emoji;

  const MessageBubble(
      {Key? key,
      required this.message,
      required this.isCustomerService,
      required this.isRead,
      required this.messageId,
      required this.chatId,
      this.emoji})
      : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  bool isEmojiContainerShown = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, 0.0),
    end: const Offset(-0.3, 0.0),
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEmojiContainerShown = false;
        });
      },
      onDoubleTap: () async {
        setState(() {
          isEmojiContainerShown = true;
        });
      },
      onHorizontalDragStart: (DragStartDetails dragStartDetails) {
        _controller.forward();
      },
      onHorizontalDragEnd: (DragEndDetails dragEndDetails) async {
        await _controller.reverse();
        if (!mounted) return;
        context.read<ChatProvider>().openReplyDialog(
              textMessage: widget.message,
              messageId: widget.messageId,
            );
        print(widget.messageId);
        print(widget.message);
      },
      child: SlideTransition(
        position: _offsetAnimation,
        child: Column(
          crossAxisAlignment: widget.isCustomerService
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (isEmojiContainerShown)
              EmojiContainer(
                  chatId: widget.chatId,
                  messageId: widget.messageId,
                  onPickingEmoji: () {
                    setState(() {
                      isEmojiContainerShown = false;
                    });
                  }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: widget.isCustomerService
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  Stack(
                    alignment: widget.emoji != null
                        ? Alignment.bottomLeft
                        : Alignment.bottomCenter,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(32)),
                          child: RichText(
                            text: TextSpan(
                              recognizer: LongPressGestureRecognizer()
                                ..onLongPress = () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: widget.message));
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Copied to Clipboard!'),
                                    ),
                                  );
                                },
                              text: widget.message,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          )),
                      widget.emoji != null
                          ? EmojiWidget(
                              emoji: widget.emoji!,
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                  !widget.isCustomerService
                      ? Row(
                          children: [
                            Icon(
                              Icons.check,
                              size: 8,
                              color: widget.isRead ? Colors.blue : Colors.grey,
                            ),
                            widget.isRead
                                ? const Icon(
                                    Icons.check,
                                    size: 8,
                                    color: Colors.blue,
                                  )
                                : const SizedBox.shrink()
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
