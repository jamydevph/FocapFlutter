enum SessionStatus {
  pending,
  active,
  completed,
  cancelled,
  failed;

  bool get isFinished => switch (this) {
    completed || cancelled || failed => true,
    pending || active => false,
  };

  static SessionStatus? tryParse(String value) => values.asNameMap()[value];
}

enum SessionEndReason {
  expired('expired'),
  userCancelled('user_cancelled'),
  startFailed('start_failed');

  const SessionEndReason(this.value);

  final String value;

  static SessionEndReason? tryParse(String? value) {
    for (final reason in values) {
      if (reason.value == value) return reason;
    }
    return null;
  }
}
