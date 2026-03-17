# 🚀 Clarity RMS - Full Copilot Instructions

Bạn là chuyên gia Flutter/Dart cho dự án Clarity RMS. Hãy tuân thủ nghiêm ngặt cấu trúc và các nguyên tắc sau:

## 1. Kiến trúc & Cấu trúc thư mục (Clean Architecture)

- **Feature Modules**: `lib/features/<name>/`. Mỗi module gồm:
  - `domain/`: `entities/`, `repositories/` (interface), `usecases/`. **Bắt buộc**: Pure Dart, không import Flutter/Dio/Hive.
  - `data/`: `models/` (DTO), `datasources/`, `repositories/` (impl). Thực hiện mapping model -> entity tại đây.
  - `presentation/`: `pages/`, `widgets/`, `bloc/` (hoặc `cubit/`).
- **Core & Shared**:
  - `lib/core/`: Hạ tầng (DI, Network, Router, Global State).
  - `lib/shared/`: Components, styles, extensions dùng chung.

## Quy tắc bổ sung (Important)

- **Không sinh hoặc ghi mã vào file hướng dẫn**: Tuyệt đối không ghi, tạo, hoặc generate nội dung vào `.github/copilot-instructions.md` từ code hoặc các script. File này chỉ dùng làm hướng dẫn cho Copilot/agent và chỉ được chỉnh sửa thủ công bởi người phát triển khi cần.
- **`lib/core/ui` reserved**: Thư mục `lib/core/ui` chỉ dành cho "UI tokens" kỹ thuật (spacing, dimensions, radius). Không đặt widget, business logic, hoặc file cấu hình vào `lib/core/ui` nếu chúng không phải token kỹ thuật. Các component/stylesheet/định nghĩa UI khác phải nằm ở `lib/shared/styles` hoặc trong feature modules tương ứng.

### **Quy tắc UI Tokens (Bắt buộc)**

- **Mọi giá trị giao diện không được hard-coded**: Tất cả padding, margin, kích thước icon, radius, chiều cao nút, khoảng cách, và các giá trị kích thước giao diện khác phải dùng hằng số/ token trong `lib/core/ui` (`AppSpacing`, `AppDimensions`, `AppRadius`, v.v.).
- **Mọi kiểu chữ và màu sắc**: Phải dùng `lib/shared/styles` (`AppTypography`, `AppColors`, `AppTheme`) hoặc `Theme.of(context)`; không dùng màu/rgb/hard-coded font size trực tiếp trong widget.
- **Kiểm soát ngoại lệ**: Trường hợp cần giá trị tạm thời (prototype/POC), phải chú thích rõ `// PROTOTYPE: reason` và tạo issue/PR để thay bằng token thích hợp trước khi merge.
- **Đảm bảo tuân thủ**: Việc tuân thủ quy tắc này được thực thi qua code review; khuyến khích thêm lint hoặc script CI (ví dụ: grep/analysis rule) nếu cần để phát hiện literal số (`EdgeInsets`, `height`, `width`, `fontSize`, `radius`) trong mã nguồn giao diện.

Lý do: Giữ nhất quán UI, dễ điều chỉnh toàn cục, và tránh băm vặt giá trị khiến giao diện không đồng bộ.

## 2. Nguyên tắc SOLID & DRY

- **S (Single Responsibility)**: Một Class/Widget chỉ làm một việc. Logic phức tạp phải tách ra khỏi UI.
- **D (Dependency Inversion)**: Luôn phụ thuộc vào interface (Domain), không phụ thuộc vào implementation (Data).
- **DRY (Don't Repeat Yourself)**:
  - Check `lib/shared/` trước khi tạo mới.
  - Logic dùng chung đưa vào `extensions` hoặc `utils`.
  - UI dùng chung đưa vào `lib/shared/widgets/`.

## 3. Dependency Injection (GetIt)

- **Centralized Locator**: Sử dụng `sl` từ `lib/core/di/locator.dart`.
- **Nguyên tắc**: Ưu tiên **Constructor Injection**.
- Chỉ dùng `sl<T>()` tại `injection_container.dart` hoặc khi khởi tạo Bloc/Cubit. Tránh gọi `sl()` trong logic nghiệp vụ.

## 4. Networking & State Management

- **HTTP Client**: Sử dụng `Dio`. Xử lý qua `NetworkHandler` và `ApiResponseHandler` tại `lib/core/infrastructure/network/`.
- **Auth**: Token flow nằm tại `AuthInterceptor` (sử dụng `tokenDio` riêng).
- **State**: Sử dụng `flutter_bloc`. Global cubit nằm ở `lib/core/global_state/`.
- **Codegen**: Sử dụng `Freezed`, `json_serializable`, `envied`. Nhắc chạy: `flutter pub run build_runner build --delete-conflicting-outputs`.

## 5. Quy ước Code & UI

- **Đặt tên**: File `snake_case`, Class `PascalCase`. UseCase dùng phương thức `call()`.
- **UI**:
  - Widget tái sử dụng -> `presentation/widgets/`.
  - Widget nội bộ trang -> private method `_buildXxx`.
- **Navigation**: `GoRouter`. Cấu hình tại `lib/core/router/app_router.dart`.
- **Env**: Không commit secrets. Dùng `envied` với file generated `lib/config/env.g.dart`.

## 6. Quy trình & Phản hồi

- **Thứ tự viết code**: Domain -> Data -> Presentation.
- **Trước khi hoàn tất**: Nhắc người dùng chạy `flutter analyze` và đăng ký DI/Router.
- **Ngôn ngữ**: Giải thích và phản hồi bằng **Tiếng Việt**.
