import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loadingController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _logoRotate;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _loadingFade;
  late Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Text animation controller
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Loading animation controller
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Pulse animation for logo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Logo animations
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _logoRotate = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // Title animations
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _loadingFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeIn),
    );

    _pulseScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Sequence animations
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _loadingController.forward();

    // Navigate after delay
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeOutCubic)),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF0EEFF),
              Color(0xFFF8F6FF),
              Color(0xFFFFFFFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background decorative circles
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.04),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.35,
              right: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.06),
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // Logo with animations
                  AnimatedBuilder(
                    animation: Listenable.merge(
                        [_logoController, _pulseController]),
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _logoFade,
                        child: Transform.rotate(
                          angle: _logoRotate.value,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: ScaleTransition(
                              scale: _pulseScale,
                              child: child,
                            ),
                          ),
                        ),
                      );
                    },
                    child: _buildLogoWidget(),
                  ),

                  const SizedBox(height: 32),

                  // App name - animated slide up
                  SlideTransition(
                    position: _titleSlide,
                    child: FadeTransition(
                      opacity: _titleFade,
                      child: const Text(
                        'KoinoX',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Subtitle - animated slide up with delay
                  SlideTransition(
                    position: _subtitleSlide,
                    child: FadeTransition(
                      opacity: _subtitleFade,
                      child: const Text(
                        'Your Complete Campus Companion',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Campus illustration placeholder
                  FadeTransition(
                    opacity: _subtitleFade,
                    child: _buildCampusIllustration(),
                  ),

                  const Spacer(flex: 1),

                  // Loading indicator
                  FadeTransition(
                    opacity: _loadingFade,
                    child: Column(
                      children: [
                        const Text(
                          'Loading...',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              minHeight: 4,
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.15),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 56),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoWidget() {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 60,
            spreadRadius: 8,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildCampusIllustration() {
    // Stylized campus building illustration using Flutter widgets
    return SizedBox(
      width: 260,
      height: 120,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Ground
          Positioned(
            bottom: 0,
            child: Container(
              width: 260,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Main building
          Positioned(
            bottom: 8,
            left: 60,
            child: _buildBuilding(width: 140, height: 80, color: const Color(0xFFE8E4FF)),
          ),
          // Left wing
          Positioned(
            bottom: 8,
            left: 20,
            child: _buildBuilding(width: 60, height: 55, color: const Color(0xFFDDD8FF)),
          ),
          // Right wing
          Positioned(
            bottom: 8,
            right: 20,
            child: _buildBuilding(width: 60, height: 55, color: const Color(0xFFDDD8FF)),
          ),
          // Windows on main building
          Positioned(
            bottom: 32,
            left: 95,
            child: Row(
              children: List.generate(3, (i) => Container(
                margin: const EdgeInsets.only(right: 12),
                width: 18,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              )),
            ),
          ),
          // Tree left
          Positioned(
            bottom: 8,
            left: 8,
            child: _buildTree(),
          ),
          // Tree right
          Positioned(
            bottom: 8,
            right: 8,
            child: _buildTree(),
          ),
        ],
      ),
    );
  }

  Widget _buildBuilding({required double width, required double height, required Color color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Roof triangle
        CustomPaint(
          painter: _RoofPainter(color: color),
          size: Size(width, 20),
        ),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTree() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),
        Container(width: 4, height: 12, color: const Color(0xFFD4A870)),
      ],
    );
  }
}

class _RoofPainter extends CustomPainter {
  final Color color;
  _RoofPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
