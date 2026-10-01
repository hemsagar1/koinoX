import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/complaint_model.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/offline_banner.dart';
import '../../core/widgets/status_badge.dart';
import 'create_complaint_screen.dart';
import 'complaint_detail_screen.dart';

class ComplaintListScreen extends StatefulWidget {
  const ComplaintListScreen({super.key});

  @override
  State<ComplaintListScreen> createState() => _ComplaintListScreenState();
}

class _ComplaintListScreenState extends State<ComplaintListScreen> {
  int _selectedTabIndex = 0; // 0: All, 1: Active, 2: Resolved

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Complaints'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'New Complaint',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CreateComplaintScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.cyanAccent,
        foregroundColor: AppColors.navyPrimary,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreateComplaintScreen()),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Complaint', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip(0, 'All'),
                const SizedBox(width: 8),
                _buildFilterChip(1, 'Active'),
                const SizedBox(width: 8),
                _buildFilterChip(2, 'Resolved'),
              ],
            ),
          ),
          Expanded(
            child: Consumer<AppStateProvider>(
              builder: (context, appState, child) {
                var list = appState.complaints;
                if (_selectedTabIndex == 1) {
                  list = list.where((c) => c.status != ComplaintStatus.resolved).toList();
                } else if (_selectedTabIndex == 2) {
                  list = list.where((c) => c.status == ComplaintStatus.resolved).toList();
                }

                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.assignment_outlined, size: 64, color: AppColors.textMuted),
                        SizedBox(height: 16),
                        Text(
                          'No complaints found',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final complaint = list[index];
                    return CustomCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ComplaintDetailScreen(complaintId: complaint.id),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '#${complaint.id}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.cyanAccent,
                                  fontSize: 13,
                                ),
                              ),
                              StatusBadge.fromComplaintStatus(complaint.status),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            complaint.category,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            complaint.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    complaint.location,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                              Text(
                                DateFormatter.formatTimeAgo(complaint.createdAt),
                                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
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
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedTabIndex == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.navyPrimary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textDark,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (val) {
        if (val) setState(() => _selectedTabIndex = index);
      },
    );
  }
}
