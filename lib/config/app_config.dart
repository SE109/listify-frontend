class AppConfig {
  static const String mainUrl = "http://10.0.2.2:5000";
  static const String loginUrl = '$mainUrl/auth/login';
  static const String registerUrl = '$mainUrl/auth/register';
  static const String logoutUrl = '$mainUrl/auth/logout';
  static const String changePasswordUrl = '$mainUrl/user/change-password';
  static const String updateInfoUrl = '$mainUrl/user/update-info';
  static const String updateAvatarUrl = '$mainUrl/user/update-avatar';
  static const String getInfoUrl = '$mainUrl/user/get-info';
}
