import 'package:flutter/material.dart';
import '../../models/game_history.dart';
import '../../models/game_result.dart';
import '../theme/app_theme.dart';
import '../utils/score_display.dart';
import 'risk_report_screen.dart';

class GameHistoryScreen extends StatelessWidget {
  const GameHistoryScreen({super.key, required this.game});

  final GameHistory game;

  void openReport(BuildContext context, GameResult result) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RiskReportScreen(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          game.scenarioTitle,
          style: AppTheme.brandName.copyWith(fontSize: 20),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        itemCount: game.attemptCount + 1,
        itemBuilder: (context, index) {
          if (index == 0) return Summary(game: game);
          final attempt = game.attempts[index - 1];
          return _AttemptCard(
            number: game.attemptCount - (index - 1),
            result: attempt,
            isBest: attempt.scorePercent == game.bestScore,
            onTap: () => openReport(context, attempt),
          );
        },
      ),
    );
  }
}

class Summary extends StatelessWidget {
  const Summary({super.key, required this.game});

  final GameHistory game;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Text(
            "${game.attemptCount} attempt${game.attemptCount > 1 ? "s" : ""}",
            style: AppTheme.heading.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Best score ${game.bestScore}% · Latest ${game.latest.scorePercent}%",
            style: AppTheme.subheading.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _AttemptCard extends StatelessWidget {
  const _AttemptCard({
    required this.number,
    required this.result,
    required this.isBest,
    required this.onTap,
  });

  final int number;
  final GameResult result;
  final bool isBest;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = scoreColor(result.scorePercent);
    final clean = result.riskyActions == 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Attempt $number", style: AppTheme.heading),
                            if (isBest) ...[
                              const SizedBox(width: 8),
                              const BestChip(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${formatPlayedAt(result.playedAt)} · ${capitalize(result.difficulty)}",
                          style: AppTheme.subheading.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "${result.scorePercent}%",
                    style: AppTheme.brandName.copyWith(
                      fontSize: 24,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: result.scorePercent / 100,
                  minHeight: 8,
                  color: color,
                  backgroundColor: AppTheme.scoreTrack,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    clean ? Icons.check_circle : Icons.cancel,
                    size: 18,
                    color: clean ? AppTheme.goodResult : AppTheme.errorColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      clean
                          ? "Clean run"
                          : "${result.riskyActions} mistake${result.riskyActions > 1 ? "s" : ""}",
                      style: AppTheme.subheading.copyWith(
                        fontSize: 14,
                        color: clean ? AppTheme.goodResult : AppTheme.errorColor,
                      ),
                    ),
                  ),
                  Text(
                    "View report",
                    style: AppTheme.subheading.copyWith(
                      fontSize: 13,
                      color: AppTheme.brandColor,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.black54,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BestChip extends StatelessWidget {
  const BestChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.scoreGoodTint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "BEST",
        style: TextStyle(
          color: AppTheme.goodResult,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
