---
name: clarity-ui
description: Quản lý UI Tokens, Typography, Colors và các quy tắc cấm hard-coded giá trị giao diện.
---

# 🎨 Clarity RMS - Quy chuẩn UI & Styling

## 1. Quy tắc UI Tokens (Bắt buộc)

- **`lib/core/ui` reserved**: Chỉ dành cho "UI tokens" kỹ thuật (spacing, dimensions, radius). Không đặt widget, business logic, hoặc file cấu hình vào đây.
- **Cấm hard-coded**: Tất cả padding, margin, kích thước icon, radius, chiều cao nút, khoảng cách... phải dùng hằng số/token trong `lib/core/ui` (`AppSpacing`, `AppDimensions`, `AppRadius`).
- **Typography & Colors**: Dùng `lib/shared/styles` (`AppTypography`, `AppColors`, `AppTheme`) hoặc `Theme.of(context)`.

## 2. Widget & Reuse

- **Widget tái sử dụng**: Đưa vào `presentation/widgets/` hoặc `lib/shared/widgets/`.
- **Widget nội bộ trang**: Dùng private method `_buildXxx`.
- **Kiểm soát ngoại lệ**: Trường hợp prototype/POC cần giá trị tạm thời, phải chú thích rõ `// PROTOTYPE: reason`.

## 3. Enforcement & CI

- Thực hiện grep các literal số trong `lib/**/presentation/**` để phát hiện hard-coded UI numbers.
- Kiểm tra việc tuân thủ DI qua `sl`.
