import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/base_data.dart';
import 'models/player_data.dart';
import 'providers/base_provider.dart';
import 'providers/player_provider.dart';
import 'screens/main_shell.dart';
import 'screens/nickname_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.surface,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  await Hive.initFlutter();
  Hive.registerAdapter(PlayerDataAdapter());
  Hive.registerAdapter(BaseDataAdapter());
  await Hive.openBox<PlayerData>(playerBoxName);
  await Hive.openBox<BaseData>(baseBoxName);

  runApp(const ProviderScope(child: MinerApp()));
}

class MinerApp extends ConsumerWidget {
  const MinerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);

    return MaterialApp(
      title: 'Шахтёр',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: player.nickname.isEmpty
          ? const NicknameScreen()
          : const MainShell(),
    );
  }
}
