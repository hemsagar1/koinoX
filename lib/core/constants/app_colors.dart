import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors - Purple / Violet (matching KoinoX design)
  static const Color primary = Color(0xFF5B4FCF);       // Main purple
  static const Color primaryLight = Color(0xFF7B72E3);  // Lighter purple
  static const Color primaryDark = Color(0xFF3D349A);   // Darker purple
  static const Color primaryDeep = Color(0xFF2D2480);   // Deepest purple

  // Secondary / Accent Colors
  static const Color secondary = Color(0xFF00BCD4);     // Cyan accent
  static const Color secondaryLight = Color(0xFF80DEEA);
  static const Color accent = Color(0xFF7C73E6);        // Violet accent

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color offline = Color(0xFFF97316);

  // Neutral Colors - Light Theme
  static const Color bgLight = Color(0xFFF5F5FF);       // Very light purple tint bg
  static const Color bgLightSecondary = Color(0xFFEEEEFF); // Slightly more purple
  static const Color bgWhite = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A2E);      // Very dark navy
  static const Color textBody = Color(0xFF374151);       // Body text
  static const Color textMuted = Color(0xFF6B7280);     // Muted text
  static const Color textLight2 = Color(0xFF9CA3AF);    // Light text
  static const Color borderLight = Color(0xFFE5E7EB);   // Light border
  static const Color borderPurple = Color(0xFFDDD6FE);  // Purple border

  // Neutral Colors - Dark Theme
  static const Color bgDark = Color(0xFF0F0E1A);
  static const Color cardDark = Color(0xFF1A1930);
  static const Color textLight = Color(0xFFFDFDFE);
  static const Color textMutedDark = Color(0xFF9090A7);
  static const Color borderDark = Color(0xFF2D2D4F);

  // Legacy mappings to keep codebase compiling
  static const Color navyPrimary = primary;
  static const Color navySecondary = primaryLight;
  static const Color navyAccent = primaryDark;
  static const Color cyanAccent = secondary;
  static const Color tealPrimary = accent;
  static const Color cyanLight = bgLightSecondary;

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5B4FCF), Color(0xFF7B72E3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleBlueGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFFEEEEFF), Color(0xFFF5F5FF), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF5B4FCF), Color(0xFF7B72E3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightGradient = LinearGradient(
    colors: [Color(0xFFF5F5FF), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
