import 'package:flutter/material.dart';
import '../../models/game_result.dart';
import '../theme/app_theme.dart';

Color scoreColor(int score) =>
    score >= 80 ? AppTheme.goodResult : (score >= 50 ? AppTheme.midResult : AppTheme.badResult);

const List<String> months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

String formatDate(DateTime d) => "${months[d.month - 1]} ${d.day}, ${d.year}";

String capitalize(String s) =>
    s.isEmpty ? s : "${s[0].toUpperCase()}${s.substring(1)}";

// a placeholder before the database
final List<GameResult> history = [
  GameResult(
    scenarioId: "it",
    scenarioTitle: "Message with IT",
    difficulty: "easy",
    scorePercent: 96,
    safeActions: 5,
    riskyActions: 0,
    playedAt: DateTime(2026, 6, 22),
  ),
  GameResult(
    scenarioId: "telegram",
    scenarioTitle: "Telegram Scam",
    difficulty: "easy",
    scorePercent: 90,
    safeActions: 4,
    riskyActions: 0,
    playedAt: DateTime(2026, 6, 22),
  ),
  GameResult(
    scenarioId: "it",
    scenarioTitle: "Message with IT",
    difficulty: "hard",
    scorePercent: 82,
    safeActions: 4,
    riskyActions: 1,
    playedAt: DateTime(2026, 6, 25),
  ),
];

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Center(
        child: Text(
          "No games yet!!! Play your first simulation!",
          style: AppTheme.subheading,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      itemCount: history.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Center(
              child: Text(
                "History",
                style: AppTheme.brandName
              ),
            ),
          );
        }
        final rank = index;
        return HistoryCard(rank: rank, result: history[index - 1]);
      },
    );
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.rank, required this.result});

  final int rank;
  final GameResult result;

  @override
  Widget build(BuildContext context) {
    final color = scoreColor(result.scorePercent);
    final clean = result.riskyActions == 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
                RankBadge(rank: rank),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result.scenarioTitle, style: AppTheme.heading),
                      const SizedBox(height: 2),
                      Text(
                        "${formatDate(result.playedAt)} · ${capitalize(result.difficulty)}",
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
                backgroundColor: AppTheme.progresBarBg,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  clean ? Icons.check_circle : Icons.cancel,
                  size: 18,
                  color: clean ? AppTheme.goodResult : AppTheme.badResult,
                ),
                const SizedBox(width: 6),
                Text(
                  clean
                      ? "Clean run"
                      : "${result.riskyActions} mistake${result.riskyActions > 1 ? "s" : ""}",
                  style: AppTheme.subheading.copyWith(
                    fontSize: 14,
                    color: clean ? AppTheme.goodResult : AppTheme.badResult,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RankBadge extends StatelessWidget {
  const RankBadge({super.key, required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.rankBadge),
      child: Text(
        "$rank",
        style: AppTheme.brandName.copyWith(fontSize: 12)
      ),
    );
  }
}
