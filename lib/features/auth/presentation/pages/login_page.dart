// UI_TOKENS_IGNORE
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/core/global_state/auth/auth_state.dart';
import 'package:clarityrms/core/router/app_router.dart';
import 'package:clarityrms/features/auth/presentation/widgets/auth_error_listener.dart';
import 'package:clarityrms/features/auth/presentation/widgets/auth_page_header.dart';
import 'package:clarityrms/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:clarityrms/features/auth/presentation/widgets/auth_social_login_buttons.dart';
import 'package:clarityrms/shared/widgets/network_status.dart';
import 'package:clarityrms/core/infrastructure/helpers/ui_helper.dart';
import 'package:clarityrms/shared/widgets/common_button.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

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

  Widget _buildLoginButton(bool isLoading) {
    return SizedBox(
      width: double.maxFinite,
      child: CommonButton(
        expanded: true,
        isLoading: isLoading,
        variant: CommonButtonVariant.filled,
        label: const Text('Đăng nhập'),
        onPressed: isLoading ? null : _performLogin,
      ),
    );
  }

  Widget _buildCredentialsForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Tên người dùng',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) => (value == null || value.isEmpty)
                ? 'Vui lòng nhập tên người dùng'
                : null,
          ),
          AppSpacing.verticalSpaceMd,
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Mật khẩu',
              prefixIcon: Icon(Icons.lock),
            ),
            validator: (value) => (value == null || value.isEmpty)
                ? 'Vui lòng nhập mật khẩu'
                : null,
          ),
          AppSpacing.verticalSpaceLg,
          _buildRememberAndForgotRow(context),
          AppSpacing.verticalSpaceLg,
          BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (previous, current) =>
                previous.runtimeType != current.runtimeType,
            builder: (context, state) {
              final bool isLoading = state is AuthLoading;
              return _buildLoginButton(isLoading);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRememberAndForgotRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _rememberMe = !_rememberMe),
            child: Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (v) => setState(() => _rememberMe = v ?? false),
                ),
                const Flexible(
                  child: Text(
                    'Ghi nhớ đăng nhập',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            GoRouter.of(context).push(AppRouter.forgotPassword);
          },
          child: const Text('Quên mật khẩu?'),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: AppSpacing.paddingHorizontalSm,
          child: const Text('Hoặc'),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return AuthPageShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthPageHeader(
            title: 'Chào mừng trở lại',
            subtitle: 'Đăng nhập để tiếp tục',
          ),
          SizedBox(height: AppSpacing.lg),
          _buildCredentialsForm(context),
          AppSpacing.verticalSpaceMd,
          const NetworkStatus(),
          AppSpacing.verticalSpaceLg,
          _buildDivider(),
          AppSpacing.verticalSpaceMd,
          const AuthSocialLoginButtons(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthErrorListener(child: Scaffold(body: _buildBody(context)));
  }
}
