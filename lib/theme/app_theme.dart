import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bg = Color(0xFF07080E);
  static const bgDeep = Color(0xFF030407);

  static const surface = Color(0xFF111219);
  static const card = Color(0xFF151621);
  static const cardLight = Color(0xFF1A1B28);
  static const accent = Color(0xFF1F2035);

  static const borderDim = Color(0xFF181929);
  static const cellBorder = Color(0xFF252637);
  static const borderBright = Color(0xFF333450);

  static const primary = Color(0xFFE8345A);
  static const primaryBright = Color(0xFFFF4D72);
  static const primaryDark = Color(0xFFBE2349);

  static const diamond = Color(0xFF22D3EE);
  static const diamondBright = Color(0xFF67E8F9);
  static const diamondDark = Color(0xFF0891B2);

  static const gold = Color(0xFFF59E0B);
  static const goldBright = Color(0xFFFDE68A);
  static const goldDark = Color(0xFFD97706);

  static const iron = Color(0xFF94A3B8);
  static const ironDark = Color(0xFF64748B);

  static const coal = Color(0xFF64748B);
  static const coalDark = Color(0xFF475569);

  static const mine = Color(0xFFEF4444);
  static const mineDark = Color(0xFFB91C1C);

  static const success = Color(0xFF10B981);
  static const successBright = Color(0xFF34D399);
  static const successDark = Color(0xFF059669);

  static const textPrimary = Color(0xFFF8FAFC);
  static const textSecondary = Color(0xFF64748B);
  static const textTertiary = Color(0xFF334155);

  static const cellUnrevealed = Color(0xFF151621);
  static const glowBlue = diamond;
  static const glowRed = primary;

  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bg, bgDeep],
  );

  static LinearGradient primaryGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBright, primaryDark],
  );

  static LinearGradient successGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [successBright, successDark],
  );

  static LinearGradient diamondGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [diamondBright, diamondDark],
  );

  static LinearGradient goldGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldBright, goldDark],
  );

  static LinearGradient cardGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardLight, card],
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
              color: Colors.black.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
    );
  }

  static BoxDecoration glowCard(Color glowColor, {double radius = 20}) {
    return BoxDecoration(
      gradient: AppColors.cardGradient,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: glowColor.withOpacity(0.45), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: glowColor.withOpacity(0.18),
          blurRadius: 24,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration mineralCard(Color accent, {double radius = 20}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accent.withOpacity(0.12),
          AppColors.card,
        ],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: accent.withOpacity(0.3), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: accent.withOpacity(0.12),
          blurRadius: 20,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
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
          letterSpacing: 3,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
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
    cardTheme: CardTheme(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.cellBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.cellBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
  );
}

class GradientButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final LinearGradient? gradient;
  final double radius;
  final EdgeInsets? padding;
  final Color? shadowColor;

  const GradientButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.gradient,
    this.radius = 16,
    this.padding,
    this.shadowColor,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 80),
    reverseDuration: const Duration(milliseconds: 280),
  );

  bool get _enabled => widget.onPressed != null;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = widget.gradient ?? AppColors.primaryGradient;
    final shadowColor = widget.shadowColor ?? gradient.colors.first;
    final enabled = _enabled;

    return GestureDetector(
      onTapDown: enabled ? (_) => _ctrl.forward() : null,
      onTapUp: enabled
          ? (_) {
              _ctrl.reverse();
              widget.onPressed!();
            }
          : null,
      onTapCancel: enabled ? () => _ctrl.reverse() : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) => Transform.scale(
          scale: 1.0 - 0.04 * _ctrl.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: enabled ? gradient : null,
            color: enabled ? null : AppColors.accent,
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: shadowColor.withOpacity(0.45),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: shadowColor.withOpacity(0.15),
                      blurRadius: 36,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: enabled ? Colors.white : AppColors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
            child: IconTheme(
              data: IconThemeData(
                color: enabled ? Colors.white : AppColors.textSecondary,
                size: 18,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
