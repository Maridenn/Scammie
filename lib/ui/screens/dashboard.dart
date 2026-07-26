import 'package:flutter/material.dart';
import '../widgets/app_shell.dart';
import './home.dart';
import './history.dart';
import './profile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 1;

  void onNavTap(int index) => setState(() => selectedIndex = index);

  Widget buildBody() {
    switch (selectedIndex) {
      case 0:
        return const HistoryPage();
      case 2:
        return const ProfilePage();
      default:
        return ScenarioList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: selectedIndex,
      onNavTap: onNavTap,
      onHomeTap: () => onNavTap(1),
      body: buildBody(),
    );
  }
}
