import 'package:flutter/material.dart';
import 'chat_screen.dart';
import '../../models/dashboard_items.dart';
import '../theme/app_theme.dart';

// a placeholder before the database
List<DashboardItem> _scenarios = [
  DashboardItem(
    image: "assets/images/hackerPhoto.jpg",
    heading: "Message with IT",
    subHeading: "IT Support and Phishing",
  ),
  DashboardItem(
    image: "assets/images/messagePhoto.jpg",
    heading: "Failed Delivery",
    subHeading: "Dilivery scam",
  ),
  DashboardItem(
    image: "assets/images/login.jpg",
    heading: "Easy Job Offer",
    subHeading: "Telegram Recruiter and Job Scam",
  ),
];

class ScenarioList extends StatelessWidget {
  const ScenarioList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      itemCount: _scenarios.length,
      itemBuilder: (context, index) => _ScenarioCard(item: _scenarios[index]),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.item});

  final DashboardItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatScreen()),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    item.image,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.heading, style: AppTheme.heading),
                      const SizedBox(height: 4),
                      Text(item.subHeading, style: AppTheme.subheading),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
