import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import './dashboard.dart';
import '../widgets/social_button.dart';
import '../theme/app_theme.dart';
import '../widgets/form_divider.dart';
import '../widgets/labeled_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Lets create your account", style: AppTheme.brandName),
              const SizedBox(height: 32),
              SignUpForm(),
              const SizedBox(height: 32),
              FormDivider(dividerText: "or Sign up with"),
              const SizedBox(height: 32),
              const SocialButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthRepository();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _onCreate() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await _auth.signUp(
        username: _username.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AuthRepository.friendlyError(e)), backgroundColor: AppTheme.errorColor,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          LabeledField(
            label: "Username",
            controller: _username,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? "Enter a username" : null,
          ),
          const SizedBox(height: 16),
          LabeledField(
            label: "Email",
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                (v == null || !v.contains("@")) ? "Enter a valid email" : null,
          ),
          const SizedBox(height: 16),
          LabeledField(
            label: "Password",
            controller: _password,
            obscureText: true,
            showEye: true,
            validator: (v) =>
                (v == null || v.length < 6) ? "At least 6 characters" : null,
          ),
          const SizedBox(height: 16),
          LabeledField(
            label: "Confirm Password",
            controller: _confirm,
            obscureText: true,
            showEye: true,
            validator: (v) =>
                (v != _password.text) ? "Passwords do not match" : null,
          ),
          const SizedBox(height: 32),
          // placeholder for when we were to add a policy or terms
          // Row(
          //   children: [
          //     SizedBox(
          //       width: 24,
          //       height: 24,
          //       child: Checkbox(value: true, onChanged: (value) {}),
          //     ),
          //     const SizedBox(width: 16),
          //     Text.rich(
          //       TextSpan(
          //         children: [
          //           TextSpan(
          //             text: "I agree to",
          //             style: AppTheme.subheading,
          //           ),
          //           TextSpan(
          //             text: " Privacy Policy ",
          //             style: AppTheme.subheading.apply(
          //               color: AppTheme.brandColor,
          //             ),
          //           ),
          //           TextSpan(text: "and", style: AppTheme.subheading),
          //           TextSpan(
          //             text: " Terms of use ",
          //             style: AppTheme.subheading.apply(
          //               color: AppTheme.brandColor,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onCreate,
              child: const Text("Create Account"),
            ),
          ),
        ],
      ),
    );
  }
}
