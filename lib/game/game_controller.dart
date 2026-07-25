import 'dart:math';
import '../models/scenario.dart';
import '../models/chat_choice.dart';
import '../models/game_result.dart';

class GameController {
  final Scenario scenario;
  final String difficulty; 

  late ChatStep currentStep;
  bool isFinished = false;

  int _playerScore = 0; 
  int _maxPossibleScore = 0; 
  int safeActions = 0; //num of  good decisions
  int riskyActions = 0; //num bad decisions
  final List<String> mistakes =
      []; //feedback for risky choices

  GameController({required this.scenario, required this.difficulty}) {
    currentStep = scenario.steps.first;
  }

  //handle user's selected choice
  void choose(ChatChoice choice) {
    _playerScore += choice.safePoints;

    //add highest score for current step
    _maxPossibleScore += currentStep.choices
        .map((c) => c.safePoints)
        .reduce(max);

    if (choice.riskPoints > 0) {
      riskyActions++;
      mistakes.add(choice.feedback); // keep the lesson for the report
    } else {
      safeActions++;
    }

    if (choice.nextStepId != null) {
      _goToStepId(choice.nextStepId!);
    } else {
      _goToIndex(scenario.steps.indexOf(currentStep) + 1);
    }
  }

  //for terminal steps(no choices) UI shows "Continue" button to calls this.
  void advance() => _goToIndex(scenario.steps.indexOf(currentStep) + 1);

  void _goToStepId(String id) {
    final step = scenario.steps.where((s) => s.id == id).firstOrNull;
    if (step == null) {
      isFinished = true;
    } else {
      currentStep = step;
    }
  }

  void _goToIndex(int index) {
    if (index >= scenario.steps.length) {
      isFinished = true;
    } else {
      currentStep = scenario.steps[index];
    }
  }

  bool get isTerminalStep => currentStep.choices.isEmpty;

  int get scorePercent => _maxPossibleScore == 0
      ? 100
      : ((_playerScore / _maxPossibleScore) * 100).round();

  GameResult buildResult() {
    return GameResult(
      scenarioId: scenario.id,
      scenarioTitle: scenario.title,
      difficulty: difficulty,
      scorePercent: scorePercent,
      safeActions: safeActions,
      riskyActions: riskyActions,
      mistakes: List.unmodifiable(mistakes),
      playedAt: DateTime.now(),
    );
  }
}
