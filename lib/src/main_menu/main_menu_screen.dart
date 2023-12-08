import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../games_services/games_services.dart';
import '../settings/settings.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key});

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

    // Define a button style for the 'Settings' button
    final ButtonStyle settingsButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(114, 0, 0, 0), // Change the background color for Settings
      foregroundColor: Colors.white, // Change the text color
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Adjust the padding
    );

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        mainAreaProminence: 0.45,
        squarishMainArea: Center(
          child: Transform.rotate(
            angle: -0.1,
            child: const Text(
              'Little Alchemy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 55,
                height: 1,
              ),
            ),
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Apply the 'Play' button style
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('/play');
              },
              style: playButtonStyle,
              child: const Text('Play'),
            ),
            _gap,
            // Apply the 'Settings' button style
            FilledButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              style: settingsButtonStyle,
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 10);
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
