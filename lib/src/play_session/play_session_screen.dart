// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import '../game_internals/level_state.dart';
import '../games_services/games_services.dart';
import '../games_services/score.dart';
import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import '../style/confetti.dart';
import '../style/palette.dart';
import '../play_session/Alchemy_play_session.dart';

class PlaySessionScreen extends StatefulWidget {
  const PlaySessionScreen({Key? key}) : super(key: key);

  @override
  _PlaySessionScreenState createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  late DateTime _startOfPlay;

  bool _duringCelebration = false; // Define _duringCelebration here

  @override
  Widget build(BuildContext context) {
    // Remove the condition checking for level 4
    final palette = context.watch<Palette>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LevelState(
            // Set a dummy goal, as it won't be used for AlchemyGame
            goal: 0,
            onWin: _playerWon,
          ),
        ),
      ],
      child: IgnorePointer(
        ignoring: _duringCelebration,
        child: Scaffold(
          backgroundColor: palette.backgroundPlaySession,
          body: Stack(
            children: [
              Center(
                // This is the entirety of the "game".
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkResponse(
                        onTap: () => GoRouter.of(context).push('/settings'),
                        child: Image.asset(
                          'assets/images/settings.png',
                          semanticLabel: 'Settings',
                        ),
                      ),
                    ),
                    const Spacer(),
                    // ... existing code for the slider
                  ],
                ),
              ),
              SizedBox.expand(
                child: Visibility(
                  visible: _duringCelebration,
                  child: IgnorePointer(
                    child: Confetti(
                      isStopped: !_duringCelebration,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _startOfPlay = DateTime.now();
  }

  Future<void> _playerWon() async {
    _log.info('Player won');

    // Handle the completion of AlchemyGame level
    // You can add specific logic for AlchemyGame completion here

    final score = Score(
      0, // Set a dummy level number, as it won't be used for AlchemyGame
      0, // Set a dummy difficulty, as it won't be used for AlchemyGame
      DateTime.now().difference(_startOfPlay),
    );

    final playerProgress = context.read<PlayerProgress>();
    playerProgress.setLevelReached(0); // Set a dummy level number

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    final gamesServicesController = context.read<GamesServicesController?>();
    if (gamesServicesController != null) {
      // Award achievement.
      // Note: You can customize this part based on your AlchemyGame completion logic.
      // This is just a placeholder code.
      await gamesServicesController.awardAchievement(
        android: 'your_android_achievement_id',
        iOS: 'your_ios_achievement_id',
      );

      // Send score to leaderboard.
      await gamesServicesController.submitLeaderboardScore(score);
    }

    // Give the player some time to see the celebration animation.
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    // Directly go to the AlchemyGame screen
    GoRouter.of(context).go(
      '/play/alchemy',
    );
  }
}
