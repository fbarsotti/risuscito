import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Class that contains all the main appc olors
class RSColors {
  RSColors._();

  static Color get primary => const Color(0xff964946); //0xff964946
  static Color get extraLightText => const Color(0xffD8D8D8);
  static Color get lightText => const Color(0xffACACAC);
  static Color get facebookColor => const Color(0xff3A569B);
  static Color get errorColor => const Color(0xffE8431F);

  static Color get bgColor => CupertinoDynamicColor.withBrightness(
        color: Color(0xffF0F3F4), // Color(0xffF0F3F4)
        darkColor: CupertinoColors.black,
      );
  // CupertinoColors.extraLightBackgroundGray
  static Color get bgLightColor => Color(0xffF0F3F4);
  static Color get bgDarkColor => CupertinoColors.black;

  static Color get tagInactive => Color(0xffBBBBBB);
  static Color get tagBg => Color(0xff515151);

  static Color get cardColorLight => CupertinoColors.white;
  static Color get cardColorDark => CupertinoColors.darkBackgroundGray;

  static Color get dividerLight => Color.fromARGB(255, 184, 184, 184);
  static Color get dividerDark => Color.fromARGB(255, 76, 76, 76);

  static Color get text => const Color(0xff000000);
  static Color get darkText => const Color(0xffffffff);

  static Color get whiteSongsColor => const Color(0xffffffff);
  static Color get blueSongsColor => Color(0xff7FB3D5);
  static Color get greenSongsColor => const Color(0xff7DCEA0);

  static Color get greyBlue => const Color(0xffF5F4F8);
  static Color get lightPurple => const Color(0xff97AFF3);
  static Color get darkYellow => const Color(0xffFEC106);
  static Color get lightOrange => const Color(0xffF28E1A);
  static Color get darkGrey => const Color(0xff484A54);

  static Color get white => Colors.white;
  static Color get black => Colors.black;
  static Color get blue => Colors.blue;
  static Color get orange => Colors.orange;
  static Color get red => Colors.red;
  static Color get purple => Colors.purpleAccent;
  static Color get blueGrey => Colors.blueGrey;

  static MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  static int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  static Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  static int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  static Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);
}
