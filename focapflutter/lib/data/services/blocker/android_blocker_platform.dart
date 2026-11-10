import 'package:flutter/services.dart';
import 'package:focapflutter/data/models/app_info.dart';
import 'package:focapflutter/data/models/native_session.dart';
import 'package:focapflutter/data/services/blocker/blocker_platform.dart';

class AndroidBlockerPlatform implements BlockerPlatform {
  AndroidBlockerPlatform({
    this.methods = const MethodChannel(methodChannelName),
    this.events = const EventChannel(eventChannelName),
  });

  static const methodChannelName = 'focap/blocker';
  static const eventChannelName = 'focap/blocker/events';
  static const accessibilityChangedEvent = 'accessibilityChanged';

  final MethodChannel methods;
  final EventChannel events;

  late final Stream<Map<Object?, Object?>> _nativeEvents = events
      .receiveBroadcastStream()
      .where((event) => event is Map<Object?, Object?>)
      .cast<Map<Object?, Object?>>();

  @override
  Future<List<AppInfo>> getInstalledApps() async {
    final raw = await methods.invokeListMethod<Object?>('getInstalledApps');
    return [
      for (final entry in raw ?? const <Object?>[])
        _appInfoFrom(entry! as Map<Object?, Object?>),
    ];
  }

  @override
  Future<bool> isAccessibilityEnabled() => _bool('isAccessibilityEnabled');

  @override
  Future<void> openAccessibilitySettings() =>
      methods.invokeMethod<void>('openAccessibilitySettings');

  @override
  Future<bool> startSession({
    required String sessionId,
    required int endsAtMillis,
    required List<String> packages,
    required bool endSoundOn,
  }) => _bool('startSession', {
    'sessionId': sessionId,
    'endsAtMillis': endsAtMillis,
    'packages': packages,
    'endSoundOn': endSoundOn,
  });

  @override
  Future<void> endSession() => methods.invokeMethod<void>('endSession');

  @override
  Future<NativeSession?> getActiveSession() async {
    final raw = await methods.invokeMapMethod<Object?, Object?>(
      'getActiveSession',
    );
    if (raw == null) return null;
    return NativeSession(
      sessionId: raw['sessionId']! as String,
      endsAtMillis: raw['endsAtMillis']! as int,
      packages: [
        for (final name in raw['packages']! as List<Object?>) name! as String,
      ],
    );
  }

  @override
  Future<bool> requestNotificationPermission() =>
      _bool('requestNotificationPermission');

  @override
  Future<bool> canScheduleExactAlarms() => _bool('canScheduleExactAlarms');

  @override
  Future<void> openExactAlarmSettings() =>
      methods.invokeMethod<void>('openExactAlarmSettings');

  @override
  Future<bool> areNotificationsEnabled() => _bool('areNotificationsEnabled');

  @override
  Future<void> openNotificationSettings() =>
      methods.invokeMethod<void>('openNotificationSettings');

  @override
  Stream<bool> get accessibilityChanged => _nativeEvents
      .where(
        (event) =>
            event['type'] == accessibilityChangedEvent &&
            event['value'] is bool,
      )
      .map((event) => event['value']! as bool);

  Future<bool> _bool(String method, [Object? arguments]) async {
    final value = await methods.invokeMethod<bool>(method, arguments);
    if (value == null) {
      throw StateError('$method returned null instead of a bool');
    }
    return value;
  }

  AppInfo _appInfoFrom(Map<Object?, Object?> entry) => AppInfo(
    packageName: entry['packageName']! as String,
    label: entry['label']! as String,
    icon: entry['icon'] as Uint8List? ?? Uint8List(0),
  );
}
