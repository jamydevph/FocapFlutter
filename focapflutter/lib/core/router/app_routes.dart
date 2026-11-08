abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const permissions = '/permissions';
  static const dashboard = '/dashboard';
  static const apps = '/apps';
  static const session = '/session';
  static const history = '/history';
  static const settings = '/settings';
  static const editProfile = '/edit-profile';
  static const debugTokens = '/debug/tokens';

  static const public = {login, register, forgotPassword};
}
