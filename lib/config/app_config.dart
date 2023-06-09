class AppConfig {
  static const String mainUrl = "http://192.168.1.231:5000";
  static const String loginUrl = '$mainUrl/auth/login';
  static const String registerUrl = '$mainUrl/auth/register';
  static const String logoutUrl = '/auth/logout';
  static const String changePasswordUrl = '/user/change-password';
  static const String updateInfoUrl = '/user/update-info';
  static const String updateAvatarUrl = '/user/update-avatar';
  static const String getInfoUrl = '/user/get-info';
  static const String refreshTokenUrl  = '/auth/refresh-token';
}
