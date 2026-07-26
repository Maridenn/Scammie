import 'package:flutter/material.dart';
import '../../models/scenario.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import 'game_chat_screen.dart';

class DifficultyScreen extends StatefulWidget {
  const DifficultyScreen({super.key, required this.scenario});

  final Scenario scenario;

  @override
  State<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen> {
  String difficulty = "easy";

  void goToDashboard() => Navigator.popUntil(context, (route) => route.isFirst);

  void startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            GameChatScreen(scenario: widget.scenario, difficulty: difficulty),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Header(title: widget.scenario.title, onLogoTap: goToDashboard),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        "Difficulty",
                        style: AppTheme.heading.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    DifficultyOption(
                      title: "Easy",
                      subtitle: "Guided hints and forgiving scoring",
                      selected: difficulty == "easy",
                      onTap: () => setState(() => difficulty = "easy"),
                    ),
                    const SizedBox(height: 16),
                    DifficultyOption(
                      title: "Hard",
                      subtitle: "Vague hints and no mercy in scoring",
                      selected: difficulty == "hard",
                      onTap: () => setState(() => difficulty = "hard"),
                    ),
                    const SizedBox(height: 24),
                    const SafetyDisclaimer(),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: startGame,
                      child: const Text("Start Game"),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DifficultyOption extends StatelessWidget {
  const DifficultyOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppTheme.brandColor : AppTheme.dividerColor,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTheme.heading),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTheme.subheading),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppTheme.brandColor : AppTheme.dividerColor,
            ),
          ],
        ),
      ),
    );
  }
}

class SafetyDisclaimer extends StatelessWidget {
  const SafetyDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.chipBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppTheme.brandColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "This is a safe educational simulation. No real personal data is "
              "collected. You will interact with a realistic fake smartphone "
              "environment.",
              style: AppTheme.subheading.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
