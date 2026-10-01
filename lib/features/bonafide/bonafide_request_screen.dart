import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/request_model.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/timeline_widget.dart';
import '../../admin/requests/admin_requests_screen.dart';

class BonafideRequestScreen extends StatefulWidget {
  const BonafideRequestScreen({super.key});

  @override
  State<BonafideRequestScreen> createState() => _BonafideRequestScreenState();
}

class _BonafideRequestScreenState extends State<BonafideRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _purposeController = TextEditingController(text: 'Bank Account Opening & Education Scholarship');
  DateTime _requiredDate = DateTime.now().add(const Duration(days: 3));

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      final reqId = await appState.createRequest(
        type: RequestType.bonafide,
        purpose: _purposeController.text,
        requiredDate: _requiredDate,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.navyPrimary,
            content: Text('Bonafide Request #$reqId submitted successfully!'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bonafide Certificate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined),
            tooltip: 'Admin Approval View',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AdminRequestsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          final bonafideRequests = appState.requests
              .where((r) => r.type == RequestType.bonafide)
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Application Form Card
                CustomCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.workspace_premium_rounded, color: AppColors.cyanAccent, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Apply for Bonafide Certificate',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        const Text('Purpose of Certificate', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _purposeController,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Passport Application, Bus Pass, Bank Account',
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Please specify purpose' : null,
                        ),
                        const SizedBox(height: 16),

                        const Text('Required By Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _requiredDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 60)),
                            );
                            if (picked != null) {
                              setState(() => _requiredDate = picked);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderLight),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(DateFormatter.formatShort(_requiredDate)),
                                const Icon(Icons.calendar_today_rounded, color: AppColors.cyanAccent, size: 18),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _submitRequest,
                            icon: const Icon(Icons.send_rounded),
                            label: const Text('Submit Bonafide Request'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                const Text(
                  'Your Request History & Status',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),

                if (bonafideRequests.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text('No bonafide requests submitted yet.', style: TextStyle(color: AppColors.textMuted)),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bonafideRequests.length,
                    itemBuilder: (context, index) {
                      final req = bonafideRequests[index];

                      final steps = [
                        TimelineStep(
                          title: 'Submitted',
                          description: 'Request #${req.id} received by Academic Section',
                          isCompleted: req.status.index >= RequestStatus.submitted.index,
                          isCurrent: req.status == RequestStatus.submitted,
                          time: DateFormatter.formatDateTime(req.createdAt),
                        ),
                        TimelineStep(
                          title: 'Under Review',
                          description: 'Verifying student roll & fee status',
                          isCompleted: req.status.index >= RequestStatus.underReview.index,
                          isCurrent: req.status == RequestStatus.underReview,
                        ),
                        TimelineStep(
                          title: 'Approved',
                          description: req.status == RequestStatus.approved || req.status == RequestStatus.documentReady
                              ? 'Approved by Academic Dean'
                              : 'Pending approval',
                          isCompleted: req.status.index >= RequestStatus.approved.index,
                          isCurrent: req.status == RequestStatus.approved,
                        ),
                        TimelineStep(
                          title: 'Document Ready',
                          description: req.status == RequestStatus.documentReady
                              ? 'Digital certificate generated & ready for download'
                              : 'Pending document generation',
                          isCompleted: req.status == RequestStatus.documentReady,
                          isCurrent: req.status == RequestStatus.documentReady,
                        ),
                      ];

                      return CustomCard(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'REQ #${req.id}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.cyanAccent),
                                ),
                                StatusBadge.fromRequestStatus(req.status),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              req.purpose,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Required by: ${DateFormatter.formatShort(req.requiredDate)}',
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                            ),
                            const SizedBox(height: 16),

                            // Timeline
                            StatusTimeline(steps: steps),

                            if (req.status == RequestStatus.approved || req.status == RequestStatus.documentReady) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Downloading Bonafide_Certificate.pdf...'),
                                        backgroundColor: AppColors.success,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.download_rounded),
                                  label: const Text('Download Official Bonafide PDF'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
