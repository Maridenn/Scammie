class UserProfile {
  final String uid;
  final String username;
  final String email;
  final int bestScore;
  final String bestGame;
  final int gamesPlayed;

  const UserProfile({
    required this.uid,
    required this.username,
    required this.email,
    this.bestGame = "none",
    this.bestScore = 0,
    this.gamesPlayed = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'bestScore': bestScore,
      'gamesPlayed': gamesPlayed,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      bestScore: map['bestScore'] ?? 0,
      gamesPlayed: map['gamesPlayed'] ?? 0,
    );
  }
}
