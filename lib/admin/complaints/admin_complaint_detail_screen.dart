import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/complaint_model.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/status_badge.dart';

class AdminComplaintDetailScreen extends StatefulWidget {
  final String complaintId;

  const AdminComplaintDetailScreen({super.key, required this.complaintId});

  @override
  State<AdminComplaintDetailScreen> createState() => _AdminComplaintDetailScreenState();
}

class _AdminComplaintDetailScreenState extends State<AdminComplaintDetailScreen> {
  late String _assignedStaff;
  final _internalNoteController = TextEditingController();

  final List<String> _staffMembers = [
    'Ramesh Kumar (Plumber)',
    'Suresh IT Desk',
    'Rajesh Lab Admin',
    'Vikram Electrician',
    'Hostel Warden Desk',
  ];

  @override
  void initState() {
    super.initState();
    _assignedStaff = _staffMembers[0];
  }

  void _updateStatus(AppStateProvider appState, ComplaintStatus status) async {
    await appState.updateComplaintStatus(
      complaintId: widget.complaintId,
      status: status,
      assignedTo: _assignedStaff,
      internalNote: _internalNoteController.text.isNotEmpty ? _internalNoteController.text : null,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.navyPrimary,
          content: Text('Ticket #${widget.complaintId} updated to ${status.displayName}!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final complaint = appState.complaints.firstWhere(
          (c) => c.id == widget.complaintId,
          orElse: () => appState.complaints.first,
        );

        if (_internalNoteController.text.isEmpty && complaint.internalNote != null) {
          _internalNoteController.text = complaint.internalNote!;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.navySecondary,
            title: Text('Admin Manage Ticket #${complaint.id}'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('TICKET #${complaint.id}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.cyanAccent)),
                          StatusBadge.fromComplaintStatus(complaint.status),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(complaint.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 4),
                      Text('Location: ${complaint.location}', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('Submitted: ${DateFormatter.formatDateTime(complaint.createdAt)}', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      const SizedBox(height: 12),
                      const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(complaint.description, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                CustomCard(
                  backgroundColor: AppColors.navyPrimary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Admin Action Panel',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 16),

                      const Text('Assign Staff / Technician', style: TextStyle(color: AppColors.textMutedDark, fontSize: 12)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: complaint.assignedTo ?? _assignedStaff,
                        dropdownColor: AppColors.navySecondary,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.navySecondary,
                          prefixIcon: Icon(Icons.person_add_rounded, color: AppColors.cyanAccent),
                        ),
                        items: _staffMembers.map((staff) {
                          return DropdownMenuItem(
                            value: staff,
                            child: Text(staff, style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _assignedStaff = val);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      const Text('Internal Admin Note', style: TextStyle(color: AppColors.textMutedDark, fontSize: 12)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _internalNoteController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.navySecondary,
                          hintText: 'Add notes for staff or records...',
                          hintStyle: TextStyle(color: Colors.white38),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text('Update Ticket Status:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _updateStatus(appState, ComplaintStatus.assigned),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.warning,
                                foregroundColor: AppColors.navyPrimary,
                              ),
                              child: const Text('Assign Staff'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _updateStatus(appState, ComplaintStatus.inProgress),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.info,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('In Progress'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _updateStatus(appState, ComplaintStatus.resolved),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.check_circle_rounded),
                          label: const Text('Mark as RESOLVED', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                    ],
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
