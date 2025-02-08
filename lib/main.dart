import 'package:flutter/material.dart';
import 'package:power_vpn/screens/vpn_login.dart';

void main() {
  runApp(const Vpn());
}

class Vpn extends StatelessWidget {
  const Vpn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: Color(0xFF262626),
      ),
      debugShowCheckedModeBanner: false,
      home: VpnLogin(),
    );
  }
}
