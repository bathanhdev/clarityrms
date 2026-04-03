import 'package:clarityrms/core/global_state/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  setUpAll(() {});

  test('initial state reads from prefs (system when missing)', () {
    final prefs = MockSharedPreferences();
    when(() => prefs.getInt(any<String>())).thenReturn(null);

    final cubit = ThemeCubit(prefs: prefs);
    expect(cubit.state, ThemeMode.system);
  });

  test('setThemeMode writes to prefs and emits new mode', () async {
    final prefs = MockSharedPreferences();
    when(() => prefs.getInt(any<String>())).thenReturn(0);
    when(
      () => prefs.setInt(any<String>(), any<int>()),
    ).thenAnswer((_) async => true);

    final cubit = ThemeCubit(prefs: prefs);

    expectLater(cubit.stream, emitsInOrder([ThemeMode.dark]));

    await cubit.setThemeMode(ThemeMode.dark);

    verify(() => prefs.setInt(any<String>(), ThemeMode.dark.index)).called(1);
  });
}
