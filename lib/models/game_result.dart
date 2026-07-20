class GameResult {
  final String? id; 
  final String scenarioId;
  final String scenarioTitle;
  final String difficulty; 
  final int scorePercent;
  final int safeActions;
  final int riskyActions;
  final DateTime playedAt;

  const GameResult({
    this.id,
    required this.scenarioId,
    required this.scenarioTitle,
    required this.difficulty,
    required this.scorePercent,
    required this.safeActions,
    required this.riskyActions,
    required this.playedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'scenarioId': scenarioId,
      'scenarioTitle': scenarioTitle,
      'difficulty': difficulty,
      'scorePercent': scorePercent,
      'safeActions': safeActions,
      'riskyActions': riskyActions,
      'playedAt': playedAt.millisecondsSinceEpoch,
    };
  }

  factory GameResult.fromMap(Map<String, dynamic> map, {String? id}) {
    return GameResult(
      id: id,
      scenarioId: map['scenarioId'] ?? '',
      scenarioTitle: map['scenarioTitle'] ?? '',
      difficulty: map['difficulty'] ?? 'easy',
      scorePercent: map['scorePercent'] ?? 0,
      safeActions: map['safeActions'] ?? 0,
      riskyActions: map['riskyActions'] ?? 0,
      playedAt: DateTime.fromMillisecondsSinceEpoch(map['playedAt'] ?? 0),
    );
  }
}
