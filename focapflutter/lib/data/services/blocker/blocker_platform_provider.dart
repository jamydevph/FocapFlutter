import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focapflutter/data/services/blocker/android_blocker_platform.dart';
import 'package:focapflutter/data/services/blocker/blocker_platform.dart';
import 'package:focapflutter/data/services/blocker/fake_blocker_platform.dart';

final blockerPlatformProvider = Provider<BlockerPlatform>((ref) {
  if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
    return AndroidBlockerPlatform();
  }
  return FakeBlockerPlatform();
});
