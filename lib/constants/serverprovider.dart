import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:dio/dio.dart';
import 'package:power_vpn/utils/dot_env_custom.dart';

class ServerProvider with ChangeNotifier {
  List<Map<String, dynamic>> _servers = [];
  Map<String, dynamic>? _selectedServer;
  bool _isConnected = false;
  late FlutterV2ray _flutterV2ray;
  AnimationController? _animationController;
  double _uploadSpeed = 0.0;
  double _downloadSpeed = 0.0;
  Map<String, dynamic>? _userData;

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  ServerProvider() {
    _flutterV2ray = FlutterV2ray(
      onStatusChanged: (status) {
        _uploadSpeed = (status.uploadSpeed).toDouble();
        _downloadSpeed = (status.downloadSpeed).toDouble();
        notifyListeners();
        debugPrint("🔹 وضعیت VPN: ${status.state}");
        debugPrint(
            "📶 سرعت آپلود: $_uploadSpeed KB/s | 📥 سرعت دانلود: $_downloadSpeed KB/s");
      },
    );

    _flutterV2ray.initializeV2Ray(
      notificationIconResourceType: "mipmap",
      notificationIconResourceName: "ic_launcher",
    );
  }

  List<Map<String, dynamic>> get servers => _servers;
  Map<String, dynamic>? get selectedServer => _selectedServer;
  bool get isConnected => _isConnected;
  double get uploadSpeed => _uploadSpeed;
  double get downloadSpeed => _downloadSpeed;
  Map<String, dynamic>? get userData => _userData;

  /// setAnimationController
  void setAnimationController(AnimationController controller) {
    _animationController = controller;
  }

  /// setServers
  void setServers(List<Map<String, dynamic>> servers) {
    _servers = servers;
    notifyListeners();
  }

  /// selectServer
  void selectServer(Map<String, dynamic> server) {
    _selectedServer = server;
    notifyListeners();
  }

  /// fetchUserData
  Future<void> fetchUserData() async {
    String? accessToken = await secureStorage.read(key: 'access_token');
    if (accessToken == null || accessToken.isEmpty) {
      debugPrint("❌ توکن دسترسی موجود نیست.");
      return;
    }
    try {
      final response = await _dio.get(
        DotenvCustom().get('API_BASE_URL_USER') ?? '',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200) {
        _userData = response.data;
        notifyListeners();
        debugPrint("✅ اطلاعات کاربر ذخیره شد: $_userData");
      }
    } catch (e) {
      debugPrint("❌ خطا در دریافت اطلاعات کاربر: $e");
    }
  }

  /// toggleConnected
  Future<void> toggleConnected() async {
    _selectedServer = findFastestServer();
    if (_selectedServer == null || !_selectedServer!.containsKey("code")) {
      debugPrint("❌ سرور معتبر یافت نشد!");
      return;
    }

    String v2rayLink = _selectedServer!["code"] ?? "";
    if (v2rayLink.isEmpty) {
      debugPrint("❌ لینک سرور معتبر نیست.");
      return;
    }
    final V2RayURL v2rayURL = FlutterV2ray.parseFromURL(v2rayLink);
    String config = v2rayURL.getFullConfiguration();
    if (_isConnected) {
      await _flutterV2ray.stopV2Ray();
      _isConnected = false;
      _animationController?.reverse();
    } else {
      if (await _flutterV2ray.requestPermission()) {
        bool permissionGranted = await _flutterV2ray.requestPermission();
        if (!permissionGranted) {
          debugPrint("❌ دسترسی لازم برای V2Ray داده نشده است.");
          return;
        }
        try {
          await _flutterV2ray.startV2Ray(
            remark: v2rayURL.remark,
            config: config,
            proxyOnly: false,
            bypassSubnets: [],
            notificationDisconnectButtonName: "DISCONNECT",
          );
          _isConnected = true;
          _animationController?.forward();
          debugPrint("✅ اتصال موفقیت‌آمیز بود.");
        } catch (e, stackTrace) {
          _isConnected = false;
          _animationController?.reverse();
          debugPrint("❌ خطای اتصال: $e");
          debugPrint("🔍 جزئیات خطا: $stackTrace");
        }
      }
    }
    debugPrint("🔄 وضعیت اتصال: $_isConnected");

    notifyListeners();
  }

  Map<String, dynamic>? findFastestServer() {
    if (_servers.isEmpty) return null;
    _servers.sort((a, b) =>
        (a['ping'] ?? double.infinity).compareTo(b['ping'] ?? double.infinity));

    return _servers.first;
  }
}
