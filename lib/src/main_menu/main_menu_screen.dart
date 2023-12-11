import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../games_services/games_services.dart';
import '../settings/settings.dart';
import '../style/palette.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key});
  static const _gap = SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final gamesServicesController = context.watch<GamesServicesController?>();
    final settingsController = context.watch<SettingsController>();

    // Define a button style for the 'Play' button
    final ButtonStyle playButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: palette.backgroundPlayButton, // Change the background color
      foregroundColor: Colors.white, // Change the text color
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Adjust the padding
    );

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
        children: [
          Center(
            child: Transform.rotate(
              angle: -0.1,
              child: const Text(
                'Little Alchemy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 45,
                  height: 1,
                ),
              ),
            ),
          ),
          SizedBox(height: 60), // Add empty space between title and button
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go('/play');
            },
            style: playButtonStyle,
            child: const Text('PLAY'),
          ),
          _gap,
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go('/settings');
            },
            style: playButtonStyle,
            child: const Text('SETTINGS'),
          ),
        ],
      ),
    );
  }
}

// Custom widget for a filled button
class FilledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ButtonStyle? style;

  const FilledButton({
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );
  }
}
