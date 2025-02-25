import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DotenvCustom {
  static final DotenvCustom _instance = DotenvCustom._internal();
  factory DotenvCustom() => _instance;

  DotenvCustom._internal();

  final Map<String, String> _env = {};

  Future<void> load() async {
    try {

      final encryptedData = await rootBundle.loadString('assets/.env.enc');

      final cleanedData = encryptedData.replaceAll('\n', '').trim();


      final decodedData = utf8.decode(base64.decode(cleanedData));


      List<String> lines = decodedData.split('\n');
      for (var line in lines) {
        if (line.trim().isNotEmpty) {
          final keyValue = line.split('=');
          if (keyValue.length == 2) {
            _env[keyValue[0].trim()] = keyValue[1].trim();
          }
        }
      }
    } catch (e) {
      debugPrint("خطا در بارگذاری یا رمزگشایی فایل .env.enc: $e");
    }
  }

  String? get(String key) {
    return _env[key];
  }
}
