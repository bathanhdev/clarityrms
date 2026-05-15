---
name: clarity-tech
description: Quản lý Dependency Injection (GetIt), Networking (Dio), Microservices và State Management (BLoC).
---

# 🛠️ Clarity RMS - Hạ tầng kỹ thuật

## 1. Dependency Injection (GetIt)

- **Locator**: Sử dụng `sl` từ `lib/core/di/locator.dart`.
- **Nguyên tắc**: Ưu tiên **Constructor Injection**. Chỉ dùng `sl<T>()` tại `injection_container.dart` hoặc khi khởi tạo Bloc/Cubit.

## 2. Networking & State

- **Microservice**: Sử dụng `ApiClient` + `ApiClientFactory` để tách `baseUrl` và interceptor.
- **HTTP Client**: Sử dụng `Dio` xử lý qua `NetworkHandler` và `ApiResponseHandler`.
- **Auth**: Token flow nằm tại `AuthInterceptor` (sử dụng `tokenDio` riêng).
- **State**: Sử dụng `flutter_bloc`. Global cubit tại `lib/core/global_state/`.

## 3. Codegen

- Luôn nhắc chạy: `flutter pub run build_runner build --delete-conflicting-outputs`.
