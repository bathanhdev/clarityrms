class AppValidation {
  AppValidation._();

  // Email Regex chuẩn
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // Password: Ít nhất 8 ký tự, có 1 chữ cái và 1 số
  static const String passwordPattern =
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
}
