// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/sounds.dart';
import '../audio/audio_controller.dart';
import '../style/palette.dart';
import 'custom_name_dialog.dart';
import 'settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key});

  static const _gapW = SizedBox(width: 15);
  static const _gapH = SizedBox(height: 60);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
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
              'Settings',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontFamily: 'Permanent Marker',
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: settings.musicOn,
                    builder: (context, musicOn, child) => _SettingsButton(
                      title: 'Music',
                      icon: Icon(musicOn ? Icons.music_note : Icons.music_off),
                      onPressed: () => settings.toggleMusicOn(),
                    ),
                  ),
                  SizedBox(height: 16),
                  ValueListenableBuilder<bool>(
                    valueListenable: settings.soundsOn,
                    builder: (context, soundsOn, child) => _SettingsButton(
                      title: 'Sound',
                      icon: Icon(soundsOn ? Icons.graphic_eq : Icons.volume_off),
                      onPressed: () => settings.toggleSoundsOn(),
                    ),
                  ),
                ],
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

class _NameChangeLine extends StatelessWidget {
  final String title;

  const _NameChangeLine(this.title);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return ElevatedButton(
      onPressed: () => showCustomNameDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 30,
                )),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: settings.playerName,
              builder: (context, name, child) => Text(
                '‘$name’',
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onPressed;

  const _SettingsButton({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        backgroundColor: palette.backgroundPlayButton, // Change the background color
        foregroundColor: Colors.white, // Change the text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Adjust the button border radius
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon,
          Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(width: 32), // Add space between icon and text
        ],
      ),
    );
  }
}
