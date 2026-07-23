import 'package:flutter/material.dart';
import './dashboard.dart';
import '../widgets/social_button.dart';
import '../theme/app_theme.dart';
import '../widgets/form_divider.dart';

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

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: "Username"),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: "Email"),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Password",
              suffixIcon: Icon(Icons.visibility),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Confirm Password",
              suffixIcon: Icon(Icons.visibility),
            ),
          ),
          const SizedBox(height: 32),
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
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  (route) => false,
                ),
              child: const Text("Create Account"),
            ),
          ),
        ],
      ),
    );
  }
}
