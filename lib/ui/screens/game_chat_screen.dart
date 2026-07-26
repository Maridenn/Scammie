import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/result_repository.dart';
import '../../logic/game_controller.dart';
import '../../models/chat_choice.dart';
import '../../models/scenario.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';
import 'risk_report_screen.dart';

enum EntryType { bot, player }

class Entry {
  const Entry(this.text, this.type);
  final String text;
  final EntryType type;
}

class GameChatScreen extends StatefulWidget {
  const GameChatScreen({
    super.key,
    required this.scenario,
    required this.difficulty,
  });

  final Scenario scenario;
  final String difficulty;

  @override
  State<GameChatScreen> createState() => _GameChatScreenState();
}

class _GameChatScreenState extends State<GameChatScreen> {
  late final GameController game;
  final auth = AuthRepository();
  final results = ResultRepository();
  final scroll = ScrollController();
  final List<Entry> entries = [];
  bool finishing = false;

  @override
  void initState() {
    super.initState();
    game = GameController(
      scenario: widget.scenario,
      difficulty: widget.difficulty,
    );
    appendBotMessages();
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  void appendBotMessages() {
    for (final m in game.currentStep.botMessages) {
      entries.add(Entry(m, EntryType.bot));
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void onChoice(ChatChoice choice) {
    setState(() {
      entries.add(Entry(choice.text, EntryType.player));
      game.choose(choice);
      if (!game.isFinished) appendBotMessages();
    });
    scrollToBottom();
    if (game.isFinished) finish();
  }

  void onContinue() {
    game.advance();
    finish();
  }

  Future<void> finish() async {
    if (finishing) return;
    finishing = true;

    final messenger = ScaffoldMessenger.of(context);

    final result = game.buildResult();
    final uid = auth.currentUser?.uid;
    var saveFailed = false;
    if (uid != null) {
      try {
        await results.saveResult(uid, result);
      } catch (_) {
        saveFailed = true;
      }
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RiskReportScreen(result: result)),
    );
    if (saveFailed) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            "Couldn't save this result !!! it may not appear in your history.",
          ),
          backgroundColor: AppTheme.errorColor,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  void showInfo() {
    final sources = widget.scenario.sources;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Safe simulation"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "This is a fake conversation for training. No real messages are "
                "sent and no personal data is collected. Practice spotting the "
                "red flags!",
              ),
              if (sources.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  "Based on real scams reported by:",
                  style: AppTheme.subheading.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                for (final url in sources)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: SelectableText(
                      url,
                      style: AppTheme.subheading.copyWith(
                        fontSize: 13,
                        color: AppTheme.brandColor,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.scenario.sender,
          style: AppTheme.brandName.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: AppTheme.brandColor),
            tooltip: "About this simulation",
            onPressed: showInfo,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scroll,
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, i) => buildEntry(entries[i]),
            ),
          ),
          buildFooter(),
        ],
      ),
    );
  }

  Widget buildEntry(Entry e) {
    return ChatBubble(text: e.text, isMe: e.type == EntryType.player);
  }

  Widget buildFooter() {
    if (game.isFinished) return const SizedBox.shrink();
    if (game.isTerminalStep) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              child: const Text("Continue"),
            ),
          ),
        ),
      );
    }
    return QuickReplies(
      choices: game.currentStep.choices,
      showHint: game.showHintFor,
      onSelected: onChoice,
    );
  }
}

class QuickReplies extends StatelessWidget {
  const QuickReplies({
    super.key,
    required this.choices,
    required this.showHint,
    required this.onSelected,
  });

  final List<ChatChoice> choices;
  final bool Function(ChatChoice) showHint;
  final ValueChanged<ChatChoice> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "QUICK REPLIES",
              style: AppTheme.subheading.copyWith(
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            for (final c in choices) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => onSelected(c),
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (showHint(c)) ...[
                        const Icon(
                          Icons.shield_outlined,
                          size: 16,
                          color: AppTheme.brandColor,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(child: Text(c.text, textAlign: TextAlign.left)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
