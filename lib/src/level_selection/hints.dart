import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';

import '../style/palette.dart';

class HintUnlockProvider extends ChangeNotifier {
  Set<String> unlockedHints = {};

  void unlockHint(String hintTitle) {
    unlockedHints.add(hintTitle);
    notifyListeners();
  }

  bool isHintUnlocked(String hintTitle) {
    return unlockedHints.contains(hintTitle);
  }
}

class HintsScreen extends StatelessWidget {
  const HintsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final audioController = context.watch<AudioController>();
    final hintUnlockProvider = context.watch<HintUnlockProvider>();

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
              'Hints',
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
                      _HintCard(
                        title: '#1',
                        content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                        isUnlocked: hintUnlockProvider.isHintUnlocked('Hint 1'),
                        unlockCallback: () => hintUnlockProvider.unlockHint('Hint 1'),
                      ),
                      SizedBox(height: 16),
                      _HintCard(
                        title: '#2',
                        content: 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                        isUnlocked: hintUnlockProvider.isHintUnlocked('Hint 2'),
                        unlockCallback: () => hintUnlockProvider.unlockHint('Hint 2'),
                      ),
                      SizedBox(height: 16),
                      _HintCard(
                        title: '#3',
                        content: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                        isUnlocked: hintUnlockProvider.isHintUnlocked('Hint 3'),
                        unlockCallback: () => hintUnlockProvider.unlockHint('Hint 3'),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
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

class _HintCard extends StatefulWidget {
  final String title;
  final String content;
  final bool isUnlocked;
  final VoidCallback unlockCallback;

  const _HintCard({
    required this.title,
    required this.content,
    required this.isUnlocked,
    required this.unlockCallback,
    Key? key,
  }) : super(key: key);

  @override
  __HintCardState createState() => __HintCardState();
}

class __HintCardState extends State<_HintCard> {
  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    Color? cardColor = widget.isUnlocked ? palette.cardBackgroundColor : Colors.grey[400];

    return GestureDetector(
      onTap: () {
        if (widget.isUnlocked) {
          _showHintDialog(context);
        } else {
          _showUnlockConfirmationDialog(context);
        }
      },
      child: Container(
        width: double.infinity,
        child: Card(
          elevation: 2,
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column for the title on the left side
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
                SizedBox(width: 16), // Add some space between the title and content
                // Column for the content on the right side
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.isUnlocked)
                        Text(
                          widget.content,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                      else
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lock, size: 40, color: Colors.white),
                            SizedBox(height: 4),
                            Text(
                              'Locked',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUnlockConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unlock Hint?'),
          content: Text('Are you sure you want to unlock this hint?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Unlock the hint using the callback
                widget.unlockCallback();
                Navigator.of(context).pop();
                // Optionally, you can show the unlocked hint immediately
                _showHintDialog(context);
              },
              child: Text('Unlock'),
            ),
          ],
        );
      },
    );
  }

  void _showHintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.title),
          content: Text(widget.content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}