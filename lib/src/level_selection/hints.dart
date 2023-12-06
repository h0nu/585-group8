import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../style/palette.dart';
import '../style/responsive_screen.dart';

class HintsScreen extends StatelessWidget {
  const HintsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: const [
            Padding(
              padding: EdgeInsets.all(16),
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
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hint 1: Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16), // Add a break/space here
                        Text(
                          'Hint 2:: Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16), // Add a break/space here
                        Text(
                          'Hint 3: Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                          style: TextStyle(fontSize: 18),
                        ),
                        // Add more "Lorem Ipsum" content as needed
                      ],
                    ),
                  ),
                ),
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
              onPressed: () {
                GoRouter.of(context).push('/hints');
              },
              child: const Text('Hints'),
            ),
            TextButton(
              onPressed: () => GoRouter.of(context).push('/encyclopedia'),
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
