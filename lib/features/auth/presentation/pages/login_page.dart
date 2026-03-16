import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/core/global_state/auth/auth_state.dart';
import 'package:clarityrms/core/global_state/network/network_cubit.dart';
import 'package:clarityrms/core/infrastructure/helpers/ui_helper.dart';
import 'package:clarityrms/shared/generated/assets.gen.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/shared/widgets/common_button.dart';
import 'package:clarityrms/shared/widgets/transparent_app_bar.dart';
import 'package:clarityrms/shared/constants/hero_tags.dart';

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

  Widget _buildNetworkStatus(BuildContext context) {
    return BlocBuilder<NetworkCubit, NetworkState>(
      builder: (context, state) {
        if (state is NetworkDisconnected) {
          return Row(
            children: [
              Icon(Icons.wifi_off, color: Theme.of(context).colorScheme.error),
              AppSpacing.horizontalSpaceSm,
              Expanded(
                child: Text(
                  'Mất kết nối mạng. Vui lòng kiểm tra lại.',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
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
                              'Chào mừng trở lại',
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
                              'Đăng nhập để tiếp tục',
                              style: Theme.of(context).textTheme.bodyMedium,
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
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Tên người dùng',
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
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
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'Vui lòng nhập mật khẩu'
                                  : null,
                            ),

                            AppSpacing.verticalSpaceLg,

                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => _rememberMe = !_rememberMe,
                                    ),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: _rememberMe,
                                          onChanged: (v) => setState(
                                            () => _rememberMe = v ?? false,
                                          ),
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
                                    UIHelper.showAppSnackBar(
                                      context,
                                      'Quên mật khẩu chưa được hỗ trợ',
                                    );
                                  },
                                  child: const Text('Quên mật khẩu?'),
                                ),
                              ],
                            ),

                            AppSpacing.verticalSpaceLg,

                            BlocBuilder<AuthCubit, AuthState>(
                              buildWhen: (previous, current) =>
                                  previous.runtimeType != current.runtimeType,
                              builder: (context, state) {
                                final bool isLoading = state is AuthLoading;
                                return _buildLoginButton(isLoading);
                              },
                            ),

                            AppSpacing.verticalSpaceMd,

                            _buildNetworkStatus(context),

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
                                    onPressed: () {
                                      UIHelper.showAppSnackBar(
                                        context,
                                        'Đăng nhập với Google tạm thời chưa hỗ trợ',
                                      );
                                    },
                                    icon: const Icon(Icons.login),
                                    label: const Text('Google'),
                                  ),
                                ),
                                AppSpacing.horizontalSpaceMd,
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      UIHelper.showAppSnackBar(
                                        context,
                                        'Đăng nhập với Facebook tạm thời chưa hỗ trợ',
                                      );
                                    },
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
