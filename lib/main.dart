import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:power_vpn/utils/dot_env_custom.dart';
import 'package:provider/provider.dart';
import 'package:power_vpn/screens/vpn_login.dart';
import 'package:power_vpn/screens/vpn_home.dart';
import 'constants/serverprovider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final dotenv = DotenvCustom();
  dotenv.load();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ServerProvider())],
      child: const VpnApp(),
    ),
  );
}

class VpnApp extends StatelessWidget {
  const VpnApp({super.key});

  Future<bool> _checkLoginStatus() async {
    final secureStorage = const FlutterSecureStorage();
    String? accessToken = await secureStorage.read(key: 'access_token');
    String? refreshToken = await secureStorage.read(key: 'refresh_token');
    return accessToken != null && refreshToken != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF262626)),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const VpnHome();
          } else {
            return const VpnLogin();
          }
        },
      ),
    );
  }
}
