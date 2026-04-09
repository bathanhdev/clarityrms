import 'dart:async';
import 'package:clarityrms/core/error/global_error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:clarityrms/app/my_app.dart';
import 'package:clarityrms/core/initializer/app_initializer.dart';
import 'package:clarityrms/config/app_config.dart';
import 'package:clarityrms/firebase_options.dart';

void runGlobalSetup() {
  runZonedGuarded(_runAppEntry, globalErrorHandler);
}

Future<void> _runAppEntry() async {
  // Đảm bảo Flutter Framework đã được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Bắt lỗi của Flutter Framework
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kReleaseMode) {
      globalErrorHandler(details.exception, details.stack);
    } else {
      FlutterError.dumpErrorToConsole(details);
    }
  };

  // 1. XÁC ĐỊNH MÔI TRƯỜNG:
  final Environment environment = kReleaseMode
      ? Environment.prod
      : Environment.dev;

  // 2. KHỞI TẠO APP CONFIG:
  AppConfig.initialize(environment: environment);

  // 3. KHỞI TẠO APP INITIALIZER
  final initializer = AppInitializer();
  await initializer.init();

  // 4. Tải tài nguyên ban đầu (Tùy chọn)
  // final initialResource = await _loadInitialResource();

  runApp(const MyApp(/* initialResource: initialResource */));
}
