import 'dart:async';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/core/theme/theme_mode_provider.dart';
import 'package:focapflutter/data/models/app_info.dart';
import 'package:focapflutter/data/models/auth_failure.dart';
import 'package:focapflutter/data/repositories/account_repository_provider.dart';
import 'package:focapflutter/data/repositories/auth_repository_provider.dart';
import 'package:focapflutter/data/services/blocker/android_blocker_platform.dart';
import 'package:focapflutter/data/services/blocker/blocker_platform.dart';
import 'package:focapflutter/data/services/blocker/blocker_platform_provider.dart';
import 'package:uuid/uuid.dart';

@immutable
class DebugCall {
  const DebugCall(this.name, this.run, {this.opensSystemScreen = false});

  final String name;
  final Future<Object?> Function(BlockerPlatform blocker, ThemeMode themeMode)
  run;
  final bool opensSystemScreen;
}

@immutable
class DebugState {
  const DebugState({
    required this.platformName,
    this.account = 'checking…',
    this.signingOut = false,
    this.results = const {},
    this.running = const {},
    this.accessibilityService,
    this.lastAccessibilityEvent,
    this.installedApps = const [],
  });

  final String platformName;
  final String account;
  final bool signingOut;
  final Map<String, String> results;
  final Set<String> running;
  final String? accessibilityService;
  final String? lastAccessibilityEvent;
  final List<AppInfo> installedApps;

  DebugState copyWith({
    String? account,
    bool? signingOut,
    Map<String, String>? results,
    Set<String>? running,
    String? accessibilityService,
    String? lastAccessibilityEvent,
    List<AppInfo>? installedApps,
  }) => DebugState(
    platformName: platformName,
    account: account ?? this.account,
    signingOut: signingOut ?? this.signingOut,
    results: results ?? this.results,
    running: running ?? this.running,
    accessibilityService: accessibilityService ?? this.accessibilityService,
    lastAccessibilityEvent:
        lastAccessibilityEvent ?? this.lastAccessibilityEvent,
    installedApps: installedApps ?? this.installedApps,
  );
}

class DebugViewModel extends Notifier<DebugState> {
  static const testSessionLength = Duration(minutes: 2);
  static const testPackage = 'com.google.android.calendar';
  static const neverBlockableTestPackage = 'com.android.settings';
  static const badArgumentsCode = 'bad_arguments';
  static const installedAppsCall = 'getInstalledApps';

  static final calls = <DebugCall>[
    DebugCall(installedAppsCall, (b, _) => b.getInstalledApps()),
    DebugCall('isAccessibilityEnabled', (b, _) => b.isAccessibilityEnabled()),
    DebugCall(
      'openAccessibilitySettings',
      (b, _) => b.openAccessibilitySettings(),
      opensSystemScreen: true,
    ),
    DebugCall(
      'startSession',
      (b, themeMode) => b.startSession(
        sessionId: const Uuid().v4(),
        endsAtMillis: DateTime.now()
            .add(testSessionLength)
            .millisecondsSinceEpoch,
        packages: const [testPackage, neverBlockableTestPackage],
        endSoundOn: true,
        themeMode: themeMode,
      ),
    ),
    DebugCall(
      'startSession with no arguments',
      (b, _) => _startWithNoArguments(b),
    ),
    DebugCall('getActiveSession', (b, _) => b.getActiveSession()),
    DebugCall('endSession', (b, _) => b.endSession()),
    DebugCall(
      'requestNotificationPermission',
      (b, _) => b.requestNotificationPermission(),
      opensSystemScreen: true,
    ),
    DebugCall('canScheduleExactAlarms', (b, _) => b.canScheduleExactAlarms()),
    DebugCall(
      'openExactAlarmSettings',
      (b, _) => b.openExactAlarmSettings(),
      opensSystemScreen: true,
    ),
    DebugCall('areNotificationsEnabled', (b, _) => b.areNotificationsEnabled()),
    DebugCall(
      'openNotificationSettings',
      (b, _) => b.openNotificationSettings(),
      opensSystemScreen: true,
    ),
  ];

  static Future<String?> _startWithNoArguments(BlockerPlatform blocker) async {
    if (blocker is! AndroidBlockerPlatform) {
      return 'skipped on ${blocker.runtimeType}';
    }
    try {
      await blocker.methods.invokeMethod<bool>('startSession');
    } on PlatformException catch (error) {
      if (error.code == badArgumentsCode) return error.message;
      rethrow;
    }
    throw StateError('startSession accepted a call with no arguments');
  }

  @override
  DebugState build() {
    final blocker = ref.watch(blockerPlatformProvider);
    final subscription = blocker.accessibilityChanged.listen(
      (enabled) => state = state.copyWith(
        accessibilityService: _onOff(enabled),
        lastAccessibilityEvent: '$enabled at ${_clockTime()}',
      ),
      onError: (Object error) =>
          state = state.copyWith(lastAccessibilityEvent: 'error: $error'),
    );
    final lifecycle = AppLifecycleListener(
      onResume: () {
        refreshAccessibility();
        refreshAccount();
      },
    );
    ref.onDispose(() {
      subscription.cancel();
      lifecycle.dispose();
    });
    Future.microtask(refreshAccessibility);
    return DebugState(
      platformName: '${blocker.runtimeType}',
      account: _describeAccount(),
    );
  }

  String _describeAccount() {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return 'signed out';
    final sync = ref.read(accountRepositoryProvider).lastSync?.name;
    return '${user.email ?? 'no email'} (${user.uid}), '
        'last sync: ${sync ?? 'none yet'}';
  }

  void refreshAccount() {
    if (!ref.mounted) return;
    state = state.copyWith(account: _describeAccount());
  }

  Future<void> signOut() async {
    if (!ref.mounted || state.signingOut) return;
    state = state.copyWith(signingOut: true);
    String? failure;
    try {
      await ref.read(authRepositoryProvider).signOut();
    } on AuthException catch (error) {
      failure = error.failure.name;
    } on Object catch (error) {
      failure = '$error';
    }
    if (!ref.mounted) return;
    state = state.copyWith(
      signingOut: false,
      account: failure == null
          ? _describeAccount()
          : 'sign out failed: $failure',
    );
  }

  Future<void> refreshAccessibility() async {
    if (!ref.mounted) return;
    final blocker = ref.read(blockerPlatformProvider);
    String reading;
    try {
      reading = _onOff(await blocker.isAccessibilityEnabled());
    } on Object catch (error) {
      reading = 'error: $error';
    }
    if (!ref.mounted) return;
    state = state.copyWith(accessibilityService: reading);
  }

  String _onOff(bool enabled) => enabled ? 'on' : 'off';

  String _clockTime() => DateTime.now().toIso8601String().substring(11, 19);

  Future<void> run(DebugCall call) async {
    if (!ref.mounted) return;
    final blocker = ref.read(blockerPlatformProvider);
    state = state.copyWith(running: {...state.running, call.name});
    String outcome;
    List<AppInfo>? apps;
    if (call.name == installedAppsCall) apps = const [];
    try {
      final value = await call.run(blocker, ref.read(themeModeProvider));
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
