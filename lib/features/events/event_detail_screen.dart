import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/event_model.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/qr_code_widget.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  void _showSuccessPassDialog(BuildContext context, EventModel event, AppStateProvider appState) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.cyanLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: AppColors.tealPrimary, size: 48),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Registration Successful!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your digital pass for "${event.title}" is generated.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.navyPrimary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        event.title.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.cyanAccent,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Attendee: ${appState.student.name} (${appState.student.rollNumber})',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      QrCodeWidget(
                        data: 'KOINOX-EVENT-${event.id}-${appState.student.rollNumber}',
                        size: 150,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Show this QR code at venue entrance',
                        style: TextStyle(color: AppColors.textMutedDark, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Close Pass'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final event = appState.events.firstWhere(
          (e) => e.id == eventId,
          orElse: () => appState.events.first,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(event.title),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCard(
                  backgroundColor: AppColors.navyPrimary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.navySecondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cyanAccent.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          event.category,
                          style: const TextStyle(color: AppColors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.title,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Organized by: ${event.organizer}',
                        style: const TextStyle(color: AppColors.textMutedDark, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: CustomCard(
                        child: Column(
                          children: [
                            const Icon(Icons.calendar_today_rounded, color: AppColors.cyanAccent),
                            const SizedBox(height: 6),
                            const Text('Date', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            const SizedBox(height: 2),
                            Text(
                              DateFormatter.formatShort(event.date),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomCard(
                        child: Column(
                          children: [
                            const Icon(Icons.access_time_rounded, color: AppColors.cyanAccent),
                            const SizedBox(height: 6),
                            const Text('Time', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            const SizedBox(height: 2),
                            Text(
                              event.time,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                CustomCard(
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.cyanAccent, size: 24),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Venue', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          Text(
                            event.venue,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About Event',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Seats Registered: ${event.registeredCount} / ${event.capacity}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: event.registeredCount / event.capacity,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cyanAccent),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                if (event.isRegistered) ...[
                  CustomCard(
                    backgroundColor: AppColors.cyanLight,
                    child: Column(
                      children: [
                        const Text(
                          'You are registered for this event!',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navyPrimary, fontSize: 15),
                        ),
                        const SizedBox(height: 12),
                        QrCodeWidget(data: event.passQrCode ?? 'KOINOX-PASS', size: 160),
                        const SizedBox(height: 8),
                        const Text('Digital Event Pass (QR)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      ],
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await appState.registerForEvent(event.id);
                        if (context.mounted) {
                          _showSuccessPassDialog(context, event, appState);
                        }
                      },
                      icon: const Icon(Icons.confirmation_number_rounded),
                      label: const Text('Register for Event (Free)'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
