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
      body: IndexedStack(
        index: tab,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.cellBorder)),
        ),
        child: BottomNavigationBar(
          currentIndex: tab,
          onTap: (i) => ref.read(_tabProvider.notifier).state = i,
          items: const [
            BottomNavigationBarItem(
              icon: Text('⛏', style: TextStyle(fontSize: 22)),
              label: 'Mine',
            ),
            BottomNavigationBarItem(
              icon: Text('🏪', style: TextStyle(fontSize: 22)),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Text('👤', style: TextStyle(fontSize: 22)),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
