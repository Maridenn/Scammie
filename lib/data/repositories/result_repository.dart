import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/game_result.dart';

class ResultRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> results(String uid) =>
      db.collection('users').doc(uid).collection('results');

  Future<void> saveResult(String uid, GameResult result) async {
    await results(uid).add(result.toMap());
    await updateAggregates(uid, result);
  }

  Future<List<GameResult>> getHistory(String uid) async {
    final snap = await results(uid).orderBy('playedAt', descending: true).get();
    return snap.docs
        .map((d) => GameResult.fromMap(d.data(), id: d.id))
        .toList();
  }

  Future<void> deleteResult(String uid, String resultId) async {
    await results(uid).doc(resultId).delete();
  }

  Future<void> updateAggregates(String uid, GameResult result) async {
    final userRef = db.collection('users').doc(uid);
    await db.runTransaction((tx) async {
      final snap = await tx.get(userRef);
      final data = snap.data() ?? <String, dynamic>{};

      final scenarios = Map<String, dynamic>.from(
        (data['scenariosPlayed'] as Map?) ?? const <String, dynamic>{},
      );
      scenarios[result.scenarioId] = true;

      final best = (data['bestScore'] as num?)?.toInt() ?? 0;

      final update = <String, dynamic>{
        'scenariosPlayed': scenarios,
        'gamesPlayed': scenarios.length,
      };
      if (result.scorePercent > best) {
        update['bestScore'] = result.scorePercent;
        update['bestGame'] = result.scenarioTitle;
      }
      tx.set(userRef, update, SetOptions(merge: true));
    });
  }
}
