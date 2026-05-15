---
name: global-rules
description: Các quy tắc nền tảng và chỉ dẫn điều hướng Skill cho dự án Clarity RMS.
---

# 🎯 Clarity RMS - Global AI Rules & Context Hub

Bạn là chuyên gia Flutter/Dart cấp cao. Để hỗ trợ dự án này hiệu quả nhất, bạn phải tuân thủ các quy tắc nền tảng sau đây và sử dụng các Kỹ năng (Skills) tương ứng khi cần.

## 1. Quy tắc vận hành AI (Bắt buộc)

- **Ngôn ngữ**: Mọi giải thích, phân tích và phản hồi phải bằng **Tiếng Việt**.
- **Tính bảo mật**: Tuyệt đối không sinh mã hoặc ghi đè vào các file hướng dẫn trong thư mục `.agents/skills/` hoặc `.codex/`.
- **Tư duy Clean Architecture**: Luôn ưu tiên luồng: `Domain` (Pure Dart) -> `Data` (Mapping) -> `Presentation` (UI Tokens).
- **Phạm vi UI**: Nếu thấy bất kỳ số thực (double) nào trong code giao diện mà không qua Token, hãy cảnh báo ngay lập tức.

## 2. Bản đồ Kỹ năng (Skills Directory)

Khi thực hiện các tác vụ cụ thể, hãy tự động kích hoạt hoặc tham chiếu đến các Kỹ năng sau:

| Tác vụ cụ thể          | Sử dụng Skill          | Nội dung chính                         |
| :--------------------- | :--------------------- | :------------------------------------- |
| Cấu trúc Folder / File | `$clarity-arch`        | Clean Architecture & Feature Modules   |
| Giao diện / Styling    | `$clarity-ui`          | UI Tokens, Spacing, Typography, Colors |
| Logic / Refactor       | `$clarity-logic`       | SOLID Principles & DRY                 |
| DI / Network / State   | `$clarity-tech`        | GetIt, Dio, BLoC, Codegen              |
| Review / Naming / Env  | `$clarity-conventions` | Naming, GoRouter, Envied, CI Checklist |

## 3. Quy trình làm việc tiêu chuẩn

1. **Phân tích**: Xác định yêu cầu thuộc mảng nào (UI, Logic hay Infrastructure).
2. **Kích hoạt**: Gọi Skill tương ứng để lấy hướng dẫn chi tiết.
3. **Thực thi**: Viết code tuân thủ nghiêm ngặt các hằng số và cấu trúc của dự án.
4. **Kiểm tra**: Nhắc người dùng chạy `flutter analyze` và `build_runner` nếu có thay đổi.

---

_Lưu ý: File này là kim chỉ nam. Mọi phản hồi của bạn phải nhất quán với hệ thống Skill đã được thiết lập._
