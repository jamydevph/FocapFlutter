import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/permissions/accessibility_status.dart';

@immutable
class PermissionsState {
  const PermissionsState({
    this.helpOpen = true,
    this.opening = false,
    this.failureMessage,
  });

  final bool helpOpen;
  final bool opening;
  final String? failureMessage;

  PermissionsState copyWith({
    bool? helpOpen,
    bool? opening,
    String? failureMessage,
    bool clearFailure = false,
  }) => PermissionsState(
    helpOpen: helpOpen ?? this.helpOpen,
    opening: opening ?? this.opening,
    failureMessage: clearFailure ? null : failureMessage ?? this.failureMessage,
  );
}

class PermissionsViewModel extends Notifier<PermissionsState> {
  static const openFailedMessage =
      'Couldn’t open Accessibility settings. Open Settings → Accessibility → '
      'Focap yourself.';

  @override
  PermissionsState build() => const PermissionsState();

  void toggleHelp() => state = state.copyWith(helpOpen: !state.helpOpen);

  Future<void> openSettings() async {
    if (state.opening) return;
    state = state.copyWith(opening: true, clearFailure: true);
    final opened = await ref
        .read(permissionRepositoryProvider)
        .openAccessibilitySettings();
    if (!ref.mounted) return;
    state = state.copyWith(
      opening: false,
      failureMessage: opened ? null : openFailedMessage,
    );
  }
}

final permissionsViewModelProvider =
    NotifierProvider.autoDispose<PermissionsViewModel, PermissionsState>(
      PermissionsViewModel.new,
    );
