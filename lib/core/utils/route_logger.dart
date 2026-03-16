import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// go_router import intentionally omitted for concise logging
import 'package:clarityrms/core/utils/log_util.dart';

/// Attempts to log the current GoRouter location and the Navigator pages stack.
/// Best-effort and only logs in debug mode.
void logCurrentRoutes(BuildContext context) {
  if (!kDebugMode) return;

  try {
    final pages = <String>[];
    try {
      final pagesList = Navigator.of(context).widget.pages;
      for (final p in pagesList) {
        pages.add(p.name ?? p.runtimeType.toString());
      }
    } catch (_) {
      // ignore
    }

    final top = pages.isNotEmpty ? pages.last : '-';
    final stack = pages.isNotEmpty ? pages.join('→') : '-';
    Log.d('ROUTE: $top | STACK: $stack', name: 'ROUTE_LOG');
  } catch (e, st) {
    Log.e(
      'Failed to log routes: $e',
      error: e,
      stackTrace: st,
      name: 'ROUTE_LOG',
    );
  }
}

/// NavigatorObserver that logs route changes (push/pop/replace/remove).
class RouteLoggingObserver extends NavigatorObserver {
  void _logRoute(String event, Route? route, Route? previousRoute) {
    try {
      final routeName = route?.settings.name ?? route?.runtimeType.toString();
      Log.d('$event: $routeName', name: 'ROUTE_LOG');

      // Also attempt to log a concise stack summary (bottom->top) when available
      try {
        final pagesList = route?.navigator?.widget.pages;
        if (pagesList != null && pagesList.isNotEmpty) {
          final names = pagesList
              .map((p) => p.name ?? p.runtimeType.toString())
              .toList();
          Log.d('STACK: ${names.join('→')}', name: 'ROUTE_LOG');
        }
      } catch (_) {
        // ignore
      }
    } catch (e, st) {
      Log.e(
        'Error logging route event: $e',
        error: e,
        stackTrace: st,
        name: 'ROUTE_LOG',
      );
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _logRoute('didPush', route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logRoute('didReplace', newRoute, oldRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _logRoute('didPop', route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _logRoute('didRemove', route, previousRoute);
  }
}
