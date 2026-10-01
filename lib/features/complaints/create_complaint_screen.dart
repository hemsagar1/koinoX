import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/offline_banner.dart';
import 'complaint_detail_screen.dart';

class CreateComplaintScreen extends StatefulWidget {
  final String? initialCategory;

  const CreateComplaintScreen({super.key, this.initialCategory});

  @override
  State<CreateComplaintScreen> createState() => _CreateComplaintScreenState();
}

class _CreateComplaintScreenState extends State<CreateComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedCategory;
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _hasAttachment = false;

  final List<String> _categories = [
    'Plumbing',
    'Electrical',
    'Cleaning & Sanitation',
    'Wi-Fi / Internet',
    'Hostel Maintenance',
    'Classroom',
    'Mess / Food Quality',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? _categories[0];
    if (_selectedCategory == 'Hostel Maintenance') {
      _locationController.text = 'Block A, Room A-204';
    } else if (_selectedCategory == 'Wi-Fi / Internet') {
      _locationController.text = 'Block A - 2nd Floor';
    }
  }

  void _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      final id = await appState.createComplaint(
        category: _selectedCategory,
        location: _locationController.text,
        description: _descriptionController.text,
        imagePath: _hasAttachment ? 'mock_attachment.jpg' : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: appState.isOnline ? AppColors.navyPrimary : AppColors.offline,
            content: Text(
              appState.isOnline
                  ? 'Complaint #$id registered successfully!'
                  : 'Complaint #$id saved locally in offline mode!',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );

        final createdComplaint = appState.complaints.firstWhere((c) => c.id == id);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ComplaintDetailScreen(complaintId: createdComplaint.id),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Maintenance Request'),
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Complaint Category',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedCategory,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.category_rounded, color: AppColors.cyanAccent),
                            ),
                            items: _categories.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedCategory = val);
                              }
                            },
                          ),
                          const SizedBox(height: 20),

                          const Text(
                            'Location',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              hintText: 'e.g. Block A Room A-204 or CS Lab 2',
                              prefixIcon: Icon(Icons.location_on_rounded, color: AppColors.cyanAccent),
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Please enter location' : null,
                          ),
                          const SizedBox(height: 20),

                          const Text(
                            'Description of Issue',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: 'Provide details about the issue...',
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Please describe the issue' : null,
                          ),
                          const SizedBox(height: 20),

                          const Text(
                            'Attachment (Optional)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              setState(() => _hasAttachment = !_hasAttachment);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _hasAttachment ? AppColors.cyanLight : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _hasAttachment ? AppColors.cyanAccent : Colors.grey.shade300,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _hasAttachment ? Icons.check_circle : Icons.camera_alt_rounded,
                                    color: _hasAttachment ? AppColors.navyPrimary : AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _hasAttachment ? 'Photo attached (photo_1.jpg)' : 'Tap to attach photo / screenshot',
                                    style: TextStyle(
                                      color: _hasAttachment ? AppColors.navyPrimary : AppColors.textMuted,
                                      fontWeight: _hasAttachment ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitComplaint,
                        icon: const Icon(Icons.send_rounded),
                        label: const Text('Submit Complaint'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
