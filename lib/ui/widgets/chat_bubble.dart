import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const ChatBubble({super.key, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe
        ? const Color(0xFF007AFF)
        : const Color(0xFFE9E9EB);
    final textColor = isMe ? Colors.white : Colors.black;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 20),
          ),
        ),
        child: Text(text, style: TextStyle(color: textColor, fontSize: 16.0)),
      ),
    );
  }
}
