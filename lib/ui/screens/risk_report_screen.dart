import 'package:flutter/material.dart';
import '../../data/report_exporter.dart';
import '../../data/repositories/auth_repository.dart';
import '../../models/game_result.dart';
import '../theme/app_theme.dart';
import '../utils/score_display.dart';
import '../widgets/app_shell.dart';

class RiskReportScreen extends StatelessWidget {
  const RiskReportScreen({super.key, required this.result});

  final GameResult result;

  void goToDashboard(BuildContext context) =>
      Navigator.popUntil(context, (route) => route.isFirst);

  Future<void> _export(BuildContext context) async {
    try {
      final participant = AuthRepository().currentUser?.email;
      await ReportExporter.shareReport(result, participant: participant);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Couldn't export the report."),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: result.scenarioTitle,
      currentIndex: 1,
      onNavTap: (_) => goToDashboard(context),
      onHomeTap: () => goToDashboard(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                "RISK REPORT",
                style: AppTheme.heading.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ScoreCard(result: result),
            const SizedBox(height: 16),
            RecapCard(result: result),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    value: "${result.safeActions}",
                    label: "Safe Actions",
                    color: AppTheme.goodResult,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    value: "${result.riskyActions}",
                    label: "Risky Actions",
                    color: AppTheme.errorColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _export(context),
              icon: const Icon(Icons.ios_share),
              label: const Text("Export Report"),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => goToDashboard(context),
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  const ScoreCard({super.key, required this.result});

  final GameResult result;

  @override
  Widget build(BuildContext context) {
    final color = scoreColor(result.scorePercent);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          ScoreRing(score: result.scorePercent, color: color),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SECURITY HEALTH",
                style: AppTheme.subheading.copyWith(
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
              Text(
                "RISK LEVEL",
                style: AppTheme.subheading.copyWith(
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ReportExporter.riskLevel(result.scorePercent),
                style: AppTheme.brandName.copyWith(fontSize: 24, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScoreRing extends StatelessWidget {
  const ScoreRing({super.key, required this.score, required this.color});

  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      height: 84,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 84,
            height: 84,
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 6,
              color: color,
              backgroundColor: AppTheme.scoreTrack,
            ),
          ),
          Text(
            "$score",
            style: AppTheme.brandName.copyWith(fontSize: 26, color: color),
          ),
        ],
      ),
    );
  }
}

class RecapCard extends StatelessWidget {
  const RecapCard({super.key, required this.result});

  final GameResult result;

  @override
  Widget build(BuildContext context) {
    if (result.log.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What to remember", style: AppTheme.heading),
          for (final e in result.log) ...[
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  e.safe ? Icons.check_circle : Icons.cancel,
                  size: 18,
                  color: e.safe ? AppTheme.goodResult : AppTheme.errorColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"${e.action}"',
                        style: AppTheme.subheading.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        e.feedback,
                        style: AppTheme.subheading.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, 
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTheme.brandName.copyWith(fontSize: 22, color: color),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTheme.subheading.copyWith(fontSize: 13)),
        ],
      ),
    );
  }
}
