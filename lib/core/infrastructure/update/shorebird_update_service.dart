import 'package:shorebird_code_push/shorebird_code_push.dart';

enum ShorebirdUpdateCheckStatus {
  unavailable,
  upToDate,
  restartRequired,
  outdated,
}

class ShorebirdUpdateResult {
  final ShorebirdUpdateCheckStatus status;
  final String? message;

  const ShorebirdUpdateResult({required this.status, this.message});

  bool get canUpdate => status == ShorebirdUpdateCheckStatus.outdated;
}

class ShorebirdUpdateService {
  final ShorebirdUpdater _updater = ShorebirdUpdater();

  bool get isAvailable => _updater.isAvailable;

  Future<void> handleUpdate({
    required Future<bool> Function() confirmUpdate,
    required void Function(String title, String message) showMessage,
    required void Function(String title, String message) showError,
  }) async {
    final result = await checkForUpdate();

    if (result.canUpdate) {
      final shouldUpdate = await confirmUpdate();
      if (!shouldUpdate) {
        showMessage('ShoreBird', 'Cập nhật đã bị hủy.');
        return;
      }

      showMessage('ShoreBird update', 'Đang tải bản cập nhật...');

      try {
        await update();
        showMessage(
          'ShoreBird',
          'Cập nhật đã tải xong. Khởi động lại ứng dụng để áp dụng.',
        );
      } on UpdateException catch (error) {
        showError('ShoreBird error', error.message);
      } catch (error) {
        showError('ShoreBird error', error.toString());
      }

      return;
    }

    if (result.message != null && result.message!.isNotEmpty) {
      showError('ShoreBird', result.message!);
      return;
    }

    switch (result.status) {
      case ShorebirdUpdateCheckStatus.unavailable:
        showMessage('ShoreBird', 'Updater is unavailable in this build.');
        break;
      case ShorebirdUpdateCheckStatus.upToDate:
        showMessage('ShoreBird', 'App is up to date.');
        break;
      case ShorebirdUpdateCheckStatus.restartRequired:
        showMessage(
          'ShoreBird',
          'An update is installed and requires a restart.',
        );
        break;
      case ShorebirdUpdateCheckStatus.outdated:
        break;
    }
  }

  Future<ShorebirdUpdateResult> checkForUpdate() async {
    if (!isAvailable) {
      return const ShorebirdUpdateResult(
        status: ShorebirdUpdateCheckStatus.unavailable,
        message: 'Shorebird is not available in this build.',
      );
    }

    try {
      final status = await _updater.checkForUpdate();
      return ShorebirdUpdateResult(status: _mapStatus(status));
    } on UpdateException catch (error) {
      return ShorebirdUpdateResult(
        status: ShorebirdUpdateCheckStatus.unavailable,
        message: error.message,
      );
    } catch (error) {
      return ShorebirdUpdateResult(
        status: ShorebirdUpdateCheckStatus.unavailable,
        message: error.toString(),
      );
    }
  }

  Future<void> update() {
    return _updater.update();
  }

  ShorebirdUpdateCheckStatus _mapStatus(UpdateStatus status) {
    switch (status) {
      case UpdateStatus.outdated:
        return ShorebirdUpdateCheckStatus.outdated;
      case UpdateStatus.restartRequired:
        return ShorebirdUpdateCheckStatus.restartRequired;
      case UpdateStatus.upToDate:
        return ShorebirdUpdateCheckStatus.upToDate;
      case UpdateStatus.unavailable:
        return ShorebirdUpdateCheckStatus.unavailable;
    }
  }
}
