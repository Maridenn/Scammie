import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/quick_reply.dart';
import '../widgets/text_input.dart';

class Message {
  final String text;
  final bool isMe;
  Message({required this.text, required this.isMe});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [
    Message(text: "Hey! Are we still meeting up today?", isMe: false),
    Message(text: "Yeah! I'm on my way right now.", isMe: true),
    Message(text: "Awesome, see you in 10 minutes!", isMe: false),
  ];

  final ScrollController _scrollController = ScrollController();

  final List<String> _quickReplies = [
    "Sure!",
    "On my way! 🏃‍♂️",
    "Can't make it today",
    "Sounds good 👍",
    "Where are you?",
  ];

  void _sendMessage(String text) {
    setState(() {
      _messages.add(Message(text: text, isMe: true));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: Column(
        children: [
          // 1. Message List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(text: message.text, isMe: message.isMe);
              },
            ),
          ),

          // 2. Separated Quick Replies Widget
          QuickRepliesBar(
            quickReplies: _quickReplies,
            onReplySelected: _sendMessage,
          ),

          // 3. Separated Chat Input Widget
          ChatInputBar(onSubmitted: _sendMessage),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
