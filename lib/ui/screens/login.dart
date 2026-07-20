import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/sign_up.dart';
import '../theme/app_theme.dart';
import '../widgets/form_divider.dart';
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

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "Username or Email"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Password",
                suffixIcon: Icon(Icons.visibility),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(color: AppTheme.brandColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Sign In"),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => const SignUpScreen()),
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
