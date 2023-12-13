import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'src/app_lifecycle/app_lifecycle.dart';
import 'src/main_menu/main_menu_screen.dart';
import 'src/audio/audio_controller.dart';

import 'src/player_progress/persistence/local_storage_player_progress_persistence.dart';
import 'src/player_progress/persistence/player_progress_persistence.dart';
import 'src/player_progress/player_progress.dart';
import 'src/settings/persistence/local_storage_settings_persistence.dart';
import 'src/settings/persistence/settings_persistence.dart';
import 'src/settings/settings.dart';
import 'src/settings/settings_screen.dart';
import 'src/style/palette.dart';
import 'src/play_session/Alchemy_play_session.dart';
import 'src/level_selection/hints.dart';
import 'src/level_selection/encyclopedia.dart';

Future<void> main() async {
  // Subscribe to log messages.
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });

  WidgetsFlutterBinding.ensureInitialized();

  _log.info('Going full screen');
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HintUnlockProvider(),
        ),
        // ... other providers ...
      ],
      child: MyApp(
        settingsPersistence: LocalStorageSettingsPersistence(),
        playerProgressPersistence: LocalStoragePlayerProgressPersistence(),
      ),
    ),
  );
}

Logger _log = Logger('main.dart');

class MyApp extends StatelessWidget {
  static final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const MainMenuScreen(key: Key('main menu')),
      ),
      GoRoute(
        path: '/settings', // Ensure the path starts with "/"
        builder: (context, state) => const SettingsScreen(key: Key('settings')),
      ),
      GoRoute(
        path: '/play', // Ensure the path starts with "/"
        builder: (context, state) => AlchemyGame(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) =>
            const SettingsScreen(key: Key('settings')),
      ),
      GoRoute(
        path: '/encyclopedia',
        builder: (context, state) =>
            const EncyclopediaScreen(key: Key('encyclopedia')),
      ),
      GoRoute(
        path: '/hints',
        builder: (context, state) =>
            const HintsScreen(key: Key('hints')),
      ),
    ], 
  );

  final PlayerProgressPersistence playerProgressPersistence;
  final SettingsPersistence settingsPersistence;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  MyApp({
    required this.playerProgressPersistence,
    required this.settingsPersistence,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) {
              var progress = PlayerProgress(playerProgressPersistence);
              progress.getLatestFromStore();
              return progress;
            },
          ),
          Provider<SettingsController>(
            lazy: false,
            create: (context) => SettingsController(
              persistence: settingsPersistence,
            )..loadStateFromPersistence(),
          ),
          ProxyProvider2<SettingsController, ValueNotifier<AppLifecycleState>,
              AudioController>(
            // Ensures that the AudioController is created on startup,
            // and not "only when it's needed", as is default behavior.
            // This way, music starts immediately.
            lazy: false,
            create: (context) => AudioController()..initialize(),
            update: (context, settings, lifecycleNotifier, audio) {
              if (audio == null) throw ArgumentError.notNull();
              audio.attachSettings(settings);
              audio.attachLifecycleNotifier(lifecycleNotifier);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
          ),
          Provider(
            create: (context) => Palette(),
          ),
        ],
        child: Builder(builder: (context) {
          final palette = context.watch<Palette>();

          return MaterialApp.router(
            title: 'Flutter Demo',
            theme: ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                seedColor: palette.darkPen,
                background: palette.backgroundMain,
              ),
              textTheme: TextTheme(
                bodyMedium: TextStyle(
                  color: palette.ink,
                ),
              ),
              useMaterial3: true,
            ),
            routeInformationProvider: _router.routeInformationProvider,
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
            scaffoldMessengerKey: scaffoldMessengerKey,
          );
        }),
      ),
    );
  }
}
