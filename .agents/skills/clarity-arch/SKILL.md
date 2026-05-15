---
name: clarity-arch
description: Hướng dẫn Clean Architecture, cấu trúc Feature Modules, và quy trình phát triển Domain-Data-Presentation.
---

# 🚀 Clarity RMS - Kiến trúc & Cấu trúc thư mục

## 1. Feature Modules: `lib/features/<name>/`

Mỗi module phải bao gồm đầy đủ 3 tầng:

- **domain/**: `entities/`, `repositories/` (interface), `usecases/`. **Bắt buộc**: Pure Dart, không import Flutter/Dio/Hive.
- **data/**: `models/` (DTO), `datasources/`, `repositories/` (impl). Thực hiện mapping model -> entity tại đây.
- **presentation/**: `pages/`, `widgets/`, `bloc/` (hoặc `cubit/`).

## 2. Core & Shared

- **lib/core/**: Hạ tầng (DI, Network, Router, Global State).
- **lib/shared/**: Components, styles, extensions dùng chung.

## 3. Quy trình & Phản hồi

- **Thứ tự viết code**: Domain -> Data -> Presentation.
- **Trước khi hoàn tất**: Nhắc người dùng chạy `flutter analyze` và đăng ký DI/Router.
- **Ngôn ngữ**: Giải thích và phản hồi bằng **Tiếng Việt**.
- **Lưu ý**: Tuyệt đối không tự ý ghi mã vào các file .md hướng dẫn. Các file này chỉ dùng để cung cấp hướng dẫn và nguyên tắc, không chứa code thực thi.
