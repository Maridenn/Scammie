class ChatChoice {
  final String text; // what the player says, e.g. "I never share OTP codes."
  final int safePoints; // > 0 when this is a safe reaction
  final int riskPoints; // > 0 when this falls for the scam
  final String feedback; // the lesson shown after choosing
  final String? nextStepId; // jump to a specific step; null = go to next step in order

  const ChatChoice({
    required this.text,
    this.safePoints = 0,
    this.riskPoints = 0,
    required this.feedback,
    this.nextStepId,
  });
}
