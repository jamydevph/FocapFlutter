abstract final class AuthValidation {
  static const minPasswordLength = 8;
  static const maxNameLength = 50;

  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final _invisible = RegExp('[\u200B-\u200F\u2060\uFEFF]');
  static final _spaces = RegExp(r'\s+');

  static String normalizeName(String raw) =>
      raw.replaceAll(_invisible, '').trim().replaceAll(_spaces, ' ');

  static String? email(String trimmed) {
    if (trimmed.isEmpty) return 'Enter your email.';
    if (!_emailPattern.hasMatch(trimmed)) {
      return 'Enter a valid email, like you@example.com.';
    }
    return null;
  }

  static String? requiredName(String normalized, String which) {
    if (normalized.isEmpty) return 'Enter your $which name.';
    if (normalized.runes.length > maxNameLength) {
      return 'Keep it to $maxNameLength characters or fewer.';
    }
    return null;
  }

  static String? newPassword(String password) {
    if (password.isEmpty) return 'Create a password.';
    if (password.trim().isEmpty) return "A password can't be only spaces.";
    if (password.runes.length < minPasswordLength) {
      return 'Use at least $minPasswordLength characters.';
    }
    return null;
  }

  static String? confirmPassword(String password, String confirm) {
    if (confirm.isEmpty) return 'Confirm your password.';
    if (confirm != password) return 'Passwords don’t match.';
    return null;
  }
}
