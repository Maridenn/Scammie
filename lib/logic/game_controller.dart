import '../models/scenario.dart';
import '../models/chat_choice.dart';
import '../models/game_result.dart';

class GameController {
  GameController({required this.scenario, required this.difficulty})
    : step = scenario.steps.first;

  final Scenario scenario;
  final String difficulty; 

  ChatStep step;
  int safe = 0;
  int risky = 0;
  int safeActions = 0;
  int riskyActions = 0;
  bool finished = false;
  final List<ActionLog> log = [];

  ChatStep get currentStep => step;
  bool get isFinished => finished;

  bool get isTerminalStep => step.choices.isEmpty;

  // the easy mode shows a shield hint on choices that are the safe
  bool showHintFor(ChatChoice choice) =>
      difficulty == "easy" && choice.safePoints > 0;

  // score and record a choice, then move to the next step
  void choose(ChatChoice choice) {
    if (finished) return;
    safe += choice.safePoints;
    risky += choice.riskPoints;
    if (choice.safePoints > 0) safeActions++;
    if (choice.riskPoints > 0) riskyActions++;
    log.add(
      ActionLog(
        action: choice.text,
        feedback: choice.feedback,
        safe: choice.riskPoints == 0,
      ),
    );
    goTo(choice.nextStepId);
  }

  // continue from a terminal step so the game is over
  void advance() {
    if (isTerminalStep) finished = true;
  }

  void goTo(String? id) {
    final steps = scenario.steps;
    var index = id == null ? -1 : steps.indexWhere((s) => s.id == id);
    if (index == -1) index = steps.indexOf(step) + 1;
    if (index >= steps.length) {
      finished = true;
      return;
    }
    step = steps[index];
  }

  int get scorePercent {
    final riskyWeighted = difficulty == "hard" ? (risky * 1.5).round() : risky;
    final total = safe + riskyWeighted;
    if (total == 0) return 100;
    return (100 * safe / total).round().clamp(0, 100);
  }

  GameResult buildResult() => GameResult(
    scenarioId: scenario.id,
    scenarioTitle: scenario.title,
    difficulty: difficulty,
    scorePercent: scorePercent,
    safeActions: safeActions,
    riskyActions: riskyActions,
    playedAt: DateTime.now(),
    log: List<ActionLog>.unmodifiable(log),
  );
}
