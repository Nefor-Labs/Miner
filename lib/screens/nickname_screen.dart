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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Логотип — уменьшен и показывает всю картинку целиком
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.6),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.asset(
                      'assets/images/miner.jpg',
                      fit: BoxFit.contain, // вся картинка целиком
                    ),
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(),
                const Gap(24),
                Text(
                  'ШАХТЁР',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 40,
                        letterSpacing: 6,
                        color: AppColors.primary,
                      ),
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3),
                const Gap(6),
                Text(
                  'Введи своё шахтёрское имя',
                  style: Theme.of(context).textTheme.bodyMedium,
                ).animate(delay: 300.ms).fadeIn(),
                const Gap(40),
                TextField(
                  controller: _ctrl,
                  focusNode: _focus,
                  maxLength: 20,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'НИК',
                    hintStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      letterSpacing: 4,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: AppColors.cellBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                  onSubmitted: (_) => _confirm(),
                ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3),
                const Gap(20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _confirm,
                    icon: const Icon(Icons.hardware_rounded, size: 18),
                    label: const Text('НАЧАТЬ ИГРУ'),
                  ),
                ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
