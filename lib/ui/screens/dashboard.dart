import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import './home.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1;

  void _onNavTap(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Header(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // sticky bottom
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppTheme.brandColor,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time, size: 32),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 32),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 32),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const _Placeholder(label: "History coming soon");
      case 2:
        return const _Placeholder(label: "Profile coming soon");
      default:
        return ScenarioList();
    }
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/images/logo.jpg",
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              Text("Scammie Simulator", style: AppTheme.brandName),
            ],
          ),
        ),
        const Divider(height: 1, color: AppTheme.dividerColor),
      ],
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
