import 'dart:ui';

import 'package:flutter/material.dart';

enum Flavor {
  apple,
  banana,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.apple:
        return 'Flutter Test App';
      case Flavor.banana:
        return 'Banana App';
      default:
        return 'title';
    }
  }

  static MaterialColor get themeColor {
    switch (appFlavor) {
      case Flavor.apple:
        return Colors.yellow;
      case Flavor.banana:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

}
