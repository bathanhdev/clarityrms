import 'package:flutter/foundation.dart';

/// Tiện ích ghi log nhẹ cho môi trường debug.
/// Ghi chú: có thể mở rộng cấu hình mức in tối thiểu và màu sắc khi in xuống terminal.
class Log {
  Log._();

  static String get _time =>
      DateTime.now().toIso8601String().split('T').last.substring(0, 12);

  /// Mức log tối thiểu để in. Mặc định là `debug` trong debug builds.
  static LogLevel minLevel = LogLevel.debug;

  /// Cập nhật mức log tối thiểu tại runtime.
  static void setLevel(LogLevel level) => minLevel = level;

  static bool _shouldPrint(LogLevel level) {
    if (!kDebugMode) return false;
    return level.index >= minLevel.index;
  }

  static String _colorFor(LogLevel level) {
    if (kIsWeb) return ''; // no ANSI in web console
    switch (level) {
      case LogLevel.debug:
        return '\x1B[36m'; // cyan
      case LogLevel.info:
        return '\x1B[32m'; // green
      case LogLevel.warning:
        return '\x1B[33m'; // yellow
      case LogLevel.error:
        return '\x1B[31m'; // red
    }
  }

  static const String _ansiReset = '\x1B[0m';

  static void _print(LogLevel level, String name, dynamic message) {
    if (!_shouldPrint(level)) return;
    final prefix = '[$_time] [${level.name.toUpperCase()}] [$name]:';
    final color = _colorFor(level);
    final icon = _iconFor(level);
    final output = '$icon $prefix $message';
    if (color.isNotEmpty) {
      debugPrint('$color$output$_ansiReset');
    } else {
      debugPrint(output);
    }
  }

  /// Ghi log mức debug
  static void d(dynamic message, {String name = 'APP'}) {
    _print(LogLevel.debug, name, message);
  }

  /// Ghi log mức info
  static void i(dynamic message, {String name = 'APP'}) {
    _print(LogLevel.info, name, message);
  }

  /// Ghi log mức warning
  static void w(dynamic message, {String name = 'WARNING'}) {
    _print(LogLevel.warning, name, message);
  }

  /// Ghi log mức error kèm tuỳ chọn error/stack
  static void e(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
    String name = 'ERROR',
  }) {
    _print(LogLevel.error, name, message);
    if (kDebugMode) {
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('Stack: $stackTrace');
    }
  }
}

enum LogLevel { debug, info, warning, error }

String _iconFor(LogLevel level) {
  switch (level) {
    case LogLevel.debug:
      return '🔍';
    case LogLevel.info:
      return 'ℹ️';
    case LogLevel.warning:
      return '⚠️';
    case LogLevel.error:
      return '❌';
  }
}
