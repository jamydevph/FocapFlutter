import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService(this._prefs);

  static const loggedInKey = 'logged_in';
  static const deviceIdKey = 'device_id';
  static const userIdKey = 'user_id';
  static const firstNameKey = 'first_name';
  static const lastNameKey = 'last_name';

  static const keys = {
    loggedInKey,
    deviceIdKey,
    userIdKey,
    firstNameKey,
    lastNameKey,
  };

  static Future<PreferencesService> open() async => PreferencesService(
    await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(allowList: keys),
    ),
  );

  final SharedPreferencesWithCache _prefs;

  bool get loggedIn => _prefs.getBool(loggedInKey) ?? false;

  Future<void> setLoggedIn(bool value) => _prefs.setBool(loggedInKey, value);

  String? get deviceId => _prefs.getString(deviceIdKey);

  Future<void> setDeviceId(String value) =>
      _prefs.setString(deviceIdKey, value);

  String? get userId => _prefs.getString(userIdKey);

  Future<void> setUserId(String value) => _prefs.setString(userIdKey, value);

  String? get firstName => _prefs.getString(firstNameKey);

  String? get lastName => _prefs.getString(lastNameKey);

  Future<void> setNames({
    required String firstName,
    required String lastName,
  }) async {
    await _prefs.setString(firstNameKey, firstName);
    await _prefs.setString(lastNameKey, lastName);
  }

  Future<void> clearNames() async {
    await _prefs.remove(firstNameKey);
    await _prefs.remove(lastNameKey);
  }
}
