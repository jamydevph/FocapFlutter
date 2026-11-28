import 'package:focapflutter/data/models/app_info.dart';
import 'package:focapflutter/data/services/blocker/blocker_platform.dart';

class InstalledAppsRepository {
  InstalledAppsRepository(this._blocker);

  final BlockerPlatform _blocker;

  List<AppInfo>? _cached;

  List<AppInfo>? get cached => _cached;

  Future<List<AppInfo>> load() async {
    final apps = await _blocker.getInstalledApps();
    _cached = List.unmodifiable(apps);
    return _cached!;
  }
}
