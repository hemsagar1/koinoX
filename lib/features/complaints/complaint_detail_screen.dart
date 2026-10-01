import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/complaint_model.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/timeline_widget.dart';
import '../../admin/complaints/admin_complaint_detail_screen.dart';

class ComplaintDetailScreen extends StatelessWidget {
  final String complaintId;

  const ComplaintDetailScreen({super.key, required this.complaintId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final complaint = appState.complaints.firstWhere(
          (c) => c.id == complaintId,
          orElse: () => ComplaintModel(
            id: complaintId,
            category: 'General',
            location: 'Campus',
            description: 'No complaint found',
            createdAt: DateTime.now(),
            status: ComplaintStatus.submitted,
          ),
        );

        // Calculate timeline steps
        final steps = [
          TimelineStep(
            title: complaint.isPendingSync ? 'Saved Offline' : 'Submitted',
            description: complaint.isPendingSync
                ? 'Stored locally on device (Waiting for connection)'
                : 'Complaint registered on campus server',
            isCompleted: complaint.status.index >= ComplaintStatus.submitted.index,
            isCurrent: complaint.status == ComplaintStatus.submitted || complaint.status == ComplaintStatus.waitingForSync,
            time: DateFormatter.formatDateTime(complaint.createdAt),
          ),
          TimelineStep(
            title: 'Assigned to Staff',
            description: complaint.assignedTo != null
                ? 'Assigned to: ${complaint.assignedTo}'
                : 'Awaiting technician assignment by warden/admin',
            isCompleted: complaint.status.index >= ComplaintStatus.assigned.index,
            isCurrent: complaint.status == ComplaintStatus.assigned,
          ),
          TimelineStep(
            title: 'In Progress',
            description: 'Staff member is working on resolving the issue',
            isCompleted: complaint.status.index >= ComplaintStatus.inProgress.index,
            isCurrent: complaint.status == ComplaintStatus.inProgress,
          ),
          TimelineStep(
            title: 'Resolved',
            description: complaint.status == ComplaintStatus.resolved
                ? 'Work complete. Confirmed by staff.'
                : 'Pending work completion',
            isCompleted: complaint.status == ComplaintStatus.resolved,
            isCurrent: complaint.status == ComplaintStatus.resolved,
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text('Ticket #${complaint.id}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.admin_panel_settings_outlined),
                tooltip: 'Switch to Admin View for this Ticket',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AdminComplaintDetailScreen(complaintId: complaint.id),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header status card
                CustomCard(
                  backgroundColor: AppColors.navyPrimary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'TICKET #${complaint.id}',
                            style: const TextStyle(
                              color: AppColors.cyanAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 1,
                            ),
                          ),
                          StatusBadge.fromComplaintStatus(complaint.status),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        complaint.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.textMutedDark, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            complaint.location,
                            style: const TextStyle(color: AppColors.textMutedDark, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        complaint.description,
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                      if (complaint.imagePath != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.image_rounded, color: AppColors.navyPrimary, size: 20),
                              SizedBox(width: 8),
                              Text('1 Attachment attached', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Status Timeline
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Live Status Timeline',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      StatusTimeline(steps: steps),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Student confirmation action
                if (complaint.status == ComplaintStatus.resolved)
                  CustomCard(
                    backgroundColor: complaint.studentConfirmed ? AppColors.cyanLight : Colors.green.shade50,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              complaint.studentConfirmed ? Icons.task_alt_rounded : Icons.mark_chat_read_rounded,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                complaint.studentConfirmed
                                    ? 'Resolution confirmed by you. Thank you!'
                                    : 'Staff has marked this as resolved. Please confirm resolution.',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        if (!complaint.studentConfirmed) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                appState.confirmComplaintResolution(complaint.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Confirm Resolution'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                const SizedBox(height: 20),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AdminComplaintDetailScreen(complaintId: complaint.id),
                        ),
                      );
                    },
                    icon: const Icon(Icons.admin_panel_settings, size: 18),
                    label: const Text('Demo: Manage in Admin Dashboard'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
