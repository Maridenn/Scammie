import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../models/user_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/labeled_field.dart';
import './dashboard.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthRepository();

  late final TextEditingController _username;
  late final TextEditingController _email;
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void initState() {
    super.initState();
    _username = TextEditingController(text: widget.profile.username);
    _email = TextEditingController(text: widget.profile.email);
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await _auth.updateUsername(widget.profile.uid, _username.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated"),
          backgroundColor: AppTheme.brandColor,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AuthRepository.friendlyError(e)), backgroundColor: AppTheme.errorColor,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: 2,
      onNavTap: (_) => Navigator.pop(context),
      onHomeTap: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // const Center(child: _Avatar()),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabeledField(
                    label: "Username",
                    controller: _username,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? "Enter a username"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // placeholder for now could only change username thats y they are disabled
                  LabeledField(
                    label: "Email",
                    controller: _email,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  LabeledField(
                    label: "Password",
                    controller: _password,
                    obscureText: true,
                    showEye: true,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  LabeledField(
                    label: "Confirm Password",
                    controller: _confirm,
                    obscureText: true,
                    showEye: true,
                    enabled: false,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Only your username can be changed for now.",
                    style: AppTheme.subheading,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _onConfirm, child: const Text("Confirm")),
          ],
        ),
      ),
    );
  }
}

// place holder for profile pic
// class _Avatar extends StatelessWidget {
//   const _Avatar();

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
