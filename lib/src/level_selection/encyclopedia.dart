import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';

import '../style/palette.dart';

class EncyclopediaScreen extends StatelessWidget {
  const EncyclopediaScreen({Key? key}) : super(key: key);

  // Helper method to create a card for each element
  Widget _buildElementCard(String title, String description, String category, String combination) {
    final Color cardBackgroundColor = Color.fromRGBO(255, 232, 215, 1.0); // Adjust the alpha value as needed
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Categories: $category',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Combinations: $combination',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

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
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
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
                    children: [
                      _buildElementCard(
                        'Water',
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                        'Liquid, Transparent',
                        'Water + Fire = Steam',
                      ),
                      _buildElementCard(
                        'Earth',
                        'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                        'Solid, Brown',
                        'Earth + Water = Mud',
                      ),
                      _buildElementCard(
                        'Fire',
                        'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                        'Hot, Red',
                        'Fire + Air = Smoke',
                      ),
                      // Add more cards as needed
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
