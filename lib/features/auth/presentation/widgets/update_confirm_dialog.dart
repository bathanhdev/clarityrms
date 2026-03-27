import 'package:flutter/material.dart';

class UpdateConfirmDialog extends StatelessWidget {
  const UpdateConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cập nhật ứng dụng'),
      content: Text('Có bản cập nhật mới. Bạn có muốn tải và cài đặt bây giờ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Cập nhật'),
        ),
      ],
    );
  }
}
