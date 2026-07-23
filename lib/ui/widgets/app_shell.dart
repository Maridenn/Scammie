import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.body,
    this.currentIndex = 1,
    this.onNavTap,
    this.onHomeTap,
  });

  final Widget body;
  final int currentIndex;
  final ValueChanged<int>? onNavTap;
  final VoidCallback? onHomeTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Header(onLogoTap: onHomeTap),
            Expanded(child: body),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onNavTap,
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
}

class Header extends StatelessWidget {
  const Header({super.key, this.onLogoTap});

  final VoidCallback? onLogoTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onLogoTap,
          child: Padding(
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
        ),
        const Divider(height: 1, color: AppTheme.dividerColor),
      ],
    );
  }
}
