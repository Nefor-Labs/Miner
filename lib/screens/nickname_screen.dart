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

class _NicknameScreenState extends ConsumerState<NicknameScreen> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
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
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Логотип с glow-эффектом
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: AppColors.diamond.withOpacity(0.15),
                          blurRadius: 60,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        'assets/images/miner.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.4, 0.4),
                        duration: 700.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 400.ms),

                  const Gap(28),

                  // Заголовок
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.primaryGradient.createShader(bounds),
                    child: Text(
                      'ШАХТЁР',
                      style:
                          Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontSize: 44,
                                letterSpacing: 8,
                                color: Colors.white,
                              ),
                    ),
                  ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3),

                  const Gap(6),

                  Text(
                    'Добывай • Улучшайся • Побеждай',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          letterSpacing: 1,
                        ),
                  ).animate(delay: 350.ms).fadeIn(),

                  const Gap(48),

                  // Поле ввода
                  Container(
                    decoration: AppDecorations.glowCard(AppColors.primary,
                        radius: 18),
                    child: TextField(
                      controller: _ctrl,
                      focusNode: _focus,
                      maxLength: 20,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        hintText: 'ТВОЙ НИК',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          letterSpacing: 3,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                      ),
                      onSubmitted: (_) => _confirm(),
                    ),
                  ).animate(delay: 450.ms).fadeIn().slideY(begin: 0.3),

                  const Gap(20),

                  // Кнопка
                  SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      onPressed: _confirm,
                      gradient: AppColors.primaryGradient,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hardware_rounded, size: 20),
                          Gap(10),
                          Text(
                            'НАЧАТЬ ИГРУ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: 550.ms).fadeIn().slideY(begin: 0.3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
