import 'game_result.dart';

class GameHistory {
  const GameHistory({
    required this.scenarioId,
    required this.scenarioTitle,
    required this.attempts,
  });

  final String scenarioId;
  final String scenarioTitle;
  final List<GameResult> attempts;

  int get attemptCount => attempts.length;

  GameResult get latest => attempts.first;

  int get bestScore =>
      attempts.fold(0, (best, r) => r.scorePercent > best ? r.scorePercent : best);

  static List<GameHistory> groupscenario(List<GameResult> results) {
    final scenario = <String, List<GameResult>>{};
    for (final r in results) {
     scenario.putIfAbsent(r.scenarioId, () => []).add(r);
    }
    return scenario.entries
        .map(
          (e) => GameHistory(
            scenarioId: e.key,
            scenarioTitle: e.value.first.scenarioTitle,
            attempts: List.unmodifiable(e.value),
          ),
        )
        .toList();
  }
}
