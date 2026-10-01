import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/notice_model.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/custom_card.dart';
import '../../admin/notices/admin_create_notice_screen.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  NoticeType? _selectedCategoryFilter;

  void _showNoticeDetail(BuildContext context, NoticeModel notice, AppStateProvider appState) {
    appState.markNoticeAsRead(notice.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.cyanLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      notice.targetAudience,
                      style: const TextStyle(color: AppColors.navyPrimary, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                  Text(
                    DateFormatter.formatDateTime(notice.publishedAt),
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                notice.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                notice.content,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
              if (notice.attachmentName != null) ...[
                const SizedBox(height: 20),
                CustomCard(
                  backgroundColor: AppColors.bgLight,
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notice.attachmentName!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const Text('Official Circular Attachment', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.download_rounded, color: AppColors.navyPrimary),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Downloading ${notice.attachmentName}...')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(modalContext).pop(),
                  child: const Text('Close Notice'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Notice Board'),
        actions: [
          IconButton(
            icon: const Icon(Icons.post_add_rounded),
            tooltip: 'Publish Notice (Admin)',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AdminCreateNoticeScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          var notices = appState.notices;
          if (_selectedCategoryFilter != null) {
            notices = notices.where((n) => n.type == _selectedCategoryFilter).toList();
          }

          return Column(
            children: [
              // Category filter bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All Notices'),
                      selected: _selectedCategoryFilter == null,
                      onSelected: (val) => setState(() => _selectedCategoryFilter = null),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Academic'),
                      selected: _selectedCategoryFilter == NoticeType.academic,
                      onSelected: (val) => setState(() => _selectedCategoryFilter = NoticeType.academic),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Exams'),
                      selected: _selectedCategoryFilter == NoticeType.examination,
                      onSelected: (val) => setState(() => _selectedCategoryFilter = NoticeType.examination),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Hostel'),
                      selected: _selectedCategoryFilter == NoticeType.hostel,
                      onSelected: (val) => setState(() => _selectedCategoryFilter = NoticeType.hostel),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Events'),
                      selected: _selectedCategoryFilter == NoticeType.events,
                      onSelected: (val) => setState(() => _selectedCategoryFilter = NoticeType.events),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: notices.isEmpty
                    ? const Center(child: Text('No notices found', style: TextStyle(color: AppColors.textMuted)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: notices.length,
                        itemBuilder: (context, index) {
                          final notice = notices[index];

                          return CustomCard(
                            margin: const EdgeInsets.only(bottom: 12),
                            onTap: () => _showNoticeDetail(context, notice, appState),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (notice.isPriority) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.error.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'PRIORITY',
                                          style: TextStyle(
                                            color: AppColors.error,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.cyanLight,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        notice.targetAudience,
                                        style: const TextStyle(
                                          color: AppColors.navyPrimary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      DateFormatter.formatTimeAgo(notice.publishedAt),
                                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    if (!notice.isRead)
                                      Container(
                                        margin: const EdgeInsets.only(right: 6),
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: AppColors.cyanAccent,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    Expanded(
                                      child: Text(
                                        notice.title,
                                        style: TextStyle(
                                          fontWeight: notice.isRead ? FontWeight.w600 : FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notice.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
