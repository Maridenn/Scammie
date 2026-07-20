import 'chat_choice.dart';

class ChatStep {
  final String id;
  final List<String> botMessages; // messages the "scammer" sends
  final List<ChatChoice> choices; // empty list=terminal step(conversation over)

  const ChatStep({
    required this.id,
    required this.botMessages,
    this.choices = const [],
  });
}

class Scenario {
  final String id;
  final String title; // shown on the dashboard, ex: "Message with IT"
  final String sender; 
  final String category; 
  final List<ChatStep> steps;

  const Scenario({
    required this.id,
    required this.title,
    required this.sender,
    required this.category,
    required this.steps,
  });
}
