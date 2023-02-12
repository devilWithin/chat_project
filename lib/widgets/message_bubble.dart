import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  final String message;
  final bool isCustomerService;
  final bool isRead;
  final String messageId;
  final String chatId;

  const MessageBubble(
      {Key? key,
      required this.message,
      required this.isCustomerService,
      required this.isRead,
      required this.messageId,
      required this.chatId})
      : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.isCustomerService
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: widget.isCustomerService
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(32)),
                child: Text(
                  widget.message,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
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
        )
      ],
    );
  }
}
