import 'chat_choice.dart';

class ChatStep {
  final String id;
  final List<String> botMessages;
  final List<ChatChoice> choices;

  const ChatStep({
    required this.id,
    required this.botMessages,
    this.choices = const [],
  });
}

class Scenario {
  final String id;
  final String title;
  final String sender;
  final String category;
  final List<ChatStep> steps;
  final List<String> sources;

  const Scenario({
    required this.id,
    required this.title,
    required this.sender,
    required this.category,
    required this.steps,
    this.sources = const [],
  });
}
