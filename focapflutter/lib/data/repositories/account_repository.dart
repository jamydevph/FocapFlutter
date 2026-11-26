import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:focapflutter/data/models/user_profile.dart';
import 'package:focapflutter/data/services/auth_service.dart';
import 'package:focapflutter/data/services/device_info_service.dart';
import 'package:focapflutter/data/services/firestore_service.dart';
import 'package:focapflutter/data/services/local_database.dart';
import 'package:focapflutter/data/services/package_info_service.dart';
import 'package:focapflutter/data/services/preferences_service.dart';
import 'package:uuid/uuid.dart';

@immutable
class SavedNames {
  const SavedNames({this.firstName, this.lastName});

  final String? firstName;
  final String? lastName;

  bool get isComplete =>
      (firstName?.isNotEmpty ?? false) && (lastName?.isNotEmpty ?? false);

  @override
  bool operator ==(Object other) =>
      other is SavedNames &&
      other.firstName == firstName &&
      other.lastName == lastName;

  @override
  int get hashCode => Object.hash(firstName, lastName);
}

enum AccountSync { synced, offline, lost, superseded }

class AccountRepository {
  AccountRepository({
    required this._auth,
    required this._firestore,
    required this._preferences,
    required this._database,
    required this._deviceInfo,
    required this._packageInfo,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const deviceIdKey = 'device_id';
  static const userIdKey = 'user_id';
  static const firstNameKey = 'first_name';
  static const lastNameKey = 'last_name';

  static const _platform = 'android';
  static const _lostSessionCodes = {
    'user-not-found',
    'user-disabled',
    'user-token-expired',
  };

  final AuthService _auth;
  final FirestoreService _firestore;
  final PreferencesService _preferences;
  final LocalDatabase _database;
  final DeviceInfoService _deviceInfo;
  final PackageInfoService _packageInfo;
  final DateTime Function() _clock;
  final _namesController = StreamController<SavedNames>.broadcast();

  AccountSync? lastSync;
  var _generation = 0;
  Future<AccountSync> _queue = Future.value(AccountSync.synced);

  SavedNames get savedNames {
    final owner = _database.meta(userIdKey);
    if (owner == null || owner != _auth.currentUser?.uid) {
      return const SavedNames();
    }
    return SavedNames(
      firstName: _database.meta(firstNameKey),
      lastName: _database.meta(lastNameKey),
    );
  }

  Stream<SavedNames> get savedNamesChanges => _namesController.stream;

  static Future<void> moveLegacyAccountValues(
    PreferencesService preferences,
    LocalDatabase database,
  ) async {
    final legacy = preferences.legacyAccountValues();
    if (legacy.isEmpty) return;
    final moved = <String, String>{};
    final legacyDevice = legacy[deviceIdKey];
    if (legacyDevice != null && database.meta(deviceIdKey) == null) {
      moved[deviceIdKey] = legacyDevice;
    }
    final legacyUser = legacy[userIdKey];
    final metaUser = database.meta(userIdKey);
    if (legacyUser != null && (metaUser == null || metaUser == legacyUser)) {
      moved[userIdKey] = legacyUser;
      for (final key in const [firstNameKey, lastNameKey]) {
        final value = legacy[key];
        if (value != null && database.meta(key) == null) moved[key] = value;
      }
    }
    await database.setMeta(moved);
    await preferences.removeLegacyAccountValues();
  }

  bool get loggedInHint => _preferences.loggedIn;

  Future<void> clearLoggedIn() => _preferences.setLoggedIn(false);

  Future<AccountSync> completeSignIn(UserProfile user) =>
      _run((still) => _syncSignedIn(user, still));

  Future<AccountSync> completeRegister(
    UserProfile user, {
    required String firstName,
    required String lastName,
  }) => _run(
    (still) => _syncSignedIn(
      user,
      still,
      registeredNames: SavedNames(firstName: firstName, lastName: lastName),
    ),
  );

  bool _isCurrent(UserProfile user) => _auth.currentUser?.uid == user.uid;

  Future<AccountSync> _syncSignedIn(
    UserProfile user,
    bool Function() still, {
    SavedNames? registeredNames,
  }) async {
    bool stale() => !still() || !_isCurrent(user);

    if (stale()) return AccountSync.superseded;
    final sameUser = _database.meta(userIdKey) == user.uid;
    if (!sameUser) {
      await _database.deleteMeta(const [firstNameKey, lastNameKey]);
      _publishNames();
    }
    final deviceId = await _ensureDeviceId();
    if (stale()) return AccountSync.superseded;
    await _database.setMeta({userIdKey: user.uid});
    if (registeredNames != null) {
      await _saveNames(registeredNames);
    }
    if (stale()) return AccountSync.superseded;
    await _preferences.setLoggedIn(true);

    if (registeredNames != null) {
      await _writeRegisteredProfile(user, registeredNames, stale);
    } else {
      final sync = await _refreshProfile(user, stale);
      if (sync != AccountSync.synced) return sync;
    }
    if (stale()) return AccountSync.superseded;
    return _upsertDevice(user.uid, deviceId);
  }

  Future<void> _writeRegisteredProfile(
    UserProfile user,
    SavedNames names,
    bool Function() stale,
  ) async {
    try {
      await _auth.updateDisplayName('${names.firstName} ${names.lastName}');
    } on AuthServiceException catch (error, stack) {
      _report(error, stack, 'saving the display name');
    }
    if (stale()) return;
    try {
      await _firestore.createUser(user.uid, _profileDoc(user, names));
    } on FirestoreServiceException catch (error, stack) {
      _report(error, stack, 'writing the profile at sign-up');
    }
  }

  Future<AccountSync> _refreshProfile(
    UserProfile user,
    bool Function() stale,
  ) async {
    try {
      await _auth.reloadCurrentUser();
    } on AuthServiceException catch (error) {
      if (stale()) return AccountSync.superseded;
      if (_lostSessionCodes.contains(error.code)) {
        await _auth.signOut();
        return AccountSync.lost;
      }
      return AccountSync.offline;
    }
    if (stale()) return AccountSync.superseded;

    final Map<String, Object?>? doc;
    try {
      doc = await _firestore.readUser(user.uid);
    } on FirestoreServiceException {
      return AccountSync.offline;
    }
    if (stale()) return AccountSync.superseded;

    final remote = SavedNames(
      firstName: _text(doc?['firstName']),
      lastName: _text(doc?['lastName']),
    );
    if (doc != null) {
      if (remote.isComplete) await _saveNames(remote);
      return AccountSync.synced;
    }

    final local = savedNames;
    if (local.isComplete) {
      try {
        await _firestore.createUser(user.uid, _profileDoc(user, local));
      } on FirestoreServiceException {
        return AccountSync.offline;
      }
    }
    return AccountSync.synced;
  }

  Future<AccountSync> _upsertDevice(String uid, String deviceId) async {
    final now = _clock().millisecondsSinceEpoch;
    try {
      await _firestore.upsertDevice(
        uid,
        deviceId,
        fields: {
          'deviceName': await _deviceInfo.deviceName(),
          'platform': _platform,
          'appVersion': await _packageInfo.appVersion(),
          'lastActiveAt': now,
        },
        createOnlyFields: {'createdAt': now},
      );
    } on FirestoreServiceException {
      return AccountSync.offline;
    }
    return AccountSync.synced;
  }

  Map<String, Object?> _profileDoc(UserProfile user, SavedNames names) {
    final now = _clock().millisecondsSinceEpoch;
    return {
      'email': user.email ?? '',
      'firstName': names.firstName,
      'lastName': names.lastName,
      'createdAt': now,
      'updatedAt': now,
    };
  }

  Future<String> _ensureDeviceId() async {
    final existing = _database.meta(deviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final created = const Uuid().v4();
    await _database.setMeta({deviceIdKey: created});
    return created;
  }

  Future<void> _saveNames(SavedNames names) async {
    await _database.setMeta({
      firstNameKey: names.firstName ?? '',
      lastNameKey: names.lastName ?? '',
    });
    _publishNames();
  }

  void _publishNames() => _namesController.add(savedNames);

  String? _text(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<AccountSync> _run(
    Future<AccountSync> Function(bool Function() still) sync,
  ) {
    final generation = ++_generation;
    bool still() => generation == _generation;
    final next = _queue.then((_) async {
      AccountSync result;
      try {
        result = await sync(still);
      } on Object catch (error, stack) {
        _report(error, stack, 'syncing the account');
        result = AccountSync.offline;
      }
      if (result != AccountSync.superseded) lastSync = result;
      return result;
    });
    _queue = next;
    return next;
  }

  void _report(Object error, StackTrace stack, String action) =>
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'account repository',
          context: ErrorDescription('while $action'),
        ),
      );

  void dispose() => _namesController.close();
}
