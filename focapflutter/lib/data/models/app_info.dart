
import 'package:flutter/foundation.dart';

@immutable
class AppInfo {
  const AppInfo({
    required this.packageName,
    required this.label,
    required this.icon,
  });

  final String packageName;
  final String label;
  final Uint8List icon;

  @override
  bool operator ==(Object other) =>
      other is AppInfo &&
      other.packageName == packageName &&
      other.label == label;

  @override
  int get hashCode => Object.hash(packageName, label);

  @override
  String toString() =>
      'AppInfo($packageName, $label, icon: ${icon.length} bytes)';
}
