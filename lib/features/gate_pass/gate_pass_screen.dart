import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/request_model.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/qr_code_widget.dart';
import '../../core/widgets/status_badge.dart';

class GatePassScreen extends StatefulWidget {
  const GatePassScreen({super.key});

  @override
  State<GatePassScreen> createState() => _GatePassScreenState();
}

class _GatePassScreenState extends State<GatePassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController(text: 'Medical Appointment at City Hospital');
  final _outTimeController = TextEditingController(text: '04:30 PM');
  final _returnTimeController = TextEditingController(text: '08:00 PM');
  final DateTime _passDate = DateTime.now();

  void _submitGatePass() async {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      final id = await appState.createRequest(
        type: RequestType.gatePass,
        purpose: _reasonController.text,
        requiredDate: _passDate,
        outTime: _outTimeController.text,
        expectedReturn: _returnTimeController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.navyPrimary,
            content: Text('Gate Pass Request #$id submitted for approval!'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Gate Pass'),
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          final gatePasses = appState.requests
              .where((r) => r.type == RequestType.gatePass)
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.door_sliding_rounded, color: AppColors.cyanAccent, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Create Campus Exit Gate Pass',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        const Text('Reason for Leaving Campus', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _reasonController,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Medical, Family Visit, Market',
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Reason required' : null,
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Out Time', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: _outTimeController,
                                    decoration: const InputDecoration(hintText: '04:30 PM'),
                                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Expected Return', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: _returnTimeController,
                                    decoration: const InputDecoration(hintText: '08:00 PM'),
                                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _submitGatePass,
                            icon: const Icon(Icons.qr_code_2_rounded),
                            label: const Text('Generate Gate Pass Request'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                const Text(
                  'Active & Recent Gate Passes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),

                if (gatePasses.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text('No gate pass requests found.', style: TextStyle(color: AppColors.textMuted)),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: gatePasses.length,
                    itemBuilder: (context, index) {
                      final pass = gatePasses[index];

                      return CustomCard(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'PASS #${pass.id}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.cyanAccent),
                                ),
                                StatusBadge.fromRequestStatus(pass.status),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pass.purpose,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text('Out: ${pass.outTime ?? "05:00 PM"}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                const SizedBox(width: 16),
                                Text('Return: ${pass.expectedReturn ?? "08:00 PM"}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            const SizedBox(height: 12),

                            if (pass.status == RequestStatus.approved) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.navyPrimary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'VERIFIED DIGITAL GATE PASS',
                                      style: TextStyle(color: AppColors.cyanAccent, fontWeight: FontWeight.w900, fontSize: 12),
                                    ),
                                    const SizedBox(height: 12),
                                    QrCodeWidget(data: 'GATEPASS-${pass.id}-${appState.student.rollNumber}', size: 140),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Scan at Campus Security Gate',
                                      style: TextStyle(color: AppColors.textMutedDark, fontSize: 11),
                                    ),
                                  ],
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
