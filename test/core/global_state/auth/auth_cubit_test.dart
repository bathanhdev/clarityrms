import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/core/global_state/auth/auth_state.dart';
import 'package:clarityrms/core/usecases/usecase.dart';
import 'package:clarityrms/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:clarityrms/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:clarityrms/features/auth/domain/usecases/logout_user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clarityrms/features/auth/domain/entities/auth_entity.dart';
import 'package:clarityrms/core/infrastructure/network/handler/api_response_handler.dart';
import 'package:clarityrms/features/auth/domain/usecases/params/login_params.dart';

// Mock classes for usecases
class MockLoginUserUseCase extends Mock implements LoginUserUseCase {}

class MockCheckAuthStatusUseCase extends Mock
    implements CheckAuthStatusUseCase {}

class MockLogoutUserUseCase extends Mock implements LogoutUserUseCase {}

class NoParamsFake extends Fake implements NoParams {}

class LoginParamsFake extends Fake implements LoginParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(NoParamsFake());
    registerFallbackValue(LoginParamsFake());
  });

  late MockLoginUserUseCase mockLogin;
  late MockCheckAuthStatusUseCase mockCheckAuth;
  late MockLogoutUserUseCase mockLogout;

  setUp(() {
    mockLogin = MockLoginUserUseCase();
    mockCheckAuth = MockCheckAuthStatusUseCase();
    mockLogout = MockLogoutUserUseCase();
  });

  test(
    'appStarted -> emits Loading then Authenticated when checkAuthStatus returns true',
    () async {
      when(() => mockCheckAuth.call(any())).thenAnswer((_) async => true);

      final cubit = AuthCubit(
        loginUser: mockLogin,
        checkAuthStatus: mockCheckAuth,
        logoutUser: mockLogout,
      );

      expectLater(
        cubit.stream,
        emitsInOrder([isA<AuthLoading>(), isA<AuthAuthenticated>()]),
      );

      await cubit.appStarted();
    },
  );

  test(
    'appStarted -> emits Loading then Unauthenticated when checkAuthStatus returns false',
    () async {
      when(() => mockCheckAuth.call(any())).thenAnswer((_) async => false);

      final cubit = AuthCubit(
        loginUser: mockLogin,
        checkAuthStatus: mockCheckAuth,
        logoutUser: mockLogout,
      );

      expectLater(
        cubit.stream,
        emitsInOrder([isA<AuthLoading>(), isA<AuthUnauthenticated>()]),
      );

      await cubit.appStarted();
    },
  );

  test('login -> emits Loading then Authenticated on success', () async {
    final authEntity = AuthEntity(
      accessToken: 'a',
      refreshToken: 'r',
      expiresIn: 3600,
    );
    when(
      () => mockLogin.call(any()),
    ).thenAnswer((_) async => APIResponse.success(data: authEntity));

    final cubit = AuthCubit(
      loginUser: mockLogin,
      checkAuthStatus: mockCheckAuth,
      logoutUser: mockLogout,
    );

    expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthLoading>(), isA<AuthAuthenticated>()]),
    );

    await cubit.login('user', 'pass');
  });

  test('login -> emits Loading then AuthError on failure', () async {
    final error = ApiErrorDetail(statusCode: 400, message: 'bad');
    when(
      () => mockLogin.call(any()),
    ).thenAnswer((_) async => APIResponse.failure(errorDetail: error));

    final cubit = AuthCubit(
      loginUser: mockLogin,
      checkAuthStatus: mockCheckAuth,
      logoutUser: mockLogout,
    );

    expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthLoading>(), isA<AuthError>()]),
    );

    await cubit.login('user', 'pass');
  });

  test('logout -> emits Loading then Unauthenticated on success', () async {
    when(
      () => mockLogout.call(any()),
    ).thenAnswer((_) async => APIResponse.success(data: null));

    final cubit = AuthCubit(
      loginUser: mockLogin,
      checkAuthStatus: mockCheckAuth,
      logoutUser: mockLogout,
    );

    expectLater(
      cubit.stream,
      emitsInOrder([isA<AuthLoading>(), isA<AuthUnauthenticated>()]),
    );

    await cubit.logout();
  });

  test(
    'logout -> emits Loading, AuthError, Unauthenticated on failure',
    () async {
      final error = ApiErrorDetail(statusCode: 500, message: 'err');
      when(
        () => mockLogout.call(any()),
      ).thenAnswer((_) async => APIResponse.failure(errorDetail: error));

      final cubit = AuthCubit(
        loginUser: mockLogin,
        checkAuthStatus: mockCheckAuth,
        logoutUser: mockLogout,
      );

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthError>(),
          isA<AuthUnauthenticated>(),
        ]),
      );

      await cubit.logout();
    },
  );
}
