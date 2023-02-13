import 'package:flutter/material.dart';

class EmojiWidget extends StatelessWidget {
  final String emoji;

  const EmojiWidget({Key? key, required this.emoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(emoji);
  }
}