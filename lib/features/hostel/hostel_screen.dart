import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/widgets/custom_card.dart';
import '../complaints/create_complaint_screen.dart';

class HostelScreen extends StatelessWidget {
  const HostelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel & Room Management'),
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          final student = appState.student;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Info Header
                CustomCard(
                  backgroundColor: AppColors.navyPrimary,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${student.hostelBlock.toUpperCase()} — ROOM ${student.roomNumber}',
                                style: const TextStyle(
                                  color: AppColors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                student.name,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                student.rollNumber,
                                style: const TextStyle(color: AppColors.textMutedDark, fontSize: 13),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.navySecondary,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.cyanAccent.withValues(alpha: 0.5)),
                            ),
                            child: const Icon(Icons.other_houses_rounded, color: AppColors.cyanAccent, size: 32),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Warden Contact Card
                CustomCard(
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.navySecondary,
                        child: Icon(Icons.person_pin_rounded, color: AppColors.cyanAccent),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Hostel Warden: Prof. V. K. Sharma', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('Office: Block A Ground Floor | Ext: 402', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone, color: AppColors.tealPrimary),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Calling Warden Office: +91 98765 43210')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Quick Action Button to Report Hostel Issue
                CustomCard(
                  backgroundColor: AppColors.cyanLight,
                  child: Row(
                    children: [
                      const Icon(Icons.build_circle_rounded, color: AppColors.navyPrimary, size: 36),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Have a Room Repair Issue?',
                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navyPrimary, fontSize: 15),
                            ),
                            Text(
                              'Report tap leak, fan, light, or Wi-Fi problems instantly.',
                              style: TextStyle(color: AppColors.navySecondary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CreateComplaintScreen(initialCategory: 'Hostel Maintenance'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navyPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: const Text('Report', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text('Hostel Guidelines & Rules', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 12),
                CustomCard(
                  child: Column(
                    children: const [
                      ListTile(
                        leading: Icon(Icons.access_time_filled_rounded, color: AppColors.navyPrimary),
                        title: Text('Curfew Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text('In-time for hostel gates is 09:30 PM daily.'),
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.cleaning_services_rounded, color: AppColors.navyPrimary),
                        title: Text('Housekeeping Hours', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text('Corridor and room cleaning available 10 AM - 1 PM.'),
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.volume_off_rounded, color: AppColors.navyPrimary),
                        title: Text('Quiet Hours', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text('Maintain study silence from 10:00 PM to 06:00 AM.'),
                      ),
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
