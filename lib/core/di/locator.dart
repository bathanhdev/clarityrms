import 'package:get_it/get_it.dart';

/// Instance GetIt dùng chung cho toàn ứng dụng.
/// Sử dụng `sl` để đăng ký và lấy các phụ thuộc, tránh khai báo lại.
final sl = GetIt.instance;
