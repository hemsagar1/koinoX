import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_card.dart';
import '../complaints/complaint_list_screen.dart';
import '../bonafide/bonafide_request_screen.dart';
import '../gate_pass/gate_pass_screen.dart';
import '../hostel/hostel_screen.dart';
import '../mess/mess_screen.dart';
import '../digital_id/digital_id_screen.dart';
import '../notices/notices_screen.dart';
import '../events/events_screen.dart';
import '../achievements/achievements_screen.dart';
import '../gallery/gallery_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'title': 'Complaints Desk',
        'subtitle': 'Report maintenance & track status live',
        'icon': Icons.handyman_rounded,
        'color': AppColors.navyPrimary,
        'screen': const ComplaintListScreen(),
      },
      {
        'title': 'Bonafide Certificate',
        'subtitle': 'Apply & download official certificates',
        'icon': Icons.workspace_premium_rounded,
        'color': AppColors.tealPrimary,
        'screen': const BonafideRequestScreen(),
      },
      {
        'title': 'Gate Pass',
        'subtitle': 'Out pass requests with QR verification',
        'icon': Icons.door_sliding_rounded,
        'color': AppColors.cyanAccent,
        'screen': const GatePassScreen(),
      },
      {
        'title': 'Hostel & Room',
        'subtitle': 'Room info, warden desk & rules',
        'icon': Icons.other_houses_rounded,
        'color': Colors.indigo,
        'screen': const HostelScreen(),
      },
      {
        'title': 'Mess & Dining',
        'subtitle': 'Daily menu, rating & feedback',
        'icon': Icons.restaurant_menu_rounded,
        'color': Colors.orange.shade700,
        'screen': const MessScreen(),
      },
      {
        'title': 'Digital Student ID',
        'subtitle': 'Instant digital pass with QR code',
        'icon': Icons.badge_rounded,
        'color': AppColors.navyPrimary,
        'screen': const DigitalIdScreen(),
      },
      {
        'title': 'Notices & Circulars',
        'subtitle': 'Official academic and hostel updates',
        'icon': Icons.campaign_rounded,
        'color': Colors.purple.shade700,
        'screen': const NoticesScreen(),
      },
      {
        'title': 'Campus Events',
        'subtitle': 'Browse fests & get event passes',
        'icon': Icons.event_seat_rounded,
        'color': AppColors.tealPrimary,
        'screen': const EventsScreen(),
      },
      {
        'title': 'Achievements',
        'subtitle': 'College, hackathon & sports awards',
        'icon': Icons.emoji_events_rounded,
        'color': Colors.amber.shade800,
        'screen': const AchievementsScreen(),
      },
      {
        'title': 'Campus Gallery',
        'subtitle': 'Event albums & campus photos',
        'icon': Icons.photo_library_rounded,
        'color': Colors.pink.shade700,
        'screen': const GalleryScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Services'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.95,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final s = services[index];
          final color = s['color'] as Color;

          return CustomCard(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => s['screen'] as Widget),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(s['icon'] as IconData, color: color, size: 28),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s['subtitle'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
