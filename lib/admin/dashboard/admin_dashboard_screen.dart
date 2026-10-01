import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/complaint_model.dart';
import '../../core/models/request_model.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../features/home/student_home_screen.dart';
import '../complaints/admin_complaint_detail_screen.dart';
import '../requests/admin_requests_screen.dart';
import '../notices/admin_create_notice_screen.dart';
import '../events/admin_create_event_screen.dart';
import '../analytics/admin_analytics_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final complaints = appState.complaints;
        final requests = appState.requests;

        final activeComplaints = complaints.where((c) => c.status != ComplaintStatus.resolved).toList();
        final resolvedTodayCount = complaints.where((c) => c.status == ComplaintStatus.resolved).length;
        final pendingRequestsCount = requests.where((r) => r.status != RequestStatus.approved && r.status != RequestStatus.documentReady).length;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.navyPrimary,
            title: const Text('KoinoX Admin Control'),
            actions: [
              IconButton(
                icon: const Icon(Icons.analytics_rounded),
                tooltip: 'Analytics',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AdminAnalyticsScreen()),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: AppColors.navySecondary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.admin_panel_settings, color: AppColors.warning, size: 18),
                            SizedBox(width: 8),
                            Text('ADMINISTRATOR MODE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            appState.setRole('student');
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const StudentHomeScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.cyanAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('Switch to Student View', style: TextStyle(color: AppColors.navyPrimary, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Campus Operational Metrics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 12),

                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.6,
                          children: [
                            _buildStatCard('Active Complaints', '${activeComplaints.length}', AppColors.warning, Icons.warning_amber_rounded),
                            _buildStatCard('Pending Requests', '$pendingRequestsCount', AppColors.cyanAccent, Icons.description_rounded),
                            _buildStatCard('Resolved Today', '$resolvedTodayCount', AppColors.success, Icons.check_circle_rounded),
                            _buildStatCard('Total Students', '1,240', AppColors.tealPrimary, Icons.groups_rounded),
                          ],
                        ),
                        const SizedBox(height: 24),

                        const Text('Admin Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => const AdminRequestsScreen()),
                                  );
                                },
                                icon: const Icon(Icons.verified_rounded, size: 18),
                                label: const Text('Approvals'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => const AdminCreateNoticeScreen()),
                                  );
                                },
                                icon: const Icon(Icons.campaign_rounded, size: 18),
                                label: const Text('New Notice'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => const AdminCreateEventScreen()),
                                  );
                                },
                                icon: const Icon(Icons.event_rounded, size: 18),
                                label: const Text('New Event'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Live Complaints Feed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text('Tap ticket to assign & resolve', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: complaints.length,
                          itemBuilder: (context, index) {
                            final c = complaints[index];

                            return CustomCard(
                              margin: const EdgeInsets.only(bottom: 12),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => AdminComplaintDetailScreen(complaintId: c.id)),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('#${c.id} • ${c.category}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                      StatusBadge.fromComplaintStatus(c.status),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(c.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: AppColors.textDark)),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Location: ${c.location}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                      Text(DateFormatter.formatTimeAgo(c.createdAt), style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return CustomCard(
      backgroundColor: AppColors.navyPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AppColors.textMutedDark, fontSize: 11)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 22)),
        ],
      ),
    );
  }
}
