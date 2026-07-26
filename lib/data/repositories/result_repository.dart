import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/game_result.dart';
import '../../models/user_profile.dart';

class ResultRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //save result under uid
  Future<void> saveResult(String uid, GameResult result) async {
    final userDoc = _db.collection('users').doc(uid);

    await userDoc.collection('results').add(result.toMap());

    final snapshot = await userDoc.get();
    final profile = UserProfile.fromMap(snapshot.data()!);

    await userDoc.update({
      'gamesPlayed': profile.gamesPlayed + 1,
      if (result.scorePercent > profile.bestScore)
        'bestScore': result.scorePercent,
    });
  }

  //provide previous game result
  Future<List<GameResult>> getHistory(String uid) async {
    final query = await _db
        .collection('users')
        .doc(uid)
        .collection('results')
        .orderBy('playedAt', descending: true)
        .get();
    return query.docs
        .map((d) => GameResult.fromMap(d.data(), id: d.id))
        .toList();
  }

  //delete a single game result, best score is not recalculated
  Future<void> deleteResult(String uid, String resultId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('results')
        .doc(resultId)
        .delete();
  }
}
