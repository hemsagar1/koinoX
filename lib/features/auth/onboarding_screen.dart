import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _textAnimController;
  late AnimationController _iconAnimController;

  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _iconScale;
  late Animation<double> _iconFade;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'All Your Campus Needs\nIn One App',
      'subtitle': 'Academics, Hostel, Services,\nEvents and more.',
      'icon': Icons.school_rounded,
      'secondIcons': [
        Icons.calendar_month_rounded,
        Icons.menu_book_rounded,
        Icons.campaign_rounded,
        Icons.emoji_events_rounded,
      ],
      'color': AppColors.primary,
    },
    {
      'title': 'Track Requests &\nComplaints Live',
      'subtitle': 'Submit and monitor your requests\nstep-by-step in real time.',
      'icon': Icons.track_changes_rounded,
      'secondIcons': [
        Icons.handyman_rounded,
        Icons.workspace_premium_rounded,
        Icons.notifications_active_rounded,
        Icons.check_circle_rounded,
      ],
      'color': const Color(0xFF7C73E6),
    },
    {
      'title': 'Stay Connected,\nStay Ahead',
      'subtitle': 'Get instant notices, exam alerts\nand campus event updates.',
      'icon': Icons.connect_without_contact_rounded,
      'secondIcons': [
        Icons.notifications_rounded,
        Icons.event_rounded,
        Icons.article_rounded,
        Icons.people_rounded,
      ],
      'color': const Color(0xFF667EEA),
    },
  ];

  @override
  void initState() {
    super.initState();
    _textAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _iconAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textAnimController, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textAnimController, curve: Curves.easeOutCubic),
    );

    _iconScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _iconAnimController, curve: Curves.elasticOut),
    );
    _iconFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconAnimController, curve: Curves.easeOut),
    );

    _textAnimController.forward();
    _iconAnimController.forward();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _textAnimController.reset();
    _iconAnimController.reset();
    _textAnimController.forward();
    _iconAnimController.forward();
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                  parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _textAnimController.dispose();
    _iconAnimController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage < _slides.length - 1)
                    TextButton(
                      onPressed: _finishOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textMuted,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return _buildPage(index);
                },
              ),
            ),

            // Bottom Controls
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    final slide = _slides[index];
    final icons = slide['secondIcons'] as List<IconData>;
    final color = slide['color'] as Color;
    final isActive = index == _currentPage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        children: [
          // Title and subtitle with animation
          if (isActive) ...[
            SlideTransition(
              position: _textSlide,
              child: FadeTransition(
                opacity: _textFade,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      slide['title'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      slide['subtitle'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textMuted,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  slide['title'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  slide['subtitle'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textMuted,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 36),

          // Illustration area
          Expanded(
            child: isActive
                ? ScaleTransition(
                    scale: _iconScale,
                    child: FadeTransition(
                      opacity: _iconFade,
                      child: _buildIllustration(slide, icons, color),
                    ),
                  )
                : _buildIllustration(slide, icons, color),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildIllustration(
      Map<String, dynamic> slide, List<IconData> icons, Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: 0.08),
                color.withValues(alpha: 0.02),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Middle ring
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.06),
            border: Border.all(
              color: color.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),

        // Inner circle with main icon
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            slide['icon'] as IconData,
            size: 52,
            color: Colors.white,
          ),
        ),

        // Floating icon chips
        Positioned(
          bottom: 10,
          right: 10,
          child: _buildFloatingIconChip(icons[0], 0),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: _buildFloatingIconChip(icons[1], 1),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: _buildFloatingIconChip(icons[2], 2),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: _buildFloatingIconChip(icons[3], 3),
        ),
      ],
    );
  }

  Widget _buildFloatingIconChip(IconData icon, int index) {
    final colors = [
      const Color(0xFFFFF3CD),
      const Color(0xFFD4EDDA),
      const Color(0xFFCCE5FF),
      const Color(0xFFFFDDD6),
    ];
    final iconColors = [
      const Color(0xFFD4A017),
      const Color(0xFF28A745),
      const Color(0xFF0D6EFD),
      const Color(0xFFDC3545),
    ];

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors[index % colors.length],
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 22,
        color: iconColors[index % iconColors.length],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        children: [
          // Page Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Next / Get Started Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < _slides.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _finishOnboarding();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: AppColors.primary.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentPage == _slides.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _currentPage == _slides.length - 1
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
