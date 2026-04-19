import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';

class NicknameScreen extends ConsumerStatefulWidget {
  const NicknameScreen({super.key});

  @override
  ConsumerState<NicknameScreen> createState() => _NicknameScreenState();
}

class _NicknameScreenState extends ConsumerState<NicknameScreen>
    with TickerProviderStateMixin {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  late final AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  void _confirm() {
    final name = _ctrl.text.trim();
    if (name.isEmpty) return;
    ref.read(playerProvider.notifier).setNickname(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          _GlowBackground(controller: _glowCtrl),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(24),
                    _LogoSection(controller: _glowCtrl),
                    const Gap(48),
                    _InputSection(
                      ctrl: _ctrl,
                      focus: _focus,
                      onConfirm: _confirm,
                    ),
                    const Gap(24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBackground extends StatelessWidget {
  final AnimationController controller;
  const _GlowBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, 0.6),
              radius: 1.2,
              colors: [
                AppColors.primary.withOpacity(0.06 + 0.04 * sin(t * pi)),
                AppColors.diamond.withOpacity(0.03 + 0.02 * cos(t * pi)),
                AppColors.bgDeep,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

class _LogoSection extends StatelessWidget {
  final AnimationController controller;
  const _LogoSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final glow = 0.3 + 0.15 * sin(controller.value * pi);
            return Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(glow),
                    blurRadius: 40,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: AppColors.diamond.withOpacity(glow * 0.5),
                    blurRadius: 70,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              'assets/images/miner.jpg',
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0.3, 0.3),
              duration: 800.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(duration: 500.ms),
        const Gap(28),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.primaryBright, AppColors.diamond],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'ШАХТЁР',
            style: GoogleFonts.rajdhani(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              letterSpacing: 10,
              color: Colors.white,
            ),
          ),
        )
            .animate(delay: 150.ms)
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.4, end: 0, curve: Curves.easeOutCubic),
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _dot(AppColors.diamond),
            const Gap(8),
            Text(
              'Добывай  •  Улучшайся  •  Побеждай',
              style: GoogleFonts.rajdhani(
                color: AppColors.textSecondary,
                fontSize: 13,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(8),
            _dot(AppColors.primary),
          ],
        ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
      ],
    );
  }

  Widget _dot(Color color) => Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _InputSection extends StatelessWidget {
  final TextEditingController ctrl;
  final FocusNode focus;
  final VoidCallback onConfirm;

  const _InputSection({
    required this.ctrl,
    required this.focus,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: AppDecorations.glowCard(AppColors.primary, radius: 18),
          child: TextField(
            controller: ctrl,
            focusNode: focus,
            maxLength: 20,
            textAlign: TextAlign.center,
            style: GoogleFonts.rajdhani(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 4,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'ТВОЙ НИК',
              hintStyle: GoogleFonts.rajdhani(
                color: AppColors.textSecondary,
                letterSpacing: 4,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              fillColor: Colors.transparent,
              filled: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
            ),
            onSubmitted: (_) => onConfirm(),
          ),
        ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3, end: 0),
        const Gap(16),
        SizedBox(
          width: double.infinity,
          child: GradientButton(
            onPressed: onConfirm,
            gradient: AppColors.primaryGradient,
            radius: 18,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.hardware_rounded, size: 20),
                const Gap(10),
                Text(
                  'НАЧАТЬ ИГРУ',
                  style: GoogleFonts.rajdhani(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ).animate(delay: 520.ms).fadeIn().slideY(begin: 0.3, end: 0),
        const Gap(20),
        Text(
          'Удачи в шахтах, горняк',
          style: GoogleFonts.rajdhani(
            color: AppColors.textTertiary,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ).animate(delay: 650.ms).fadeIn(),
      ],
    );
  }
}
