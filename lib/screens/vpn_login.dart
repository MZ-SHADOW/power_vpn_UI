import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:power_vpn/screens/vpn_home.dart';
import 'package:power_vpn/utils/auth_storage.dart';
import 'package:power_vpn/utils/dot_env_custom.dart';

class VpnLogin extends StatefulWidget {
  const VpnLogin({super.key});

  @override
  State<VpnLogin> createState() => _VpnLoginState();
}

class _VpnLoginState extends State<VpnLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool? isSessionExpired;
  bool _isPasswordVisible = false;

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoading) return;

    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "نام کاربری و رمز عبور را وارد کنید.";
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final String url =
        DotenvCustom().get('API_BASE_URL_AUTH') ?? '';
    final String csrfToken = DotenvCustom().get('CSRF_TOKEN') ?? '';

    debugPrint('API URL: $url');
    debugPrint('CSRF Token: $csrfToken');

    try {
      final response = await _dio.post(
        url,
        data: jsonEncode({'username': username, 'password': password}),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-CSRFTOKEN': csrfToken
          },
        ),
      );
      if (response.statusCode != null && response.statusCode! ~/ 100 == 2) {
        final data = response.data;
        if (data['access_token'] != null && data['refresh_token'] != null) {
          await AuthStorage().saveTokens(data['access_token'],
              data['refresh_token'], data['username'] ?? 'نام‌ناشناس');
          if (mounted) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const VpnHome()));
          }
        } else {
          setState(
              () => _errorMessage = "توکن دریافت نشد. لطفاً دوباره تلاش کنید.");
        }
      } else {
        setState(() => _errorMessage =
            response.data['message'] ?? "نام کاربری یا رمز عبور اشتباه است.");
      }
    } catch (e) {
      setState(() =>
          _errorMessage = "خطا در ارتباط با سرور. اینترنت خود را بررسی کنید.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/image1.png',
              height: 78,
              width: 78,
            ),
            const SizedBox(height: 32),
            const Text(
              'PowerVPN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontFamily: 'IstokWeb',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 40),

            TextField(
              controller: _usernameController,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'نام کاربری',
                hintStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color.fromARGB(111, 111, 111, 100),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // فیلد رمز عبور
            TextField(
              controller: _passwordController,
              textAlign: TextAlign.end,
              obscureText: !_isPasswordVisible,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'رمز عبور',
                hintStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color.fromARGB(111, 111, 111, 100),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: IconButton(
                  color: Colors.white,
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            // نمایش خطا در صورت وجود
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 10),

            // دکمه ورود
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F1F1F),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'ورود',
                        style: TextStyle(
                          color: Color(0xFFA3A2A2),
                          fontFamily: 'vazirmatn',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
