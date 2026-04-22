// UI_TOKENS_IGNORE
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/shared/widgets/network_status.dart';
import 'package:clarityrms/shared/widgets/transparent_app_bar.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:clarityrms/core/infrastructure/helpers/ui_helper.dart';
import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/core/global_state/auth/auth_state.dart';
import 'package:clarityrms/features/auth/presentation/helpers/facebook_login_helper.dart';
import 'package:clarityrms/shared/generated/assets.gen.dart';
import 'package:clarityrms/shared/widgets/common_button.dart';
import 'package:clarityrms/shared/constants/hero_tags.dart';
import 'package:clarityrms/features/auth/presentation/helpers/google_login_helper.dart';

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
        appBar: const TransparentAppBar(),
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withAlpha(28),
                Theme.of(context).colorScheme.primaryContainer.withAlpha(18),
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.borderRadiusMd,
                ),
                elevation: 8,
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Hero(
                              tag: HeroTags.appLogo,
                              child: Assets.images.logo.image(
                                height: AppDimensions.logoSize * 0.75,
                              ),
                            ),
                            AppSpacing.verticalSpaceSm,
                            Text(
                              'Tạo tài khoản mới',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            AppSpacing.verticalSpaceXs,
                            Text(
                              'Tạo tài khoản để bắt đầu sử dụng ứng dụng',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppSpacing.lg),

                      Form(
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
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Vui lòng nhập email'
                                  : null,
                            ),
                            AppSpacing.verticalSpaceMd,
                            TextFormField(
                              controller: _password,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Mật khẩu',
                                prefixIcon: Icon(Icons.lock),
                              ),
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
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                              validator: (v) => (v != _password.text)
                                  ? 'Mật khẩu không khớp'
                                  : null,
                            ),
                            AppSpacing.verticalSpaceLg,

                            SizedBox(
                              width: double.maxFinite,
                              child: CommonButton(
                                expanded: true,
                                variant: CommonButtonVariant.filled,
                                label: const Text('Đăng ký'),
                                onPressed: _submit,
                              ),
                            ),

                            AppSpacing.verticalSpaceLg,

                            const NetworkStatus(),

                            AppSpacing.verticalSpaceLg,

                            Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: AppSpacing.paddingHorizontalSm,
                                  child: Text('Hoặc'),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),

                            AppSpacing.verticalSpaceMd,

                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => performGoogleLogin(
                                      context,
                                      context.read<AuthCubit>(),
                                    ),
                                    icon: const Icon(Icons.login),
                                    label: const Text('Google'),
                                  ),
                                ),
                                AppSpacing.horizontalSpaceMd,
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => performFacebookLogin(
                                      context,
                                      context.read<AuthCubit>(),
                                    ),
                                    icon: const Icon(Icons.login),
                                    label: const Text('Facebook'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
