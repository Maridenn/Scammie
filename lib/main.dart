import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './ui/screens/welcome_screen.dart';
import './ui/theme/app_theme.dart';


void main() async {
  // Required because we await something before runApp.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ScammieApp());
}

class ScammieApp extends StatelessWidget {
  const ScammieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: Welcomescreen(),
    );
  }
}
// void main() {
//   runApp(GetMaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: AppTheme.theme,
//     home: const Welcomescreen(),
//   ));
// }
