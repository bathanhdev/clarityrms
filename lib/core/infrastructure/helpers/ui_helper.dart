import 'package:clarityrms/core/constants/app_durations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Lớp chứa các hàm tiện ích tĩnh (static utility methods)
/// liên quan đến UI và Context (MediaQuery, FocusScope).
class UIHelper {
  /// Lấy kích thước màn hình hiện tại.
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// Ẩn bàn phím ảo (Unfocusing the current FocusScope).
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static void showAppSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
    Color? backgroundColor,
  }) {
    final messengerState = ScaffoldMessenger.maybeOf(context);
    if (messengerState == null) {
      return;
    }
    messengerState.hideCurrentSnackBar();
    messengerState.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? AppDurations.snackBarDuration,
        backgroundColor: backgroundColor,
      ),
    );
  }

  static Future<void> setPreferredOrientations(
    List<DeviceOrientation> orientations,
  ) {
    return SystemChrome.setPreferredOrientations(orientations);
  }

  /// set status bar color & navigation bar color
  static void setSystemUIOverlayStyle(
    SystemUiOverlayStyle systemUiOverlayStyle,
  ) {
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  static Offset? getWidgetPosition(GlobalKey globalKey) {
    return (globalKey.currentContext?.findRenderObject() as RenderBox?)?.let(
      (it) => it.localToGlobal(Offset.zero),
    );
  }

  static double? getWidgetWidth(GlobalKey globalKey) {
    return (globalKey.currentContext?.findRenderObject() as RenderBox?)?.let(
      (it) => it.size.width,
    );
  }

  static double? getWidgetHeight(GlobalKey globalKey) {
    return (globalKey.currentContext?.findRenderObject() as RenderBox?)?.let(
      (it) => it.size.height,
    );
  }
}

T run<T>(T Function() block) {
  return block();
}

extension ScopeFunctionsForObject<T extends Object> on T {
  R let<R>(R Function(T it) block) => block(this);

  T also(void Function(T it) block) {
    block(this);

    return this;
  }
}
