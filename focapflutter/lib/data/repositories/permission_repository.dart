import 'package:flutter/foundation.dart';
import 'package:focapflutter/data/services/blocker/blocker_platform.dart';

class PermissionRepository {
  PermissionRepository(this._blocker);

  final BlockerPlatform _blocker;

  Stream<bool> get accessibilityChanged => _blocker.accessibilityChanged;

  Future<bool> isAccessibilityEnabled() async {
    try {
      return await _blocker.isAccessibilityEnabled();
    } on Object catch (error, stack) {
      _report(error, stack, 'reading the Accessibility switch');
      return false;
    }
  }

  Future<bool> openAccessibilitySettings() async {
    try {
      await _blocker.openAccessibilitySettings();
      return true;
    } on Object catch (error, stack) {
      _report(error, stack, 'opening Accessibility settings');
      return false;
    }
  }

  void _report(Object error, StackTrace stack, String action) =>
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'permission repository',
          context: ErrorDescription('while $action'),
        ),
      );
}
