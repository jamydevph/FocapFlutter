import 'package:flutter/material.dart' show ThemeMode;
import 'package:focapflutter/data/models/app_info.dart';
import 'package:focapflutter/data/models/native_session.dart';

abstract interface class BlockerPlatform {
  Future<List<AppInfo>> getInstalledApps();

  Future<bool> isAccessibilityEnabled();

  Future<void> openAccessibilitySettings();

  Future<bool> startSession({
    required String sessionId,
    required int endsAtMillis,
    required List<String> packages,
    required bool endSoundOn,
    required ThemeMode themeMode,
  });

  Future<void> endSession();

  Future<NativeSession?> getActiveSession();

  Future<bool> requestNotificationPermission();

  Future<bool> canScheduleExactAlarms();

  Future<void> openExactAlarmSettings();

  Future<bool> areNotificationsEnabled();

  Future<void> openNotificationSettings();

  Stream<bool> get accessibilityChanged;
}
