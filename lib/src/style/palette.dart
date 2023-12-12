// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A palette of colors to be used in the game.
///
/// The reason we're not going with something like Material Design's
/// `Theme` is simply that this is simpler to work with and yet gives
/// us everything we need for a game.
///
/// Games generally have more radical color palettes than apps. For example,
/// every level of a game can have radically different colors.
/// At the same time, games rarely support dark mode.
///
/// Colors taken from this fun palette:
/// https://lospec.com/palette-list/crayola84
///
/// Colors here are implemented as getters so that hot reloading works.
/// In practice, we could just as easily implement the colors
/// as `static const`. But this way the palette is more malleable:
/// we could allow players to customize colors, for example,
/// or even get the colors from the network.
class Palette {
  Color get pen => const Color(0xff1d75fb);
  Color get darkPen => const Color(0xFF0050bc);
  Color get redPen => const Color(0xFFd10841);
  Color get inkFullOpacity => const Color(0xff352b42);
  Color get ink => const Color(0xee352b42);
  Color get backgroundMain => Color.fromRGBO(255,232,215,1);
  Color get backgroundLevelSelection => Color.fromRGBO(255,232,215,1);
  Color get backgroundPlaySession => const Color(0xffffebb5);
  Color get background4 => const Color(0xffffd7ff);
  Color get backgroundSettings => Color.fromRGBO(255,232,215,1);
  Color get trueWhite => const Color(0xffffffff);
  Color get backgroundAlchemy => Color.fromRGBO(255,232,215,1); // Play screen color
  Color get backgroundHints =>  Colors.white; //Hints page color
  Color get backgroundMenu => Color.fromRGBO(255,232,215,1); //Menu color
  Color get backgroundEncyclopedia => Colors.white; //Encyclopedia page color
  Color get backgroundPlayButton => Color.fromRGBO(7,204,222,.87);
  Color get cardBackgroundColor => Color.fromRGBO(7,204,222,.87);
}
