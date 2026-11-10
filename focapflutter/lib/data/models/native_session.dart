import 'package:freezed_annotation/freezed_annotation.dart';

part 'native_session.freezed.dart';

@freezed
abstract class NativeSession with _$NativeSession {
  const factory NativeSession({
    required String sessionId,
    required int endsAtMillis,
    required List<String> packages,
  }) = _NativeSession;
}
