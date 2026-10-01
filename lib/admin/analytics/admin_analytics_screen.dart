import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_card.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Operations Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Summary Row
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    backgroundColor: AppColors.navyPrimary,
                    child: Column(
                      children: const [
                        Text('Avg Resolution', style: TextStyle(color: AppColors.textMutedDark, fontSize: 11)),
                        SizedBox(height: 6),
                        Text('2.4 Hours', style: TextStyle(color: AppColors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomCard(
                    backgroundColor: AppColors.navyPrimary,
                    child: Column(
                      children: const [
                        Text('Resolution Rate', style: TextStyle(color: AppColors.textMutedDark, fontSize: 11)),
                        SizedBox(height: 6),
                        Text('94.2%', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Department Workload Breakdown
            const Text('Department Workload & Complaints', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),

            _buildMetricBar('Hostel & Plumbing Maintenance', 0.82, '42 Tickets (82% Resolved)'),
            const SizedBox(height: 10),
            _buildMetricBar('IT & Campus Wi-Fi Desk', 0.68, '28 Tickets (68% Resolved)'),
            const SizedBox(height: 10),
            _buildMetricBar('Classroom & Lab Infrastructure', 0.95, '18 Tickets (95% Resolved)'),
            const SizedBox(height: 10),
            _buildMetricBar('Academic & Bonafide Section', 0.90, '35 Requests (90% Processed)'),

            const SizedBox(height: 24),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Recurring Issues Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 8),
                  Text('1. Water tap leakages in Block A 2nd floor (Plumbing issue)', style: TextStyle(fontSize: 13)),
                  SizedBox(height: 4),
                  Text('2. Wi-Fi router disconnection during 8-10 PM peak load', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBar(String label, double val, String subtitle) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text('${(val * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.tealPrimary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: val,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.navyPrimary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
