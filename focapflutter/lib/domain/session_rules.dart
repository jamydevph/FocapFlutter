import 'package:focapflutter/data/models/focus_session.dart';
import 'package:focapflutter/data/models/session_status.dart';

class SessionRuleException implements Exception {
  const SessionRuleException(this.message);

  final String message;

  @override
  String toString() => 'SessionRuleException: $message';
}

abstract final class SessionRules {
  static const minDurationMinutes = 5;
  static const debugMinDurationMinutes = 1;
  static const maxDurationMinutes = 240;

  static FocusSession pending({
    required String id,
    required String userId,
    required String deviceId,
    required int durationMinutes,
    required List<String> packages,
    required int now,
    bool allowDebugDuration = false,
  }) => _newSession(
    id: id,
    userId: userId,
    deviceId: deviceId,
    durationMinutes: durationMinutes,
    packages: packages,
    now: now,
    status: SessionStatus.pending,
    allowDebugDuration: allowDebugDuration,
  );

  static FocusSession refused({
    required String id,
    required String userId,
    required String deviceId,
    required int durationMinutes,
    required List<String> packages,
    required int now,
    bool allowDebugDuration = false,
  }) => _newSession(
    id: id,
    userId: userId,
    deviceId: deviceId,
    durationMinutes: durationMinutes,
    packages: packages,
    now: now,
    status: SessionStatus.failed,
    allowDebugDuration: allowDebugDuration,
  ).copyWith(endedAt: now, endReason: SessionEndReason.startFailed);

  static FocusSession activate(FocusSession session, {required int now}) {
    _require(
      session,
      SessionStatus.active,
      from: const {SessionStatus.pending},
    );
    return session.copyWith(
      status: SessionStatus.active,
      updatedAt: now,
      synced: false,
    );
  }

  static FocusSession failStart(FocusSession session, {required int now}) {
    _require(
      session,
      SessionStatus.failed,
      from: const {SessionStatus.pending},
    );
    return _finish(
      session,
      SessionStatus.failed,
      SessionEndReason.startFailed,
      endedAt: now,
      now: now,
    );
  }

  static FocusSession cancel(FocusSession session, {required int now}) {
    _require(
      session,
      SessionStatus.cancelled,
      from: const {SessionStatus.active},
    );
    if (now >= session.endsAt) return expire(session, now: now);
    return _finish(
      session,
      SessionStatus.cancelled,
      SessionEndReason.userCancelled,
      endedAt: now,
      now: now,
    );
  }

  static FocusSession expire(FocusSession session, {required int now}) {
    _require(
      session,
      SessionStatus.completed,
      from: const {SessionStatus.active},
    );
    if (now < session.endsAt) {
      throw SessionRuleException(
        'active → completed isn’t allowed before endsAt '
        '(${session.endsAt - now} ms left)',
      );
    }
    return _finish(
      session,
      SessionStatus.completed,
      SessionEndReason.expired,
      endedAt: session.endsAt,
      now: now,
    );
  }

  static FocusSession reconcile(
    FocusSession session, {
    required String? nativeSessionId,
    required int now,
  }) {
    final nativeHasIt = nativeSessionId == session.id;
    return switch (session.status) {
      SessionStatus.pending when !nativeHasIt => failStart(session, now: now),
      SessionStatus.pending when now >= session.endsAt => expire(
        activate(session, now: now),
        now: now,
      ),
      SessionStatus.pending => activate(session, now: now),
      SessionStatus.active when now >= session.endsAt => expire(
        session,
        now: now,
      ),
      SessionStatus.active when !nativeHasIt => cancel(session, now: now),
      _ => session,
    };
  }

  static bool isRunning(FocusSession session, {required int now}) =>
      session.status == SessionStatus.active && now < session.endsAt;

  static Duration remaining(FocusSession session, {required int now}) {
    if (!isRunning(session, now: now)) return Duration.zero;
    return Duration(milliseconds: session.endsAt - now);
  }

  static int focusedMinutes(FocusSession session) {
    final ended = session.endedAt;
    if (ended == null || session.status == SessionStatus.failed) return 0;
    return ((ended - session.startedAt) / Duration.millisecondsPerMinute)
        .floor()
        .clamp(0, session.durationMinutes);
  }

  static FocusSession _newSession({
    required String id,
    required String userId,
    required String deviceId,
    required int durationMinutes,
    required List<String> packages,
    required int now,
    required SessionStatus status,
    required bool allowDebugDuration,
  }) {
    final shortest = allowDebugDuration
        ? debugMinDurationMinutes
        : minDurationMinutes;
    if (durationMinutes < shortest || durationMinutes > maxDurationMinutes) {
      throw SessionRuleException(
        'a session lasts $shortest to $maxDurationMinutes minutes, '
        'not $durationMinutes',
      );
    }
    final unique = {
      for (final package in packages)
        if (package.trim().isNotEmpty) package.trim(),
    }.toList();
    if (unique.isEmpty) {
      throw const SessionRuleException('a session needs at least one app');
    }
    return FocusSession(
      id: id,
      userId: userId,
      deviceId: deviceId,
      durationMinutes: durationMinutes,
      startedAt: now,
      endsAt: now + durationMinutes * Duration.millisecondsPerMinute,
      status: status,
      selectedPackages: List.unmodifiable(unique),
      appCount: unique.length,
      updatedAt: now,
    );
  }

  static FocusSession _finish(
    FocusSession session,
    SessionStatus status,
    SessionEndReason reason, {
    required int endedAt,
    required int now,
  }) => session.copyWith(
    status: status,
    endReason: reason,
    endedAt: endedAt,
    updatedAt: now,
    synced: false,
  );

  static void _require(
    FocusSession session,
    SessionStatus to, {
    required Set<SessionStatus> from,
  }) {
    if (!from.contains(session.status)) {
      throw SessionRuleException(
        '${session.status.name} → ${to.name} isn’t allowed',
      );
    }
  }
}
