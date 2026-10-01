import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/widgets/qr_code_widget.dart';

class DigitalIdScreen extends StatelessWidget {
  const DigitalIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Student ID'),
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          final s = appState.student;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.navySecondary.withValues(alpha: 0.8),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.school, color: AppColors.cyanAccent, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  'KOINOX UNIVERSITY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.cyanAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'ACTIVE STUDENT',
                                style: TextStyle(
                                  color: AppColors.navyPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.cyanAccent,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.cyanAccent.withValues(alpha: 0.4),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                              child: const CircleAvatar(
                                radius: 44,
                                backgroundColor: AppColors.navySecondary,
                                child: Icon(Icons.person_rounded, size: 50, color: AppColors.cyanAccent),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Text(
                              s.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Roll No: ${s.rollNumber}',
                              style: const TextStyle(
                                color: AppColors.cyanAccent,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 20),

                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  _buildDetailRow('Course', '${s.course} (${s.year})'),
                                  const Divider(color: Colors.white12, height: 16),
                                  _buildDetailRow('Department', s.department),
                                  const Divider(color: Colors.white12, height: 16),
                                  _buildDetailRow('Hostel & Room', '${s.hostelBlock}, ${s.roomNumber}'),
                                  const Divider(color: Colors.white12, height: 16),
                                  _buildDetailRow('Valid Thru', 'June 2026'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            QrCodeWidget(
                              data: 'STUDENT-VERIFY-${s.rollNumber}-${s.id}',
                              size: 160,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Scan for library, gate, & mess verification',
                              style: TextStyle(
                                color: AppColors.textMutedDark,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMutedDark, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }
}
