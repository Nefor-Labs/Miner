import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';
import 'shop_screen.dart';
import 'profile_screen.dart';

final _tabProvider = StateProvider<int>((ref) => 0);

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const _screens = [
    GameScreen(),
    ShopScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(_tabProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F1722), Color(0xFF080B14)],
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.cellBorder.withOpacity(0.5),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.hardware_rounded,
                label: 'Шахта',
                selected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.storefront_rounded,
                label: 'Магазин',
                selected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Профиль',
                selected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
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
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  gradient: selected
                      ? LinearGradient(colors: [
                          AppColors.primary.withOpacity(0.25),
                          AppColors.primary.withOpacity(0.1),
                        ])
                      : null,
                  borderRadius: BorderRadius.circular(14),
                  border: selected
                      ? Border.all(
                          color: AppColors.primary.withOpacity(0.4),
                          width: 1,
                        )
                      : null,
                ),
                child: Icon(
                  icon,
                  color: selected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  size: 22,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
