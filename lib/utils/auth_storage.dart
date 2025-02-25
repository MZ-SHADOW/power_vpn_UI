import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static final AuthStorage _instance = AuthStorage._internal();

  factory AuthStorage() {
    return _instance;
  }

  AuthStorage._internal();

  // ایجاد نمونه از flutter_secure_storage
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // ذخیره توکن‌ها و اطلاعات ورود کاربر
  Future<void> saveTokens(
      String accessToken, String refreshToken, String username) async {
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
    await storage.write(key: 'username', value: username);
    await storage.write(
        key: 'last_login_time',
        value: DateTime.now().millisecondsSinceEpoch.toString());
  }

  // دریافت Access Token
  Future<String?> getAccessToken() async {
    return await storage.read(key: 'access_token');
  }

  // دریافت Refresh Token
  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refresh_token');
  }

  // دریافت نام کاربری
  Future<String?> getUsername() async {
    return await storage.read(key: 'username');
  }

  // دریافت زمان ورود
  Future<int?> getLastLoginTime() async {
    String? lastLoginTimeStr = await storage.read(key: 'last_login_time');
    return lastLoginTimeStr != null ? int.tryParse(lastLoginTimeStr) : null;
  }

  // بررسی انقضای سشن (آیا بیش از 24 ساعت گذشته است؟)
  Future<bool> isSessionExpired() async {
    int? lastLoginTime = await getLastLoginTime();

    if (lastLoginTime == null) {
      return true; // اگر مقدار موجود نباشد، سشن منقضی شده است
    }

    int currentTime = DateTime.now().millisecondsSinceEpoch;
    return (currentTime - lastLoginTime) >=
        86400000; // اگر بیشتر از 24 ساعت گذشته باشد
  }

  // حذف اطلاعات ورود (خروج از حساب)
  Future<void> clearTokens() async {
    await storage.deleteAll();
  }
}
