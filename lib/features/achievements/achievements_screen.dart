import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_card.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      {
        'title': '1st Place — National Smart India Hackathon',
        'category': 'Hackathon',
        'desc': 'Team KoinoX secured 1st prize worth ₹1,00,000 in AI & Campus Tech category.',
        'year': '2026',
      },
      {
        'title': 'Inter-University Robotics Championship Winners',
        'category': 'Robotics',
        'desc': 'Robotics Club won gold medal for autonomous campus patrol rover design.',
        'year': '2025',
      },
      {
        'title': 'All India University Football Finals',
        'category': 'Sports',
        'desc': 'KoinoX University Football Team finished 1st Runner Up.',
        'year': '2025',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Campus Achievements')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final item = achievements[index];
          return CustomCard(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppColors.cyanLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events_rounded, color: AppColors.navyPrimary, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.navyPrimary, borderRadius: BorderRadius.circular(8)),
                            child: Text(item['category']!, style: const TextStyle(color: AppColors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          Text(item['year']!, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(item['desc']!, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
