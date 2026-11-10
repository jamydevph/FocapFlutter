import 'dart:async';
import 'dart:typed_data';

import 'package:focapflutter/data/models/app_info.dart';
import 'package:focapflutter/data/models/native_session.dart';
import 'package:focapflutter/data/services/blocker/blocker_platform.dart';

class FakeBlockerPlatform implements BlockerPlatform {
  FakeBlockerPlatform({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final _accessibility = StreamController<bool>.broadcast();

  bool _accessibilityEnabled = false;
  final bool _notificationsEnabled = false;
  NativeSession? _session;

  static final apps = [
    AppInfo(
      packageName: 'com.facebook.katana',
      label: 'Facebook',
      icon: Uint8List(0),
    ),
    AppInfo(
      packageName: 'com.facebook.orca',
      label: 'Messenger',
      icon: Uint8List(0),
    ),
    AppInfo(
      packageName: 'com.instagram.android',
      label: 'Instagram',
      icon: Uint8List(0),
    ),
  ];

  void setAccessibilityEnabled(bool enabled) {
    _accessibilityEnabled = enabled;
    _accessibility.add(enabled);
  }

  @override
  Future<List<AppInfo>> getInstalledApps() async => apps;

  @override
  Future<bool> isAccessibilityEnabled() async => _accessibilityEnabled;

  @override
  Future<void> openAccessibilitySettings() async =>
      setAccessibilityEnabled(true);

  @override
  Future<bool> startSession({
    required String sessionId,
    required int endsAtMillis,
    required List<String> packages,
    required bool endSoundOn,
  }) async {
    _session = NativeSession(
      sessionId: sessionId,
      endsAtMillis: endsAtMillis,
      packages: List.unmodifiable(packages),
    );
    return true;
  }

  @override
  Future<void> endSession() async => _session = null;

  @override
  Future<NativeSession?> getActiveSession() async {
    final session = _session;
    if (session == null) return null;
    if (_clock().millisecondsSinceEpoch >= session.endsAtMillis) return null;
    return session;
  }

  @override
  Future<bool> requestNotificationPermission() async => _notificationsEnabled;

  @override
  Future<bool> canScheduleExactAlarms() async => true;

  @override
  Future<void> openExactAlarmSettings() async {}

  @override
  Future<bool> areNotificationsEnabled() async => _notificationsEnabled;

  @override
  Future<void> openNotificationSettings() async {}

  @override
  Stream<bool> get accessibilityChanged => _accessibility.stream;
}
