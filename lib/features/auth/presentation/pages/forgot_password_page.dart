// UI_TOKENS_IGNORE
import 'package:clarityrms/core/constants/app_validation.dart';
import 'package:clarityrms/core/infrastructure/helpers/ui_helper.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/features/auth/presentation/widgets/auth_page_header.dart';
import 'package:clarityrms/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:clarityrms/shared/widgets/common_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _submit() {
    UIHelper.hideKeyboard(context);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    UIHelper.showAppSnackBar(
      context,
      'Chức năng đặt lại mật khẩu sẽ được nối API sau.',
    );
  }

  String? _validateIdentifier(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Vui lòng nhập email hoặc số điện thoại';
    }

    final isEmail = RegExp(AppValidation.emailPattern).hasMatch(text);
    final isPhone = RegExp(r'^\d{9,11}$').hasMatch(text);

    if (!isEmail && !isPhone) {
      return 'Nhập email hợp lệ hoặc số điện thoại 9-11 chữ số';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthPageShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthPageHeader(
              title: 'Quên mật khẩu',
              subtitle:
                  'Nhập email hoặc số điện thoại để nhận hướng dẫn đặt lại mật khẩu',
            ),
            AppSpacing.verticalSpaceLg,
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _identifierController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email hoặc số điện thoại',
                  prefixIcon: Icon(Icons.contact_mail_outlined),
                ),
                validator: _validateIdentifier,
              ),
            ),
            AppSpacing.verticalSpaceLg,
            CommonButton(
              expanded: true,
              variant: CommonButtonVariant.filled,
              label: const Text('Gửi hướng dẫn đặt lại'),
              onPressed: _submit,
            ),
            AppSpacing.verticalSpaceMd,
            Text(
              'Nếu tài khoản tồn tại, hệ thống sẽ gửi hướng dẫn đặt lại mật khẩu tới kênh bạn nhập.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
