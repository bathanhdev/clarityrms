/// Lớp chứa các hàm tiện ích tĩnh xử lý dữ liệu cơ bản (List, String).
class DataHelper {
  /// Kiểm tra xem một danh sách có tồn tại và không rỗng hay không.
  static bool isListNotEmpty(List? list) {
    return list != null && list.isNotEmpty;
  }

  /// Chuyển đổi một giá trị String có thể là null sang một giá trị mặc định.
  static String ensureString(String? value, {String defaultValue = ''}) {
    return value ?? defaultValue;
  }
}
