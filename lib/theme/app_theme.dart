import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bg = Color(0xFF07090F);
  static const bgGradientEnd = Color(0xFF0C1020);
  static const surface = Color(0xFF0E1118);
  static const card = Color(0xFF111420);
  static const cardLight = Color(0xFF181C2E);
  static const accent = Color(0xFF191D32);

  static const primary = Color(0xFFE94560);
  static const primaryDark = Color(0xFFB5334A);

  static const gold = Color(0xFFF5A623);
  static const goldDark = Color(0xFFC87810);

  static const diamond = Color(0xFF00D4FF);
  static const diamondDark = Color(0xFF0088AA);
  static const iron = Color(0xFFA8B8C8);
  static const coal = Color(0xFF526070);
  static const mine = Color(0xFFFF3D3D);

  static const success = Color(0xFF00E676);
  static const successDark = Color(0xFF00B248);

  static const textPrimary = Color(0xFFEDF0F4);
  static const textSecondary = Color(0xFF5A6880);

  static const cellUnrevealed = Color(0xFF131728);
  static const cellBorder = Color(0xFF1E2444);

  static const glowBlue = Color(0xFF00D4FF);
  static const glowRed = Color(0xFFE94560);

  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF07090F), Color(0xFF0C1020), Color(0xFF08091A)],
    stops: [0.0, 0.55, 1.0],
  );

  static LinearGradient primaryGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4F6B), Color(0xFFB5334A)],
  );

  static LinearGradient successGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00E676), Color(0xFF00B248)],
  );

  static LinearGradient diamondGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00D4FF), Color(0xFF0088CC)],
  );

  static LinearGradient goldGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF5A623), Color(0xFFC87810)],
  );

  static LinearGradient cardGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF181C2E), Color(0xFF111420)],
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
      boxShadow: shadows ??
          [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
    );
  }

  static BoxDecoration glowCard(Color glowColor, {double radius = 20}) {
    return glassCard(
      borderColor: glowColor.withOpacity(0.45),
      borderWidth: 1.5,
      radius: radius,
      shadows: [
        BoxShadow(
          color: glowColor.withOpacity(0.18),
          blurRadius: 24,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
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
          fontSize: 30,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.5,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          letterSpacing: 0.2,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w800,
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
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
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
      colors: [Color(0xFFEF4F6B), Color(0xFFB5334A)],
    ),
    this.radius = 14,
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
                  color: gradient.colors.first.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: gradient.colors.first.withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: 2,
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
