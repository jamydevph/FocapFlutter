import 'package:focapflutter/data/models/session_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_session.freezed.dart';

@freezed
abstract class FocusSession with _$FocusSession {
  const factory FocusSession({
    required String id,
    required String userId,
    required String deviceId,
    required int durationMinutes,
    required int startedAt,
    required int endsAt,
    required SessionStatus status,
    required List<String> selectedPackages,
    required int appCount,
    required int updatedAt,
    int? endedAt,
    SessionEndReason? endReason,
    @Default(false) bool synced,
  }) = _FocusSession;
}
