import 'package:flutter/material.dart';
import '../presentation/customization/rs_colors.dart';

enum Flavor {
  dev,
  prod,
}

mixin F {
  static Flavor? appFlavor;

  static Color get color {
    switch (appFlavor) {
      case Flavor.dev:
        return RSColors.primary;
      case Flavor.prod:
        return RSColors.primary;
      default:
        return Colors.red;
    }
  }

  static String get banner {
    switch (appFlavor) {
      case Flavor.dev:
        return 'DEV';
      case Flavor.prod:
        return 'PROD';
      default:
        return 'UNKNOWN';
    }
  }

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Studio Lab Dev';
      case Flavor.prod:
        return 'Studio Lab';
      default:
        return 'title';
    }
  }
}
