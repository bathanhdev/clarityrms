import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/core/global_state/network/network_cubit.dart';
import 'package:clarityrms/core/infrastructure/helpers/ui_helper.dart';
import 'package:clarityrms/core/router/app_router.dart';
import 'package:clarityrms/core/utils/screen_util.dart';
import 'package:clarityrms/shared/styles/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clarityrms/core/di/locator.dart';

/// Widget cấp cao nhất của ứng dụng.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy cấu hình GoRouter từ Service Locator
    final goRouterConfig = sl<AppRouter>().config;
    ScreenUtil.init(context);

    return MultiBlocProvider(
      providers: [
        // 1. Cung cấp NetworkCubit
        BlocProvider<NetworkCubit>(
          create: (_) => sl<NetworkCubit>(),
          lazy: false,
        ),
        // 2. Cung cấp AuthCubit
        BlocProvider<AuthCubit>(
          create: (context) => sl<AuthCubit>()..appStarted(),
          lazy: false,
        ),
      ],
      // SỬ DỤNG MaterialApp.router
      child: GestureDetector(
        onTap: () => UIHelper.hideKeyboard(context),
        child: MaterialApp.router(
          title: 'ClarityRMS',
          debugShowMaterialGrid: false,
          debugShowCheckedModeBanner: false,

          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,

          routerConfig: goRouterConfig,
        ),
      ),
    );
  }
}
