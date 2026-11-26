import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService(this._prefs);

  static const loggedInKey = 'logged_in';

  static const legacyAccountKeys = [
    'first_name',
    'last_name',
    'device_id',
    'user_id',
  ];

  static const keys = {loggedInKey, ...legacyAccountKeys};

  static Future<PreferencesService> open() async => PreferencesService(
    await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(allowList: keys),
    ),
  );

  final SharedPreferencesWithCache _prefs;

  bool get loggedIn => _prefs.getBool(loggedInKey) ?? false;

  Future<void> setLoggedIn(bool value) => _prefs.setBool(loggedInKey, value);

  Map<String, String> legacyAccountValues() => {
    for (final key in legacyAccountKeys) key: ?_prefs.getString(key),
  };

  Future<void> removeLegacyAccountValues() async {
    for (final key in legacyAccountKeys) {
      await _prefs.remove(key);
    }
  }
}
