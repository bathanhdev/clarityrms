# 🚀 Clarity RMS — Tổng quan & Hướng dẫn nhanh (Tiếng Việt)

Clarity RMS là ứng dụng Flutter cho quản lý bán lẻ, được thiết kế theo Clean Architecture và tổ chức theo Feature Modules để dễ mở rộng và bảo trì.

Mục tiêu file README này: giúp bạn (dev mới hoặc reviewer) nắm nhanh cấu trúc, cách chạy, và các điểm chú ý khi phát triển.

---

## 1. Yêu cầu môi trường

- Flutter SDK (tham khảo `pubspec.yaml` cho phiên bản Dart/Flutter yêu cầu).
- Công cụ codegen: `build_runner`, `freezed`, `envied` (đã khai báo trong `dev_dependencies`).

## 2. Cài đặt & chạy nhanh

- Cài dependency:

```bash
flutter pub get
```

- Sinh code sinh tự động (khi sửa Freezed/Json/Envied):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

- Chạy static analysis:

```bash
flutter analyze
```

- Chạy app:

```bash
flutter run
```

- Shorebird (Flutter release distribution):

```bash
# cài Shorebird CLI (nếu chưa có):
# macOS/Linux: brew install shorebird
# Windows (choco / winget): choco install shorebird
# Kiểm tra:
shorebird --version
```

```bash
# đăng nhập và khởi tạo project Shorebird trong repo
shorebird login
shorebird init
```

```bash
# Tạo release theo platform (Android/iOS/macOS/Linux/Windows)
shorebird release android
shorebird release ios
shorebird release macos
shorebird release linux
shorebird release windows
```

- Mặc định `shorebird release android` tạo `.aab`; để sinh thêm `.apk`:

```bash
shorebird release android --artifact apk
```

- Truyền tham số Flutter build qua `--`:

```bash
shorebird release android -- --dart-define="foo=bar"
# Trong Powershell: shorebird release android -- '--dart-define=foo=bar'
```

- Kiểm tra Flutter version Shorebird dùng:

```bash
shorebird doctor
```

- Tạo release cụ thể với flag Flutter version (tuỳ chọn):

```bash
shorebird release android --flutter-version 3.41.5
```

- Preview (chạy bản release đã tạo trên thiết bị/devices):

```bash
shorebird preview
```

Mặc định, lệnh sẽ tự động lấy release mới nhất của app được định nghĩa trong `shorebird.yaml`, cài lên thiết bị đang kết nối, và khởi động app.

- Để preview một platform cụ thể (nếu cần):

```bash
shorebird preview --platform android
shorebird preview --platform ios
```

- Tạo patch (tập trung cập nhật code mà không cần release full):

```bash
shorebird patch android
shorebird patch ios
shorebird patch macos
shorebird patch linux
shorebird patch windows
```

- Các tuỳ chọn patch thường dùng:

```bash
shorebird patch android --release-version latest
shorebird patch android --target lib/main_development.dart --flavor development
shorebird patch android -- --dart-define="foo=bar"
```

Gợi ý: Khi preview trên Windows/Mac hoặc Android/iOS, đảm bảo thiết bị/emulator đang online và đã được flutter doctor kiểm tra ok.

Gợi ý: xem docs chính thức tại https://docs.shorebird.dev/code-push/preview/ để chi tiết thêm `shorebird preview`.

Gợi ý: xem docs chính thức tại https://docs.shorebird.dev/code-push/release/ để đảm bảo sign certificate và provision profile (iOS) theo quy trình.

Gợi ý: nếu gặp lỗi codegen do conflict, chạy `flutter pub run build_runner build --delete-conflicting-outputs` để tự động xoá conflicts.

---

## 3. Cấu trúc thư mục chính (tóm tắt)

- `lib/main.dart`: điểm bắt đầu ứng dụng ([lib/main.dart](lib/main.dart#L1)).
- `lib/app/`: bootstrap app, `my_app.dart` (nơi cấu hình router và cung cấp các global cubit) ([lib/app/my_app.dart](lib/app/my_app.dart#L1)).
- `lib/config/`: cấu hình môi trường, Envied (Xem [lib/config/app_config.dart](lib/config/app_config.dart#L1)).
- `lib/core/`: phần hạ tầng và các thành phần dùng chung:
  - `lib/core/di/`: cấu hình DI và đăng ký dependencies. Điểm khởi tạo: [lib/core/di/injection_container.dart](lib/core/di/injection_container.dart#L1).
  - `lib/core/di/locator.dart`: **centralized** service locator `sl` (sử dụng GetIt) ([lib/core/di/locator.dart](lib/core/di/locator.dart#L1)).
  - `lib/core/infrastructure/network/`: `Dio`, interceptors, network handler ([lib/core/infrastructure/network/network_handler.dart](lib/core/infrastructure/network/network_handler.dart#L1)).
  - `lib/core/router/`: cấu hình `GoRouter` và các route constants ([lib/core/router/app_router.dart](lib/core/router/app_router.dart#L1)).
  - `lib/core/global_state/`: các Cubit/BLoC toàn cục (Auth, Network, ...).

- `lib/features/`: mỗi thư mục con là một Feature Module, theo structure: `domain/`, `data/`, `presentation/`.
  - Presentation: pages go under `presentation/pages/`. If a page contains sizeable or reusable widgets,
    extract them to `presentation/widgets/` (e.g. `features/auth/presentation/widgets/login_button.dart`).
    Keep small, page-local builders as private methods (`_buildXxx`) when they are trivial and not reused.
- `lib/shared/`: components, styles, extensions dùng chung.

---

## 4. Dependency Injection (GetIt)

- `GetIt` làm service locator. Mọi đăng ký chính nằm trong `injection_container.dart`.
- File `lib/core/di/locator.dart` xuất `final sl = GetIt.instance;` làm nguồn duy nhất cho toàn bộ project. Khi cần resolve dependency, dùng `sl<T>()`.
- Quy ước: tránh gọi `sl()` sâu trong domain/business logic — ưu tiên truyền dependency qua constructor để dễ test.

---

## 5. Networking

- Microservice API client: `ApiClient` chia riêng baseUrl + interceptor per service, đặt tại [lib/core/infrastructure/network/api_client.dart](lib/core/infrastructure/network/api_client.dart#L1).
- HTTP client: `Dio`. Cấu hình chính trong `lib/core/infrastructure/network/api_client_factory.dart`.
- `AuthInterceptor` xử lý gắn access token và refresh flow; có `tokenDio` riêng để gọi API làm mới token ([lib/core/infrastructure/network/interceptors/auth_interceptor.dart](lib/core/infrastructure/network/interceptors/auth_interceptor.dart#L1)).
- Các mapping lỗi và helper gọi mạng tập trung tại [lib/core/infrastructure/network/network_handler.dart](lib/core/infrastructure/network/network_handler.dart#L1) cùng kiểu phản hồi ở [lib/core/infrastructure/network/api_response_handler.dart](lib/core/infrastructure/network/api_response_handler.dart#L1).

---

## 6. Router & Navigation

- Ứng dụng dùng `GoRouter`. Router đã tách thành các phần nhỏ: routes constants, router config, `AuthListenable`.
- Lấy cấu hình router ở `my_app.dart` bằng `sl<AppRouter>().config` để truyền vào `MaterialApp.router`.

---

## 7. State Management

- `flutter_bloc` (Cubit/BLoC) được sử dụng cho cả global và feature-local state.
- Global cubit nằm trong `lib/core/global_state/`.

---

## 8. Env / Secrets

- Sử dụng `envied` để quản lý biến môi trường; file generated: [lib/config/env.g.dart](lib/config/env.g.dart#L1).
- Local env files: `assets/env/.env.dev`, `assets/env/.env.prod` (đã ignore trong `.gitignore`). Không commit secrets.

---

## 9. Quy ước và lời khuyên cho dev

- Domain layer phải thuần logic (không import Flutter/Dio/Hive).
- Khi thay đổi model/Freezed/Envied: luôn chạy codegen và kiểm tra kết quả trước khi commit.
- Khi thêm dependency cần thiết cho interceptor hoặc networking, đăng ký ở composition root (`injection_container.dart`) và inject qua constructor.

---

## 10. Kiểm tra trước khi PR

- `flutter analyze`
- Chạy codegen: `flutter pub run build_runner build --delete-conflicting-outputs`
- Kiểm tra `git diff` để chắc không đưa vào `assets/env/` hoặc file generated không cần thiết.

---

## 11. Liên kết nhanh (file tham khảo)

- [lib/main.dart](lib/main.dart#L1)
- [lib/app/my_app.dart](lib/app/my_app.dart#L1)
- [lib/core/di/injection_container.dart](lib/core/di/injection_container.dart#L1)
- [lib/core/di/locator.dart](lib/core/di/locator.dart#L1)
- [lib/core/router/app_router.dart](lib/core/router/app_router.dart#L1)
- [lib/core/infrastructure/network/network_handler.dart](lib/core/infrastructure/network/network_handler.dart#L1)

---

## Hướng dẫn chi tiết dành cho người đóng góp (Contributor Guide)

Mục tiêu phần này: bất kỳ dev nào mới tham gia đọc qua đều hiểu cách dự án tổ chức, cách làm việc, và các bước chuẩn để thêm tính năng/điều chỉnh mà không phá vỡ quy ước chung.

### A. Nguyên tắc chung

- Tập trung vào testability và tách bạch trách nhiệm (Single Responsibility).
- Domain layer phải thuần logic nghiệp vụ, không import Flutter/Dio/Hive.
- Prefer constructor injection; hạn chế gọi `sl()` ngoài composition root.
- Mỗi feature là module độc lập với 3 lớp: `domain/`, `data/`, `presentation/`.

### B. Quy ước đặt tên & phân chia tệp

- Feature: `features/<feature_name>/`
- Domain:
  - Entities: `features/<feature>/domain/entities/`
  - Repositories (interfaces): `features/<feature>/domain/repositories/`
  - UseCases: `features/<feature>/domain/usecases/`
- Data:
  - Models (DTO): `features/<feature>/data/models/`
  - DataSources: `features/<feature>/data/datasources/` (local/remote)
  - Repository Implementations: `features/<feature>/data/repositories/`
- Presentation:
  - Pages: `features/<feature>/presentation/pages/`
  - Widgets: `features/<feature>/presentation/widgets/`
  - Bloc/Cubit: `features/<feature>/presentation/bloc/`

File naming:

- Dart file names: `snake_case`, class names: `PascalCase`.
- Test files: `xxx_test.dart` nằm bên cạnh file tương ứng hoặc trong `test/`.

### C. Thêm một feature mới — bước mẫu (quick scaffold)

1. Tạo thư mục `features/<feature>/`.
2. Tạo skeleton `domain/`, `data/`, `presentation/`.
3. Viết `Entity` trong `domain/entities/`.
4. Định nghĩa `Repository` interface trong `domain/repositories/`.
5. Viết `UseCase(s)` trong `domain/usecases/`.
6. Tạo `DataSource` remote/local và `Model` trong `data/`.
7. Viết `RepositoryImpl` ở `data/repositories/` và đảm bảo mapping model → entity.
8. Thêm UI (page + widgets) và Cubit/Bloc trong `presentation/`.
9. Đăng ký dependency mới trong `lib/core/di/modules/<feature>_module.dart` bằng `sl.registerLazySingleton` hoặc `registerFactory` tùy loại.
10. Nếu cần route mới, thêm constant vào [lib/core/router/app_routes.dart](lib/core/router/app_routes.dart#L1) và khai báo route trong `app_router_config.dart`.
11. Chạy codegen và tests: `flutter pub run build_runner build --delete-conflicting-outputs` rồi `flutter test`.

### D. Cách đăng ký Dependency (GetIt)

1. Mọi đăng ký đều thực hiện ở composition root: [lib/core/di/injection_container.dart](lib/core/di/injection_container.dart#L1) hoặc các module dưới `lib/core/di/modules/`.
2. Không gọi `sl.register...` ở nhiều nơi rải rác trong codebase; gom đăng ký theo module feature hoặc core.
3. Khi cần DI: inject qua constructor và trong `injection_container.dart` dùng `sl.registerLazySingleton` / `sl.registerFactory`.
4. Central locator: [lib/core/di/locator.dart](lib/core/di/locator.dart#L1) — sử dụng `import 'package:clarityrms/core/di/locator.dart';` + `sl<T>()` để resolve ở composition root hoặc nơi cần.

Ví dụ nhanh (đăng ký repository):

```dart
// trong lib/core/di/modules/auth_feature_module.dart
sl.registerLazySingleton<AuthRepository>(
	() => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
);
```

### E. Quy trình thêm route mới

1. Thêm constant vào [lib/core/router/app_routes.dart](lib/core/router/app_routes.dart#L1).
2. Thêm page widget ở `features/<feature>/presentation/pages/`.
3. Đăng ký route trong [lib/core/router/app_router_config.dart](lib/core/router/app_router_config.dart#L1) (giữ redirect logic và `AuthListenable`).

### F. Codegen & Generated files

- Khi thay đổi model/Freezed/Envied: chạy

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

- Thông thường không commit `build/` hoặc các output tạm. Commit chỉ nguồn và file generated cần thiết theo quy ước team.

### G. Testing

- Unit tests: tập trung ở `test/` (hoặc bên cạnh file nếu team thích).
- Bloc/Cubit tests: mock repository và verify state transitions.
- Integration: chạy trên emulator, sử dụng `flutter_driver` hoặc `integration_test`.

### H. Kiểm tra trước khi mở PR (PR checklist)

- [ ] Chạy `flutter analyze` — không có lỗi hoặc cảnh báo quan trọng.
- [ ] Chạy codegen nếu cần và commit file nguồn (không commit build outputs trừ khi có quy định).
- [ ] Viết/ cập nhật test phù hợp với thay đổi.
- [ ] Chạy format: `dart format .`.
- [ ] Đảm bảo không commit `assets/env/` hoặc secrets.
- [ ] Mô tả PR rõ: mục đích, thay đổi chính, link issue, cách test manual.

### I. Branch & Merge policy (gợi ý)

- Branch naming: `feature/<feature>-short-desc`, `fix/<short-desc>`, `hotfix/<short-desc>`.
- PR target: `develop` (hoặc `main` tùy quy ước team).
- Luôn rebase từ target branch trước khi merge.

### J. Coding style & lint

- Sử dụng `flutter_lints` (đã có trong `dev_dependencies`).
- Chạy `dart format .` trước khi commit.

### K. Thông tin debugging & lỗi thường gặp

- Lỗi codegen do conflict: chạy `flutter pub run build_runner build --delete-conflicting-outputs`.
- Lỗi network do interceptor: kiểm tra `AuthInterceptor` và `tokenDio` đăng ký đúng chưa.

### L. Người liên hệ / Owner

- Thêm thông tin owner/module maintainer nếu có (ví dụ: `@team-backend`, `@alice`).

---

### M. Design tokens — Spacing / Radius / Dimensions (Quy ước giao diện)

Ứng dụng đã định nghĩa các design tokens để đảm bảo giao diện nhất quán. Luôn sử dụng các token này thay vì số cố định (magic numbers).

- `AppSpacing` ([lib/core/ui/app_spacing.dart](lib/core/ui/app_spacing.dart#L1))
  - EdgeInsets và SizedBox chuẩn: `AppSpacing.paddingAllMd`, `AppSpacing.paddingHorizontalSm`, `AppSpacing.verticalSpaceMd`, ...
  - Ví dụ: `Padding(padding: AppSpacing.screenPadding, child: ...)`.

- `AppRadius` ([lib/core/ui/app_radius.dart](lib/core/ui/app_radius.dart#L1))
  - Giá trị radius và Shape: `AppRadius.borderRadiusMd`, `AppRadius.roundedRectangleBorderMd`.
  - Ví dụ: `Container(decoration: BoxDecoration(borderRadius: AppRadius.borderRadiusMd))`.

- `AppDimensions` ([lib/core/ui/app_dimensions.dart](lib/core/ui/app_dimensions.dart#L1))
  - Kích thước chuẩn: `iconSize`, `buttonHeight`, `lineThickness`, `font sizes`, ...
  - Ví dụ: `SizedBox(height: AppDimensions.buttonHeightMd)`.

Nguyên tắc ngắn gọn:

- Không dùng số cố định trực tiếp cho padding/margin/radius/size trong UI mới — dùng các token ở trên.
- Nếu cần giá trị mới, thêm token vào `AppSpacing`/`AppRadius`/`AppDimensions` và cập nhật component dùng lại.
- Khi refactor component, thay các magic numbers bằng token tương ứng.

Ví dụ (Button):

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    minimumSize: Size.fromHeight(AppDimensions.buttonHeightMd),
    shape: AppRadius.roundedRectangleBorderMd,
    padding: AppSpacing.paddingSymmetricMd,
  ),
  onPressed: () {},
  child: Text('OK'),
)
```

---

### N. Hướng dẫn sử dụng `Theme` trong UI (Theme.of(context))

Sử dụng `Theme.of(context)` trong widget để lấy `TextStyle`, `ColorScheme` hoặc các `ThemeExtension` là thực hành tiêu chuẩn và được khuyến khích. Dưới đây là các quy tắc cần tuân thủ:

- **Chỉ dùng trong UI/widget:** chỉ gọi `Theme.of(context)` trong các widget (trong `build` hoặc các hàm trả về widget). Không gọi trong domain/usecase/repository.
- **Dùng `TextTheme` và `ColorScheme` thay vì số cứng:** ví dụ `Theme.of(context).textTheme.titleMedium` hoặc `Theme.of(context).colorScheme.primary` để đảm bảo hỗ trợ dark/light và consistency.
- **Tránh giữ `BuildContext` qua async dài:** không lưu `context` rồi dùng sau `await` dài, có thể gây lỗi khi widget đã unmounted.
- **Kết hợp với design tokens:** dùng cả `Theme` cho màu/chữ và `AppSpacing`/`AppRadius` cho layout; đừng lẫn lộn vai trò.
- **Khi cần biến mở rộng:** dùng `ThemeExtension` để thêm biến theme tuỳ chỉnh và truy xuất bằng `Theme.of(context).extension<MyTokens>()`.
- **Tiện ích:** có thể tạo extension ngắn gọn `context.textTheme` hoặc `context.colors` để code ngắn và đồng nhất.

Ví dụ nhanh:

```dart
Widget build(BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  final titleStyle = Theme.of(context).textTheme.titleMedium;

  return Padding(
    padding: AppSpacing.screenPadding,
    child: Text('Tiêu đề', style: titleStyle?.copyWith(color: colors.primary)),
  );
}
```
