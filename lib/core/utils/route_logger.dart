import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clarityrms/core/utils/log_util.dart';

/// Ghi log vị trí hiện tại của `GoRouter` và stack của `Navigator` (nỗ lực tốt nhất).
/// Chỉ ghi log trong chế độ debug.
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
      'Lỗi khi ghi log routes: $e',
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

      // Đọc vị trí GoRouter và lên lịch kiểm tra sau khung (post-frame).
      try {
        final ctx =
            route?.navigator?.context ?? previousRoute?.navigator?.context;
        if (ctx != null) {
          final goRouter = GoRouter.maybeOf(ctx);
          if (goRouter != null) {
            try {
              final loc = (goRouter as dynamic).location;
              Log.d('GoRouter.location: $loc', name: 'ROUTE_LOG');
            } catch (_) {
              // ignore
            }
          }

          // Lên lịch post-frame để lấy trạng thái navigator đã cập nhật.
          try {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              try {
                final pagesList = Navigator.of(ctx).widget.pages;
                if (pagesList.isNotEmpty) {
                  final names = pagesList
                      .map((p) => p.name ?? p.runtimeType.toString())
                      .toList();
                  Log.d(
                    'STACK(after frame): ${names.join('→')}',
                    name: 'ROUTE_LOG',
                  );
                }
              } catch (_) {
                // bỏ qua nếu không truy xuất được
              }

              try {
                final goRouter2 = GoRouter.maybeOf(ctx);
                if (goRouter2 != null) {
                  final loc2 = (goRouter2 as dynamic).location;
                  Log.d(
                    'GoRouter.location(after frame): $loc2',
                    name: 'ROUTE_LOG',
                  );
                }
              } catch (_) {
                // bỏ qua khi không lấy được location
              }
            });
          } catch (_) {
            // ignore
          }
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
