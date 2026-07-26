import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/result_repository.dart';
import '../../models/game_history.dart';
import '../../models/game_result.dart';
import '../theme/app_theme.dart';
import '../utils/score_display.dart';
import 'game_history_screen.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final auth = AuthRepository();
  final results = ResultRepository();
  late Future<List<GameResult>> historyFuture;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    final uid = auth.currentUser?.uid;
    historyFuture = uid == null
        ? Future.value(const <GameResult>[])
        : results.getHistory(uid);
  }

  Future<void> refresh() async {
    setState(load);
    await historyFuture;
  }

  Future<void> openGame(GameHistory game) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GameHistoryScreen(game: game)),
    );
    if (mounted) setState(load);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GameResult>>(
      future: historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Message(
            text: "Could not load your history.",
            color: AppTheme.errorColor,
          );
        }

        final games = GameHistory.groupscenario(
          snapshot.data ?? const <GameResult>[],
        );
        if (games.isEmpty) {
          return RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Message(text: "No games yet! Please play your first simulation!"),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: refresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            itemCount: games.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Center(
                    child: Text(
                      "History",
                      style: AppTheme.heading.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
              }
              final game = games[index - 1];
              return GameCard(
                rank: index, // 1-based
                game: game,
                onTap: () => openGame(game),
              );
            },
          ),
        );
      },
    );
  }
}

class Message extends StatelessWidget {
  const Message({super.key, required this.text, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTheme.subheading.copyWith(color: color),
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  const GameCard({super.key, 
    required this.rank,
    required this.game,
    required this.onTap,
  });

  final int rank;
  final GameHistory game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final latest = game.latest;
    final color = scoreColor(latest.scorePercent);
    final clean = latest.riskyActions == 0;

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
                  RankBadge(rank: rank),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(game.scenarioTitle, style: AppTheme.heading),
                        const SizedBox(height: 2),
                        Text(
                          "Latest: ${formatPlayedAt(latest.playedAt)} · ${capitalize(latest.difficulty)}",
                          style: AppTheme.subheading.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "${latest.scorePercent}%",
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
                  value: latest.scorePercent / 100,
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
                          : "${latest.riskyActions} mistake${latest.riskyActions > 1 ? "s" : ""}",
                      style: AppTheme.subheading.copyWith(
                        fontSize: 14,
                        color: clean ? AppTheme.goodResult : AppTheme.errorColor,
                      ),
                    ),
                  ),
                  Text(
                    "${game.attemptCount} attempt${game.attemptCount > 1 ? "s" : ""} · Best ${game.bestScore}%",
                    style: AppTheme.subheading.copyWith(fontSize: 13),
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

class RankBadge extends StatelessWidget {
  const RankBadge({super.key, required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.scoreGoodTint,
      ),
      child: Text(
        "#$rank",
        style: const TextStyle(
          color: AppTheme.goodResult,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
