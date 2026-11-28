import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/data/repositories/permission_repository.dart';
import 'package:focapflutter/data/services/blocker/blocker_platform_provider.dart';

final permissionRepositoryProvider = Provider<PermissionRepository>(
  (ref) => PermissionRepository(ref.watch(blockerPlatformProvider)),
);

final initialAccessibilityProvider = Provider<bool>((ref) => false);

class AccessibilityStatus extends Notifier<bool> {
  var _version = 0;

  @override
  bool build() {
    final repository = ref.watch(permissionRepositoryProvider);
    final subscription = repository.accessibilityChanged.listen((enabled) {
      _version++;
      state = enabled;
    }, onError: (Object _) => unawaited(refresh()));
    final lifecycle = AppLifecycleListener(
      onResume: () => unawaited(refresh()),
    );
    ref.onDispose(() {
      subscription.cancel();
      lifecycle.dispose();
    });
    return ref.read(initialAccessibilityProvider);
  }

  Future<void> refresh() async {
    final version = ++_version;
    final enabled = await ref
        .read(permissionRepositoryProvider)
        .isAccessibilityEnabled();
    if (!ref.mounted || version != _version) return;
    state = enabled;
  }
}

final accessibilityEnabledProvider =
    NotifierProvider<AccessibilityStatus, bool>(AccessibilityStatus.new);
