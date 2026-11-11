import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/data/models/app_info.dart';
import 'package:focapflutter/data/services/blocker/blocker_platform.dart';
import 'package:focapflutter/data/services/blocker/blocker_platform_provider.dart';
import 'package:uuid/uuid.dart';

@immutable
class DebugCall {
  const DebugCall(this.name, this.run, {this.opensSystemScreen = false});

  final String name;
  final Future<Object?> Function(BlockerPlatform blocker) run;
  final bool opensSystemScreen;
}

@immutable
class DebugState {
  const DebugState({
    required this.platformName,
    this.results = const {},
    this.running = const {},
    this.lastAccessibilityEvent,
    this.installedApps = const [],
  });

  final String platformName;
  final Map<String, String> results;
  final Set<String> running;
  final String? lastAccessibilityEvent;
  final List<AppInfo> installedApps;

  DebugState copyWith({
    Map<String, String>? results,
    Set<String>? running,
    String? lastAccessibilityEvent,
    List<AppInfo>? installedApps,
  }) => DebugState(
    platformName: platformName,
    results: results ?? this.results,
    running: running ?? this.running,
    lastAccessibilityEvent:
        lastAccessibilityEvent ?? this.lastAccessibilityEvent,
    installedApps: installedApps ?? this.installedApps,
  );
}

class DebugViewModel extends Notifier<DebugState> {
  static const testSessionLength = Duration(minutes: 2);
  static const testPackage = 'com.jamydevph.stub';
  static const installedAppsCall = 'getInstalledApps';

  static final calls = <DebugCall>[
    DebugCall(installedAppsCall, (b) => b.getInstalledApps()),
    DebugCall('isAccessibilityEnabled', (b) => b.isAccessibilityEnabled()),
    DebugCall(
      'openAccessibilitySettings',
      (b) => b.openAccessibilitySettings(),
      opensSystemScreen: true,
    ),
    DebugCall(
      'startSession',
      (b) => b.startSession(
        sessionId: const Uuid().v4(),
        endsAtMillis: DateTime.now()
            .add(testSessionLength)
            .millisecondsSinceEpoch,
        packages: const [testPackage],
        endSoundOn: true,
      ),
    ),
    DebugCall('getActiveSession', (b) => b.getActiveSession()),
    DebugCall('endSession', (b) => b.endSession()),
    DebugCall(
      'requestNotificationPermission',
      (b) => b.requestNotificationPermission(),
      opensSystemScreen: true,
    ),
    DebugCall('canScheduleExactAlarms', (b) => b.canScheduleExactAlarms()),
    DebugCall(
      'openExactAlarmSettings',
      (b) => b.openExactAlarmSettings(),
      opensSystemScreen: true,
    ),
    DebugCall('areNotificationsEnabled', (b) => b.areNotificationsEnabled()),
    DebugCall(
      'openNotificationSettings',
      (b) => b.openNotificationSettings(),
      opensSystemScreen: true,
    ),
  ];

  @override
  DebugState build() {
    final blocker = ref.watch(blockerPlatformProvider);
    final subscription = blocker.accessibilityChanged.listen(
      (enabled) => state = state.copyWith(lastAccessibilityEvent: '$enabled'),
      onError: (Object error) =>
          state = state.copyWith(lastAccessibilityEvent: 'error: $error'),
    );
    ref.onDispose(subscription.cancel);
    return DebugState(platformName: '${blocker.runtimeType}');
  }

  Future<void> run(DebugCall call) async {
    if (!ref.mounted) return;
    final blocker = ref.read(blockerPlatformProvider);
    state = state.copyWith(running: {...state.running, call.name});
    String outcome;
    List<AppInfo>? apps;
    if (call.name == installedAppsCall) apps = const [];
    try {
      final value = await call.run(blocker);
      if (value is List<AppInfo>) apps = value;
      outcome = 'ok: ${_describe(value)}';
    } on Object catch (error) {
      outcome = 'error: $error';
    }
    if (!ref.mounted) return;
    state = state.copyWith(
      results: {...state.results, call.name: outcome},
      running: {...state.running}..remove(call.name),
      installedApps: apps,
    );
  }

  Future<void> runAll() async {
    for (final call in calls.where((call) => !call.opensSystemScreen)) {
      if (!ref.mounted) return;
      await run(call);
    }
  }

  String _describe(Object? value) => switch (value) {
    null => 'null',
    List<Object?>(length: final count) when count > 3 =>
      '$count items, first ${value.first}',
    _ => '$value',
  };
}

final debugViewModelProvider =
    NotifierProvider.autoDispose<DebugViewModel, DebugState>(
      DebugViewModel.new,
    );
