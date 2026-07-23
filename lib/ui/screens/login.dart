import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import './dashboard.dart';
import '../screens/sign_up.dart';
import '../theme/app_theme.dart';
import '../widgets/form_divider.dart';
import '../widgets/labeled_field.dart';
import '../widgets/social_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 56, left: 24, bottom: 24, right: 24),
          child: Column(
            children: [
              LoginHeader(),
              LoginForm(),
              FormDivider(dividerText: "or Sing in with"),
              const SizedBox(height: 32),
              SocialButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthRepository();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await _auth.signIn(email: _email.text.trim(), password: _password.text);
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            LabeledField(
              label: "Email",
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || !v.contains("@"))
                  ? "Enter a valid email"
                  : null,
            ),
            const SizedBox(height: 16),
            LabeledField(
              label: "Password",
              controller: _password,
              obscureText: true,
              showEye: true,
              validator: (v) =>
                  (v == null || v.isEmpty) ? "Enter your password" : null,
            ),
            const SizedBox(height: 8),
            // placeholder for in the future if we want to implement a forgot password
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     TextButton(
            //       onPressed: () {},
            //       child: const Text(
            //         "Forgot Password",
            //         style: TextStyle(color: AppTheme.brandColor),
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSignIn,
                child: const Text("Sign In"),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                ),
                child: const Text("Create an account"),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(height: 150, image: AssetImage("assets/images/logo.jpg")),
            Text("Scammie\nSimulator", style: AppTheme.brandName),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "Welcome to scammie. A simulation app to help raise awareness on social engineering!!!",
          style: AppTheme.heading,
        ),
      ],
    );
  }
}
