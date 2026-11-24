import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoService {
  Future<String> appVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.buildNumber.isEmpty
        ? info.version
        : '${info.version}+${info.buildNumber}';
  }
}
