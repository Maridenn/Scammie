import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import './home.dart';
import './profile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1;

  void onNavTap(int index) => setState(() => _selectedIndex = index);

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const _Placeholder(label: "History coming soon");
      case 2:
        return const ProfilePage();
      default:
        return ScenarioList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: _selectedIndex,
      onNavTap: onNavTap,
      onHomeTap: () => onNavTap(1),
      body: _buildBody(),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(label, style: AppTheme.subheading));
  }
}
