import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../style/palette.dart';

class HintsScreen extends StatelessWidget {
  const HintsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundHints,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Hints',
                  style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 30),
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
                          'Hint 1: Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Hint 2:: Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Hint 3: Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                          style: TextStyle(fontSize: 18),
                        ),
                        // Add more content as needed
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
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
                        GoRouter.of(context).go('/play');
                      },
                      icon: Icon(Icons.home),
                    ),
                    IconButton(
                      onPressed: () {
                        GoRouter.of(context).push('/hints');
                      },
                      icon: Icon(Icons.lightbulb),
                    ),
                    IconButton(
                      onPressed: () => GoRouter.of(context).push('/encyclopedia'),
                      icon: Icon(Icons.menu_book),
                    ),
                    IconButton(
                      onPressed: () => GoRouter.of(context).push('/settings'),
                      icon: Icon(Icons.settings),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
