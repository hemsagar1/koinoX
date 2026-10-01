import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/notice_model.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/widgets/custom_card.dart';

class AdminCreateNoticeScreen extends StatefulWidget {
  const AdminCreateNoticeScreen({super.key});

  @override
  State<AdminCreateNoticeScreen> createState() => _AdminCreateNoticeScreenState();
}

class _AdminCreateNoticeScreenState extends State<AdminCreateNoticeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  NoticeType _selectedType = NoticeType.academic;
  String _selectedAudience = 'All Students';
  bool _isPriority = false;

  final List<String> _audiences = [
    'All Students',
    'BCA / B.Tech 2nd Year',
    'Hostel Block A & B',
    'Faculty & Staff',
  ];

  void _publishNotice() async {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      await appState.addNotice(
        title: _titleController.text,
        content: _contentController.text,
        type: _selectedType,
        targetAudience: _selectedAudience,
        isPriority: _isPriority,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.success,
            content: Text('Notice published across campus!'),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publish Official Notice'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Notice Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(hintText: 'e.g. Schedule for Campus Placements 2026'),
                      validator: (val) => val == null || val.isEmpty ? 'Title required' : null,
                    ),
                    const SizedBox(height: 16),

                    const Text('Notice Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<NoticeType>(
                      initialValue: _selectedType,
                      decoration: const InputDecoration(),
                      items: NoticeType.values.map((t) {
                        return DropdownMenuItem(value: t, child: Text(t.name.toUpperCase()));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedType = val);
                      },
                    ),
                    const SizedBox(height: 16),

                    const Text('Target Audience', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedAudience,
                      decoration: const InputDecoration(),
                      items: _audiences.map((aud) {
                        return DropdownMenuItem(value: aud, child: Text(aud));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedAudience = val);
                      },
                    ),
                    const SizedBox(height: 16),

                    const Text('Notice Body / Content', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _contentController,
                      maxLines: 4,
                      decoration: const InputDecoration(hintText: 'Write notice details...'),
                      validator: (val) => val == null || val.isEmpty ? 'Content required' : null,
                    ),
                    const SizedBox(height: 16),

                    SwitchListTile(
                      title: const Text('Mark as Urgent / Priority Notice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      value: _isPriority,
                      activeThumbColor: AppColors.error,
                      onChanged: (val) => setState(() => _isPriority = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _publishNotice,
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Broadcast Notice'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
