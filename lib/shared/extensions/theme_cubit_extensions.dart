import 'package:flutter/material.dart';

extension ThemeModeExt on ThemeMode {
  Brightness getRealBrightness(BuildContext context) {
    if (this == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context);
    }
    return this == ThemeMode.dark ? Brightness.dark : Brightness.light;
  }
}
