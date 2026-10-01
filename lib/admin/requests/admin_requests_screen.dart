import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/request_model.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/status_badge.dart';

class AdminRequestsScreen extends StatelessWidget {
  const AdminRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Request Approvals'),
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          final requests = appState.requests;

          if (requests.isEmpty) {
            return const Center(child: Text('No requests pending approval.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];

              return CustomCard(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.navyPrimary, borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            req.type == RequestType.bonafide ? 'BONAFIDE' : 'GATE PASS',
                            style: const TextStyle(color: AppColors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        StatusBadge.fromRequestStatus(req.status),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Student: ${req.studentName} (${req.rollNumber})',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text('Purpose: ${req.purpose}', style: const TextStyle(fontSize: 13, color: AppColors.textDark)),
                    const SizedBox(height: 4),
                    Text('Submitted: ${DateFormatter.formatDateTime(req.createdAt)}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              appState.updateRequestStatus(
                                requestId: req.id,
                                status: RequestStatus.rejected,
                                remarks: 'Rejected by Dean Office',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Request #${req.id} rejected.')),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                            ),
                            icon: const Icon(Icons.close_rounded, size: 16),
                            label: const Text('Reject'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              appState.updateRequestStatus(
                                requestId: req.id,
                                status: RequestStatus.approved,
                                remarks: 'Approved by Dean Office',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.success,
                                  content: Text('Request #${req.id} APPROVED!'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.check_rounded, size: 16),
                            label: const Text('Approve'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
