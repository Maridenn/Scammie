class ActionLog {
  final String action;
  final String feedback;
  final bool safe;

  const ActionLog({
    required this.action,
    required this.feedback,
    required this.safe,
  });

  Map<String, dynamic> toMap() => {
    "action": action,
    "feedback": feedback,
    "safe": safe,
  };

  factory ActionLog.fromMap(Map<String, dynamic> map) => ActionLog(
    action: map["action"] ?? "",
    feedback: map["feedback"] ?? '',
    safe: map["safe"] ?? false,
  );
}

class GameResult {
  final String? id;
  final String scenarioId;
  final String scenarioTitle;
  final String difficulty;
  final int scorePercent;
  final int safeActions;
  final int riskyActions;
  final DateTime playedAt;
  final List<ActionLog> log;

  const GameResult({
    this.id,
    required this.scenarioId,
    required this.scenarioTitle,
    required this.difficulty,
    required this.scorePercent,
    required this.safeActions,
    required this.riskyActions,
    required this.playedAt,
    this.log = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      "scenarioId": scenarioId,
      "scenarioTitle": scenarioTitle,
      "difficulty": difficulty,
      "scorePercent": scorePercent,
      "safeActions": safeActions,
      "riskyActions": riskyActions,
      "playedAt": playedAt.millisecondsSinceEpoch,
      "log": log.map((e) => e.toMap()).toList(),
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
      log: ((map['log'] as List?) ?? [])
          .map((e) => ActionLog.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
