import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../models/user_profile.dart';
import '../theme/app_theme.dart';
import 'edit_profile.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final auth = AuthRepository();
  late Future<UserProfile?> profileFuture;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() {
    final uid = auth.currentUser?.uid;
    profileFuture = uid == null ? Future.value(null) : auth.getProfile(uid);
  }

  Future<void> refresh() async {
    setState(loadProfile);
    await profileFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = snapshot.data;
        if (profile == null) {
          return const Center(
            child: Text(
              "Could not load your profile.",
              style: TextStyle(color: AppTheme.errorColor),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                InfoCard(info: profile),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(profile: profile),
                        ),
                      );
                      if (mounted) setState(loadProfile);
                    },
                    child: const Text("Edit Profile"),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: handleLogout,
                    child: const Text("Log out"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Log out?"),
        content: const Text("You'll need to sign in again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Log Out"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await auth.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}

//place holder for future profile picture, could use when we implement a leaderboard
// class Avatar extends StatelessWidget {
//   const Avatar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 90,
//       height: 90,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white,
//         border: Border.all(color: Colors.black, width: 2),
//       ),
//       child: const Icon(Icons.person, size: 52, color: Colors.black),
//     );
//   }
// }

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.info});

  final UserProfile info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Profile Informations", style: AppTheme.heading),
          const SizedBox(height: 16),
          InfoRow(label: "Username", value: info.username),
          InfoRow(label: "Email", value: info.email),
          InfoRow(label: "Best Score", value: "${info.bestScore}%"),
          Align(
            alignment: Alignment.centerRight,
            child: Text(info.bestGame, style: AppTheme.subheading),
          ),
          InfoRow(label: "Game Tackled", value: "${info.gamesPlayed}"),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.subheading),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTheme.subheading.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
