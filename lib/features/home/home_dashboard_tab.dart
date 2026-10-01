import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/complaint_model.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/utils/date_formatter.dart';

import '../../core/widgets/offline_banner.dart';
import '../complaints/complaint_list_screen.dart';
import '../bonafide/bonafide_request_screen.dart';

import '../events/events_screen.dart';
import '../events/event_detail_screen.dart';
import '../notices/notices_screen.dart';
import '../notifications/notifications_screen.dart';
import '../digital_id/digital_id_screen.dart';
import '../mess/mess_screen.dart';


class HomeDashboardTab extends StatefulWidget {
  final Function(int) onTabChangeRequested;

  const HomeDashboardTab({super.key, required this.onTabChangeRequested});

  @override
  State<HomeDashboardTab> createState() => _HomeDashboardTabState();
}

class _HomeDashboardTabState extends State<HomeDashboardTab>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _cardFade;
  late Animation<double> _gridFade;
  late Animation<Offset> _gridSlide;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    _cardFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );
    _gridFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    _gridSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final s = appState.student;
        final activeComplaintsCount = appState.complaints
            .where((c) => c.status != ComplaintStatus.resolved)
            .length;

        final todayTimetable = MockDataService.todayTimetable;
        final latestNotices = appState.notices.take(2).toList();
        final upcomingEvents = appState.events.take(2).toList();
        final todayMess = MockDataService.weeklyMessMenu[0];
        final upcomingClass =
            todayTimetable.isNotEmpty ? todayTimetable.first : null;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OfflineBanner(),

              // ====== HEADER SECTION ======
              SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: _buildHeader(context, appState, s),
                ),
              ),

              // ====== UPCOMING CLASS CARD ======
              if (upcomingClass != null)
                FadeTransition(
                  opacity: _cardFade,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _buildUpcomingClassCard(context, upcomingClass),
                  ),
                ),

              // ====== QUICK ACTION GRID ======
              SlideTransition(
                position: _gridSlide,
                child: FadeTransition(
                  opacity: _gridFade,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: _buildQuickActionsGrid(context, appState),
                  ),
                ),
              ),

              // ====== TODAY'S HIGHLIGHTS ======
              FadeTransition(
                opacity: _gridFade,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: _buildHighlights(
                      context, s, activeComplaintsCount, appState),
                ),
              ),

              // ====== RECENT NOTICES ======
              FadeTransition(
                opacity: _gridFade,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: _buildRecentNotices(context, latestNotices),
                ),
              ),

              // ====== UPCOMING EVENTS ======
              FadeTransition(
                opacity: _gridFade,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: _buildUpcomingEvents(context, upcomingEvents),
                ),
              ),

              // ====== MESS CARD ======
              FadeTransition(
                opacity: _gridFade,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: _buildMessCard(context, todayMess),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---- HEADER ----
  Widget _buildHeader(BuildContext context, AppStateProvider appState, student) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${_getGreeting()} 👋',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Let\'s make today productive! 🎯',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Bell + Avatar
          Row(
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const NotificationsScreen()),
                      );
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: AppColors.textDark,
                        size: 22,
                      ),
                    ),
                  ),
                  if (appState.unreadNotificationCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${appState.unreadNotificationCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const DigitalIdScreen()),
                  );
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- UPCOMING CLASS CARD ----
  Widget _buildUpcomingClassCard(BuildContext context, dynamic upcomingClass) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B4FCF), Color(0xFF7B72E3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () => widget.onTabChangeRequested(1),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Upcoming Class',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        upcomingClass.subjectName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${upcomingClass.time} • ${upcomingClass.room}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'View',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- QUICK ACTIONS GRID ----
  Widget _buildQuickActionsGrid(BuildContext context, AppStateProvider appState) {
    final actions = [
      _QuickAction(
        icon: Icons.pie_chart_rounded,
        label: 'Attendance',
        color: const Color(0xFFEEF2FF),
        iconColor: AppColors.primary,
        onTap: () => widget.onTabChangeRequested(1),
      ),
      _QuickAction(
        icon: Icons.calendar_month_rounded,
        label: 'Timetable',
        color: const Color(0xFFF0FDF4),
        iconColor: const Color(0xFF16A34A),
        onTap: () => widget.onTabChangeRequested(1),
      ),
      _QuickAction(
        icon: Icons.article_rounded,
        label: 'Notes',
        color: const Color(0xFFFFF7ED),
        iconColor: const Color(0xFFD97706),
        onTap: () => widget.onTabChangeRequested(1),
      ),
      _QuickAction(
        icon: Icons.quiz_rounded,
        label: 'Exams',
        color: const Color(0xFFFFF1F2),
        iconColor: const Color(0xFFE11D48),
        onTap: () => widget.onTabChangeRequested(1),
      ),
      _QuickAction(
        icon: Icons.workspace_premium_rounded,
        label: 'Bonafide',
        color: const Color(0xFFEFF6FF),
        iconColor: const Color(0xFF2563EB),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const BonafideRequestScreen()),
          );
        },
      ),
      _QuickAction(
        icon: Icons.handyman_rounded,
        label: 'Complaint',
        color: const Color(0xFFFEF3C7),
        iconColor: const Color(0xFFD97706),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const ComplaintListScreen()),
          );
        },
      ),
      _QuickAction(
        icon: Icons.restaurant_menu_rounded,
        label: 'Mess Menu',
        color: const Color(0xFFF0FDF4),
        iconColor: const Color(0xFF15803D),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const MessScreen()));
        },
      ),
      _QuickAction(
        icon: Icons.event_rounded,
        label: 'Events',
        color: const Color(0xFFFDF4FF),
        iconColor: const Color(0xFF9333EA),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const EventsScreen()),
          );
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: actions
              .map((action) => _buildActionItem(context, action))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildActionItem(BuildContext context, _QuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: action.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(action.icon, color: action.iconColor, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            action.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textBody,
            ),
          ),
        ],
      ),
    );
  }

  // ---- HIGHLIGHTS ----
  Widget _buildHighlights(BuildContext context, student,
      int activeComplaintsCount, AppStateProvider appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Highlights',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildHighlightCard(
                value: '${MockDataService.todayTimetable.length}',
                label: 'Upcoming Classes',
                icon: Icons.school_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => widget.onTabChangeRequested(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHighlightCard(
                value: '${student.attendancePercentage.toStringAsFixed(0)}%',
                label: 'Attendance',
                icon: Icons.pie_chart_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => widget.onTabChangeRequested(1),
                showArrow: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHighlightCard({
    required String value,
    required String label,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
    bool showArrow = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow)
              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  // ---- RECENT NOTICES ----
  Widget _buildRecentNotices(BuildContext context, List<dynamic> notices) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Notices',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                letterSpacing: -0.2,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NoticesScreen()),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'View All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...notices.map((n) => _buildNoticeItem(context, n)),
      ],
    );
  }

  Widget _buildNoticeItem(BuildContext context, dynamic n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NoticesScreen()),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: n.isPriority
                        ? AppColors.errorLight
                        : AppColors.bgLightSecondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    n.isPriority
                        ? Icons.priority_high_rounded
                        : Icons.campaign_rounded,
                    color: n.isPriority ? AppColors.error : AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (n.isPriority)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'PRIORITY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              n.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: AppColors.textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        n.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '2h ago',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- UPCOMING EVENTS ----
  Widget _buildUpcomingEvents(BuildContext context, List<dynamic> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                letterSpacing: -0.2,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const EventsScreen()),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Explore',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...events.map((ev) => _buildEventItem(context, ev)),
      ],
    );
  }

  Widget _buildEventItem(BuildContext context, dynamic ev) {
    final categoryColors = {
      'technical': const Color(0xFF3B82F6),
      'cultural': const Color(0xFF9333EA),
      'sports': const Color(0xFF16A34A),
    };
    final catColor = categoryColors[ev.category.toLowerCase()] ?? AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => EventDetailScreen(eventId: ev.id)),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner area with gradient
              Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      catColor.withValues(alpha: 0.8),
                      catColor.withValues(alpha: 0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Center(
                        child: Icon(
                          Icons.event_rounded,
                          size: 44,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 14,
                      right: 14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ev.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          if (ev.description.isNotEmpty)
                            Text(
                              ev.description,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Details
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 13, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          DateFormatter.formatShort(ev.date),
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 12),
                        ),
                        const SizedBox(width: 14),
                        Icon(Icons.location_on_rounded,
                            size: 13, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            ev.venue,
                            style: const TextStyle(
                                color: AppColors.textMuted, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: catColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            ev.category.toUpperCase(),
                            style: TextStyle(
                              color: catColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Registration Open',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Register Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- MESS CARD ----
  Widget _buildMessCard(BuildContext context, dynamic todayMess) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const MessScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.restaurant_menu_rounded,
                  color: Color(0xFFD97706), size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Mess Lunch",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    todayMess.lunch,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });
}
