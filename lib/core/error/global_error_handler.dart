import 'package:flutter/foundation.dart';

import 'package:clarityrms/config/app_config.dart';
import 'package:clarityrms/core/utils/log_util.dart';

void globalErrorHandler(Object error, StackTrace? stackTrace) {
  // Lấy AppConfig Instance. Bọc trong try-catch phòng trường hợp lỗi xảy ra
  // quá sớm (trước khi AppConfig được initialize)
  try {
    final appConfig = AppConfig.getInstance();

    // Ghi log lỗi vào console
    Log.e(
      'Lỗi không được xử lý (Unhandled Exception):',
      error: error,
      stackTrace: stackTrace,
      name: 'GLOBAL_ERROR_HANDLER',
    );

    // Báo cáo lỗi cho dịch vụ bên ngoài (Crashlytics/Sentry)
    if (appConfig.isProduction) {
      // Logic báo cáo lỗi cho các dịch vụ monitoring
      // Ví dụ: FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
      Log.d('Đang gửi báo cáo lỗi Fatal lên dịch vụ giám sát...');
    } else {
      if (kDebugMode) {
        Log.d('Lỗi đã được ghi lại. Không gửi báo cáo từ môi trường DEV.');
      }
    }
  } catch (e, st) {
    // Xử lý lỗi xảy ra trước khi AppConfig được initialize (Rất hiếm)
    Log.e(
      'Lỗi Global Unhandled (Rất Sớm): $error',
      error: e,
      stackTrace: st,
      name: 'GLOBAL_ERROR_HANDLER',
    );
  }
}
