// ignore: unused_import
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:clarityrms/core/infrastructure/helpers/ui_helper.dart';

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

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    UIHelper.hideKeyboard(context);
    if (!_formKey.currentState!.validate()) return;
    // Register flow not implemented yet.
    UIHelper.showAppSnackBar(context, 'Chưa hỗ trợ đăng ký.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingAllLg,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tạo tài khoản mới',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                AppSpacing.verticalSpaceLg,

                TextFormField(
                  controller: _username,
                  decoration: const InputDecoration(
                    labelText: 'Tên người dùng',
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Vui lòng nhập tên người dùng'
                      : null,
                ),
                AppSpacing.verticalSpaceMd,
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Vui lòng nhập email' : null,
                ),
                AppSpacing.verticalSpaceMd,
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Mật khẩu'),
                  validator: (v) => (v == null || v.length < 6)
                      ? 'Mật khẩu ít nhất 6 ký tự'
                      : null,
                ),
                AppSpacing.verticalSpaceMd,
                TextFormField(
                  controller: _confirm,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                  ),
                  validator: (v) =>
                      (v != _password.text) ? 'Mật khẩu không khớp' : null,
                ),
                AppSpacing.verticalSpaceLg,
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Đăng ký'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
