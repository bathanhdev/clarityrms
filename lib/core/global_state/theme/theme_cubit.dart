import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clarityrms/core/constants/shared_prefs_constants.dart';

/// Cubit quản lý ThemeMode toàn cục và lưu lựa chọn vào SharedPreferences.
class ThemeCubit extends Cubit<ThemeMode> {
  static const _prefKey = SharedPrefsConstants.themeModeKey;
  final SharedPreferences prefs;

  ThemeCubit({required this.prefs}) : super(_readInitial(prefs));

  static ThemeMode _readInitial(SharedPreferences prefs) {
    final idx = prefs.getInt(_prefKey);
    if (idx == null) return ThemeMode.system;
    if (idx < 0 || idx >= ThemeMode.values.length) return ThemeMode.system;
    return ThemeMode.values[idx];
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await prefs.setInt(_prefKey, mode.index);
    emit(mode);
  }
}
