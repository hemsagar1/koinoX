import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/widgets/custom_card.dart';

class AdminCreateEventScreen extends StatefulWidget {
  const AdminCreateEventScreen({super.key});

  @override
  State<AdminCreateEventScreen> createState() => _AdminCreateEventScreenState();
}

class _AdminCreateEventScreenState extends State<AdminCreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _venueController = TextEditingController();
  final _descController = TextEditingController();
  final _capacityController = TextEditingController(text: '150');
  String _selectedCategory = 'Tech';

  final List<String> _categories = ['Tech', 'Cultural', 'Sports', 'Workshop', 'Career'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Campus Event')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Event Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(hintText: 'e.g. AI & Robotics Symposium 2026'),
                      validator: (val) => val == null || val.isEmpty ? 'Title required' : null,
                    ),
                    const SizedBox(height: 16),

                    const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(),
                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: 16),

                    const Text('Venue / Hall', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _venueController,
                      decoration: const InputDecoration(hintText: 'e.g. Main Auditorium'),
                      validator: (val) => val == null || val.isEmpty ? 'Venue required' : null,
                    ),
                    const SizedBox(height: 16),

                    const Text('Max Capacity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'e.g. 150'),
                    ),
                    const SizedBox(height: 16),

                    const Text('Event Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _descController,
                      maxLines: 3,
                      decoration: const InputDecoration(hintText: 'Event details and registration instructions...'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final appState = Provider.of<AppStateProvider>(context, listen: false);
                      await appState.addEvent(
                        title: _titleController.text.trim(),
                        description: _descController.text.trim().isNotEmpty
                            ? _descController.text.trim()
                            : 'Join the campus community for this official event.',
                        venue: _venueController.text.trim(),
                        category: _selectedCategory,
                        date: DateTime.now().add(const Duration(days: 7)),
                        time: '10:00 AM - 04:00 PM',
                        capacity: int.tryParse(_capacityController.text) ?? 150,
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Event created and published campus-wide!'), backgroundColor: AppColors.success),
                        );
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  icon: const Icon(Icons.event_available_rounded),
                  label: const Text('Publish Event'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
