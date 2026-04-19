import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bg = Color(0xFF080B14);
  static const bgGradientEnd = Color(0xFF0D1526);
  static const surface = Color(0xFF111827);
  static const card = Color(0xFF141E30);
  static const cardLight = Color(0xFF1C2940);
  static const accent = Color(0xFF1A3050);
  static const primary = Color(0xFFE94560);
  static const primaryDark = Color(0xFFB5334A);
  static const diamond = Color(0xFF00D4FF);
  static const diamondDark = Color(0xFF0088AA);
  static const iron = Color(0xFFB0BEC5);
  static const coal = Color(0xFF607080);
  static const mine = Color(0xFFFF4444);
  static const success = Color(0xFF00E676);
  static const successDark = Color(0xFF00B248);
  static const textPrimary = Color(0xFFECEFF1);
  static const textSecondary = Color(0xFF78909C);
  static const cellUnrevealed = Color(0xFF1A2540);
  static const cellBorder = Color(0xFF243350);
  static const glowBlue = Color(0xFF00D4FF);
  static const glowRed = Color(0xFFE94560);

  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bg, bgGradientEnd, Color(0xFF0A1020)],
  );

  static LinearGradient primaryGradient = const LinearGradient(
    colors: [Color(0xFFE94560), Color(0xFFC0392B)],
  );

  static LinearGradient successGradient = const LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00B248)],
  );

  static LinearGradient diamondGradient = const LinearGradient(
    colors: [Color(0xFF00D4FF), Color(0xFF0088CC)],
  );

  static LinearGradient cardGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1C2940), Color(0xFF111827)],
  );
}

class AppDecorations {
  static BoxDecoration glassCard({
    Color? borderColor,
    double borderWidth = 1,
    double radius = 20,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      gradient: AppColors.cardGradient,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor ?? AppColors.cellBorder,
        width: borderWidth,
      ),
      boxShadow: shadows,
    );
  }

  static BoxDecoration glowCard(Color glowColor, {double radius = 20}) {
    return glassCard(
      borderColor: glowColor.withOpacity(0.5),
      borderWidth: 1.5,
      radius: radius,
      shadows: [
        BoxShadow(
          color: glowColor.withOpacity(0.15),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    );
  }
}

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      background: AppColors.bg,
      surface: AppColors.surface,
      primary: AppColors.primary,
      secondary: AppColors.diamond,
    ),
    textTheme: GoogleFonts.rajdhaniTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: 3,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          letterSpacing: 0.3,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        fontFamily: 'Rajdhani',
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 11,
        letterSpacing: 0.5,
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
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
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    ),
  );
}

// Gradient button wrapper
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
      colors: [Color(0xFFE94560), Color(0xFFC0392B)],
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
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: gradient.colors.first.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
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
