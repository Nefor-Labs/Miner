import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
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
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _confirm() {
    final name = _ctrl.text.trim();
    if (name.isEmpty) return;
    ref.read(playerProvider.notifier).setNickname(name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Decorative background particles
            ..._buildParticles(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with layered glow
                      AnimatedBuilder(
                        animation: _pulseCtrl,
                        builder: (context, child) {
                          final pulse = _pulseCtrl.value;
                          return Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withOpacity(0.25 + pulse * 0.15),
                                  blurRadius: 30 + pulse * 20,
                                  spreadRadius: 2 + pulse * 4,
                                ),
                                BoxShadow(
                                  color: AppColors.diamond
                                      .withOpacity(0.08 + pulse * 0.06),
                                  blurRadius: 60 + pulse * 20,
                                  spreadRadius: 6,
                                ),
                              ],
                            ),
                            child: child,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/images/miner.jpg',
                            fit: BoxFit.contain,
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

                      const Gap(32),

                      // Title
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.primaryGradient.createShader(bounds),
                        child: Text(
                          'ШАХТЁР',
                          style:
                              Theme.of(context).textTheme.displayLarge?.copyWith(
                                    fontSize: 52,
                                    letterSpacing: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                        ),
                      ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 400.ms,
                            curve: Curves.easeOut,
                          ),

                      const Gap(8),

                      Text(
                        'Добывай • Улучшайся • Побеждай',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              letterSpacing: 1.5,
                              fontSize: 11,
                            ),
                      ).animate(delay: 350.ms).fadeIn(),

                      const Gap(52),

                      // Label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ИМЯ ШАХТЁРА',
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.7),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      ).animate(delay: 420.ms).fadeIn(),

                      const Gap(8),

                      // Input field
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.cardGradient,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _ctrl,
                          focusNode: _focus,
                          maxLength: 20,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 4,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: 'ТВОЙ НИК',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary.withOpacity(0.4),
                              letterSpacing: 4,
                              fontSize: 18,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                          ),
                          onSubmitted: (_) => _confirm(),
                        ),
                      ).animate(delay: 480.ms).fadeIn().slideY(begin: 0.3),

                      const Gap(24),

                      // Start button
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: GradientButton(
                          onPressed: _confirm,
                          gradient: AppColors.primaryGradient,
                          radius: 18,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.hardware_rounded, size: 20),
                              Gap(10),
                              Text(
                                'НАЧАТЬ ИГРУ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate(delay: 580.ms).fadeIn().slideY(begin: 0.3),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildParticles() {
    final rng = Random(42);
    return List.generate(14, (i) {
      final size = 2.0 + rng.nextDouble() * 3;
      final x = rng.nextDouble();
      final y = rng.nextDouble();
      final color = i % 3 == 0
          ? AppColors.primary
          : i % 3 == 1
              ? AppColors.diamond
              : AppColors.gold;
      return Positioned(
        left: MediaQuery.sizeOf(context).width * x,
        top: MediaQuery.sizeOf(context).height * y,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.15 + rng.nextDouble() * 0.15),
          ),
        )
            .animate(
              onPlay: (c) => c.repeat(reverse: true),
              delay: Duration(milliseconds: rng.nextInt(2000)),
            )
            .fadeIn(duration: Duration(milliseconds: 1500 + rng.nextInt(1000)))
            .then()
            .fadeOut(
                duration: Duration(milliseconds: 1500 + rng.nextInt(1000))),
      );
    });
  }
}
