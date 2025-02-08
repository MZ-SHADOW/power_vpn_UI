import 'package:flutter/material.dart';
import 'package:power_vpn/screens/vpn_home.dart';

class VpnLogin extends StatefulWidget {
  const VpnLogin({super.key});

  @override
  State<VpnLogin> createState() => _VpnLoginState();
}

class _VpnLoginState extends State<VpnLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isUsernameEmpty = true;
  bool _isPasswordEmpty = true;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() {
      setState(() {
        _isUsernameEmpty = _usernameController.text.isEmpty;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _isPasswordEmpty = _passwordController.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
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
              ],
            ),
            const SizedBox(height: 40),
            //user name
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _usernameController,
                    textAlign: TextAlign.end,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Vazirmatn',
                      fontWeight: FontWeight.w500,
                    ), // رنگ متن سفید شد
                    cursorColor: Colors.white,
                    textAlignVertical: TextAlignVertical.center,
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
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.person_pin_outlined,
                  size: 30,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 20),
            //password
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _passwordController,
                    textAlign: TextAlign.end,
                    textDirection: TextDirection.rtl,
                    cursorColor: Colors.white,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Vazirmatn',
                      fontWeight: FontWeight.w500,
                    ), // رنگ متن سفید شد
                    textAlignVertical:
                        TextAlignVertical.center, // قرارگیری مناسب متن
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
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.password_outlined,
                  size: 30,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VpnHome()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1F1F1F),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  side: BorderSide(color: Color(0xFFA3A2A2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ورود',
                      style: TextStyle(
                        color: Color(0xFFA3A2A2),
                        fontSize: 20,
                        fontFamily: 'Vazirmatn',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
