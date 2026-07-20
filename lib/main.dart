import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './ui/screens/welcome_screen.dart';
import './ui/theme/app_theme.dart';


void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    home: const Welcomescreen(),
  ));
}
