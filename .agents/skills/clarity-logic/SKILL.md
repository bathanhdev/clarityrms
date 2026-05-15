---
name: clarity-logic
description: Thực thi các nguyên tắc SOLID và DRY trong lập trình Flutter/Dart.
---

# 🧠 Clarity RMS - Nguyên tắc SOLID & DRY

## 1. SOLID Principles

- **S (Single Responsibility)**: Tách biệt hoàn toàn Logic (Bloc/UseCase) khỏi UI.
- **O (Open/Closed)**: Sử dụng `abstract class` và `interfaces` (Ví dụ: thêm `PaymentMethod` mới mà không sửa class cũ).
- **L (Liskov Substitution)**: Lớp con phải thay thế được lớp cha mà không làm hỏng chương trình.
- **I (Interface Segregation)**: Chia nhỏ các Interface lớn thành nhiều Interface cụ thể (Ví dụ: `UserReadRepository` & `UserWriteRepository`).
- **D (Dependency Inversion)**: UseCase luôn gọi Repository Interface thay vì Implementation.

## 2. DRY (Don't Repeat Yourself)

- **Centralized Components**: Kiểm tra `lib/shared/widgets/` trước khi tạo mới.
- **Logic Reuse**: Đưa logic tính toán/định dạng vào `extensions` hoặc `utils`.
