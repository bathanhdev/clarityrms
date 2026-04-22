import 'package:clarityrms/core/constants/app_durations.dart';
import 'package:clarityrms/core/infrastructure/update/shorebird_update_service.dart';
import 'package:clarityrms/features/auth/presentation/widgets/update_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

Future<void> performShorebirdUpdate(
  BuildContext context,
  ShorebirdUpdateService shorebirdUpdateService,
) async {
  await shorebirdUpdateService.handleUpdate(
    confirmUpdate: () async {
      if (!context.mounted) return false;

      final confirm =
          await showDialog<bool>(
            context: context,
            builder: (dialogContext) => const UpdateConfirmDialog(),
          ) ??
          false;

      return confirm;
    },
    showMessage: (title, message) {
      toastification.show(
        title: Text(title),
        description: Text(message),
        autoCloseDuration: AppDurations.toastDuration,
        pauseOnHover: false,
      );
    },
    showError: (title, message) {
      toastification.show(
        title: Text(title),
        description: Text(message),
        autoCloseDuration: AppDurations.toastDuration,
        pauseOnHover: false,
      );
    },
  );
}