import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_profile.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Emits the user on login/logout. The app listens to this to decide
  /// whether to show the sign-in screen or the dashboard.
  Stream<User?> get authState => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Creates BOTH the Auth account and the users/{uid} profile document.
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final profile = UserProfile(
      uid: credential.user!.uid,
      username: username,
      email: email,
    );
    await _db.collection('users').doc(profile.uid).set(profile.toMap());
  }

  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();

  /// UPDATE — used by the Edit Profile screen (username change only in v1).
  Future<void> updateUsername(String uid, String newUsername) async {
    await _db.collection('users').doc(uid).update({'username': newUsername});
  }

  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromMap(doc.data()!);
  }

  /// Turns Firebase error codes into messages a human understands.
  /// The UI shows these under the form fields.
  static String friendlyError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'This email is already registered. Try signing in.';
        case 'invalid-email':
          return 'That email address is not valid.';
        case 'weak-password':
          return 'Password must be at least 6 characters.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email or password is incorrect.';
        case 'network-request-failed':
          return 'No internet connection. Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
  }
}
