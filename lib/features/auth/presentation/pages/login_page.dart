// AppDimensions used by extracted LoginButton; kept out of this page.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/core/global_state/auth/auth_state.dart';
import 'package:clarityrms/core/global_state/network/network_cubit.dart';
import 'package:clarityrms/core/infrastructure/helpers/ui_helper.dart';
// Loading indicator moved into extracted LoginButton widget.
import 'package:clarityrms/features/auth/presentation/widgets/login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _performLogin() {
    UIHelper.hideKeyboard(context);
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();
      context.read<AuthCubit>().login(username, password);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          UIHelper.showAppSnackBar(
            context,
            state.message,
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingAllLg,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Chào mừng trở lại',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  AppSpacing
                      .verticalSpaceLg, // Dùng Vertical Space chuẩn của bạn
                  // 1. INPUT TÊN NGƯỜI DÙNG
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên người dùng',
                      hintText: 'Nhập tên người dùng',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Vui lòng nhập tên người dùng'
                        : null,
                  ),
                  AppSpacing.verticalSpaceMd,

                  // 2. INPUT MẬT KHẨU
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu',
                      hintText: 'Nhập mật khẩu',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Vui lòng nhập mật khẩu'
                        : null,
                  ),
                  AppSpacing.verticalSpaceLg,

                  // 3. NÚT ĐĂNG NHẬP (extracted)
                  BlocBuilder<AuthCubit, AuthState>(
                    buildWhen: (previous, current) =>
                        previous.runtimeType != current.runtimeType,
                    builder: (context, state) {
                      final bool isLoading = state is AuthLoading;
                      return LoginButton(
                        isLoading: isLoading,
                        onPressed: _performLogin,
                      );
                    },
                  ),

                  AppSpacing.verticalSpaceMd,

                  // 4. HIỂN THỊ TRẠNG THÁI MẠNG
                  _buildNetworkStatus(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // moved login button to features/auth/presentation/widgets/login_button.dart

  Widget _buildNetworkStatus(BuildContext context) {
    final networkState = context.watch<NetworkCubit>().state;

    if (networkState.isConnected == false) {
      return Container(
        padding: AppSpacing.paddingAllMd,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer.withAlpha(50),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.wifi_off, color: Theme.of(context).colorScheme.error),
            AppSpacing.horizontalSpaceMd, // Khoảng cách ngang giữa Icon và Text
            Expanded(
              child: Text(
                'Mất kết nối mạng. Vui lòng kiểm tra lại.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
