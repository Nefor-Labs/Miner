import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import 'base_screen.dart';
import 'game_screen.dart';
import 'quests_screen.dart';
import 'shop_screen.dart';
import 'profile_screen.dart';

final _tabProvider = StateProvider<int>((ref) => 0);

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const _screens = [
    GameScreen(),
    BaseScreen(),
    QuestsScreen(),
    ShopScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(_tabProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBody: true,
      body: IndexedStack(index: tab, children: _screens),
      bottomNavigationBar: _BottomNav(
        currentIndex: tab,
        onTap: (i) => ref.read(_tabProvider.notifier).state = i,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  static const _items = [
    (Icons.hardware_rounded, AppColors.primary, 'Шахта'),
    (Icons.factory_rounded, AppColors.iron, 'База'),
    (Icons.assignment_rounded, AppColors.success, 'Задания'),
    (Icons.storefront_rounded, AppColors.diamond, 'Магазин'),
    (Icons.person_rounded, AppColors.primary, 'Профиль'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cardLight.withOpacity(0.92),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: AppColors.cellBorder.withOpacity(0.6),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_items.length, (i) {
                  final (icon, accent, label) = _items[i];
                  final selected = currentIndex == i;
                  return _NavItem(
                    icon: icon,
                    label: label,
                    selected: selected,
                    accent: accent,
                    onTap: () => onTap(i),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: selected
            ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    accent.withOpacity(0.22),
                    accent.withOpacity(0.06),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: accent.withOpacity(0.35), width: 1),
              )
            : const BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: selected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                color: selected
                    ? accent
                    : AppColors.textSecondary.withOpacity(0.5),
                size: 22,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: selected ? accent : AppColors.textSecondary.withOpacity(0.4),
                fontSize: selected ? 10 : 9,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.3,
                fontFamily: 'Rajdhani',
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
