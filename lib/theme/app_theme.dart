import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Backgrounds — exact site dark palette: body=#131217, card=#1c1c24
  static const bg = Color(0xFF131217);
  static const bgGradientEnd = Color(0xFF1C1C24);
  static const surface = Color(0xFF131217);
  static const card = Color(0xFF1C1C24);
  static const cardLight = Color(0xFF222230);
  static const accent = Color(0xFF252535);

  // Brand — site: #2e73ff (blue), #30fc9d (green)
  static const primary = Color(0xFF2E73FF);
  static const primaryDark = Color(0xFF1F5FD9);

  // Score color
  static const gold = Color(0xFFF0B429);
  static const goldDark = Color(0xFFBF8C10);

  // Resources
  static const diamond = Color(0xFF2E73FF);
  static const diamondDark = Color(0xFF1F5FD9);
  static const iron = Color(0xFF8A8A9A);
  static const coal = Color(0xFF525262);
  static const mine = Color(0xFFFF4455);

  // Success / cashout — brand green
  static const success = Color(0xFF30FC9D);
  static const successDark = Color(0xFF1EC878);

  // Text — site: #ffffff, #8a8a8a
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8A8A8A);

  // Cells
  static const cellUnrevealed = Color(0xFF1C1C24);
  static const cellUnrevealedTop = Color(0xFF1A2040);
  static const cellUnrevealedBot = Color(0xFF101525);
  static const cellBorder = Color(0xFF2A2A38);

  // Kept for cell glow usage
  static const glowBlue = Color(0xFF2E73FF);
  static const glowRed = Color(0xFFFF4455);

  // Site body is flat #131217 — subtle gradient just for depth
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF131217), Color(0xFF111116), Color(0xFF131217)],
    stops: [0.0, 0.5, 1.0],
  );

  // Site brand gradient: blue → green
  static LinearGradient primaryGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2E73FF), Color(0xFF30FC9D)],
  );

  static LinearGradient successGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF30FC9D), Color(0xFF1EC878)],
  );

  static LinearGradient diamondGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2E73FF), Color(0xFF1F5FD9)],
  );

  static LinearGradient goldGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF0B429), Color(0xFFBF8C10)],
  );

  // Site cards are solid #1c1c24 — no gradient
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1C1C24), Color(0xFF1C1C24)],
  );
}

class AppDecorations {
  // Site shadow: "0 2px 20px rgba(0,0,0,0.08)" — clean, no glow
  static BoxDecoration glassCard({
    Color? borderColor,
    double borderWidth = 1,
    double radius = 24,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor ?? AppColors.cellBorder.withOpacity(0.6),
        width: borderWidth,
      ),
      boxShadow: shadows ??
          [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 2),
            ),
          ],
    );
  }

  // State-accent card: colored border only, no glow shadow
  static BoxDecoration glowCard(Color glowColor, {double radius = 24}) {
    return glassCard(
      borderColor: glowColor.withOpacity(0.35),
      borderWidth: 1.5,
      radius: radius,
    );
  }
}

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.surface,
      primary: AppColors.primary,
      secondary: AppColors.success,
    ),
    textTheme: GoogleFonts.urbanistTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.urbanist(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    ),
  );
}

class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final LinearGradient gradient;
  final double radius;
  final EdgeInsets? padding;

  const GradientButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.gradient = const LinearGradient(
      colors: [Color(0xFF2E73FF), Color(0xFF30FC9D)],
    ),
    this.radius = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: onPressed != null ? gradient : null,
        color: onPressed != null ? null : AppColors.accent,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        child: child,
      ),
    );
  }
}
