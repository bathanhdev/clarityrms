---
name: clarity-conventions
description: Quy ước đặt tên, cấu hình Navigation (GoRouter), quản lý Env và bảo mật file hướng dẫn.
---

# 📝 Clarity RMS - Quy ước Code & Môi trường

## 1. Quy ước đặt tên

- **File**: `snake_case`.
- **Class**: `PascalCase`.
- **UseCase**: Phải dùng phương thức `call()`.

## 2. Hệ thống & Bảo mật

- **Navigation**: `GoRouter` tại `lib/core/router/app_router.dart`.
- **Env**: Dùng `envied`, không commit secrets. File gen: `lib/config/env.g.dart`.
- **Bảo mật file hướng dẫn**: Tuyệt đối không ghi, tạo, hoặc generate nội dung vào `.github/copilot-instructions.md`. File này chỉ được chỉnh sửa thủ công.

## 3. CI Checklist

- Kiểm tra `flutter analyze`.
- Đảm bảo Domain không import Data.
