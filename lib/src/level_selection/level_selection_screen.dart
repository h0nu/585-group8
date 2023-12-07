import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Select level',
                  style:
                      TextStyle(fontFamily: 'Permanent Marker', fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    enabled: playerProgress.highestLevelReached >=
                        0, // Adjust the level condition
                    onTap: () {
                      // Navigate to Little Alchemy
                      GoRouter.of(context).push('/play/session/alchemy');
                    },
                    leading: Text('1'), // Adjust the level number
                    title: Text('Little Alchemy'), // Adjust the level title
                  ),
                  // You can add more levels or modify as needed
                ],
              ),
            ),
          ],
        ),
        rectangularMenuArea: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/play');
              },
              child: const Text('Home'),
            ),
            TextButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              child: const Text('Hints'),
            ),
            TextButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              child: const Text('Encyclopedia'),
            ),
            TextButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
