// UI_TOKENS_IGNORE
import 'package:flutter/material.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/shared/widgets/network_status.dart';
import 'package:clarityrms/core/infrastructure/helpers/ui_helper.dart';
import 'package:clarityrms/features/auth/presentation/widgets/auth_error_listener.dart';
import 'package:clarityrms/features/auth/presentation/widgets/auth_page_header.dart';
import 'package:clarityrms/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:clarityrms/features/auth/presentation/widgets/auth_social_login_buttons.dart';
import 'package:clarityrms/shared/widgets/common_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  void _submit() {
    UIHelper.hideKeyboard(context);
    if (_formKey.currentState!.validate()) {
      UIHelper.showAppSnackBar(
        context,
        'Chức năng đăng ký chưa được triển khai',
      );
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _username,
            decoration: const InputDecoration(
              labelText: 'Tên người dùng',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (v) => (v == null || v.isEmpty)
                ? 'Vui lòng nhập tên người dùng'
                : null,
          ),
          AppSpacing.verticalSpaceMd,
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Vui lòng nhập email' : null,
          ),
          AppSpacing.verticalSpaceMd,
          TextFormField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Mật khẩu',
              prefixIcon: Icon(Icons.lock),
            ),
            validator: (v) =>
                (v == null || v.length < 6) ? 'Mật khẩu ít nhất 6 ký tự' : null,
          ),
          AppSpacing.verticalSpaceMd,
          TextFormField(
            controller: _confirm,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Xác nhận mật khẩu',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            validator: (v) =>
                (v != _password.text) ? 'Mật khẩu không khớp' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.maxFinite,
      child: CommonButton(
        expanded: true,
        variant: CommonButtonVariant.filled,
        label: const Text('Đăng ký'),
        onPressed: _submit,
      ),
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
            title: 'Tạo tài khoản mới',
            subtitle: 'Tạo tài khoản để bắt đầu sử dụng ứng dụng',
          ),
          SizedBox(height: AppSpacing.lg),
          _buildRegisterForm(),
          AppSpacing.verticalSpaceLg,
          _buildRegisterButton(),
          AppSpacing.verticalSpaceLg,
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
