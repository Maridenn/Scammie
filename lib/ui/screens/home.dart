import 'package:flutter/material.dart';
import 'difficulty_screen.dart';
import '../../data/repositories/scenario_repository.dart';
import '../../models/dashboard_items.dart';
import '../theme/app_theme.dart';

List<DashboardItem> scenarios = [
  DashboardItem(
    scenarioId: "it_otp",
    image: "assets/images/hackerPhoto.jpg",
    heading: "Message with IT",
    subHeading: "IT Support and Phishing",
  ),
  DashboardItem(
    scenarioId: "delivery",
    image: "assets/images/messagePhoto.jpg",
    heading: "Failed Delivery",
    subHeading: "Dilivery scam",
  ),
  DashboardItem(
    scenarioId: "job",
    image: "assets/images/login.jpg",
    heading: "Easy Job Offer",
    subHeading: "Telegram Recruiter and Job Scam",
  ),
];

class ScenarioList extends StatelessWidget {
  const ScenarioList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      itemCount: scenarios.length,
      itemBuilder: (context, index) => ScenarioCard(item: scenarios[index]),
    );
  }
}

class ScenarioCard extends StatelessWidget {
  const ScenarioCard({super.key, required this.item});

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
          onTap: () {
            final scenario = ScenarioRepository().getById(item.scenarioId);
            if (scenario == null) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DifficultyScreen(scenario: scenario),
              ),
            );
          },
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
