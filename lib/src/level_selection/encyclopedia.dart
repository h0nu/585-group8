import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';

import '../style/palette.dart';

class EncyclopediaScreen extends StatelessWidget {
  const EncyclopediaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.center,
            color: palette.backgroundSettings,
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16), // Adjust top padding
            child: Text(
              'Encyclopedia',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontFamily: 'Permanent Marker',
              ),
            ),
          ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Water: Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Earth: Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Fire: Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                          style: TextStyle(fontSize: 18),
                        ),
                        // Add more content as needed
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: palette.backgroundMenu,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        audioController.playSfx(SfxType.buttonTap);
                        GoRouter.of(context).go('/play');
                      },
                      icon: Icon(Icons.home),
                    ),
                    IconButton(
                      onPressed: () {
                        audioController.playSfx(SfxType.buttonTap);
                        GoRouter.of(context).push('/hints');
                      },
                      icon: Icon(Icons.lightbulb),
                    ),
                    IconButton(
                      onPressed: () {
                        audioController.playSfx(SfxType.buttonTap);
                        GoRouter.of(context).push('/encyclopedia');
                      },
                      icon: Icon(Icons.menu_book),
                    ),
                    IconButton(
                      onPressed: () {
                        audioController.playSfx(SfxType.buttonTap);
                        GoRouter.of(context).push('/settings');
                      },
                      icon: Icon(Icons.settings),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ],
        ),
      );
  }
}
