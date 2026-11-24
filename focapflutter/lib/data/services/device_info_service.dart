import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  DeviceInfoService({DeviceInfoPlugin? plugin})
    : _plugin = plugin ?? DeviceInfoPlugin();

  final DeviceInfoPlugin _plugin;

  Future<String> deviceName() async {
    final info = await _plugin.androidInfo;
    final manufacturer = info.manufacturer.trim();
    final model = info.model.trim();
    if (model.toLowerCase().startsWith(manufacturer.toLowerCase())) {
      return model;
    }
    return '$manufacturer $model'.trim();
  }
}
