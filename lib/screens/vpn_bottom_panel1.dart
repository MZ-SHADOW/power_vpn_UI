import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:power_vpn/constants/serverprovider.dart';
import 'package:power_vpn/utils/dot_env_custom.dart';
import 'package:provider/provider.dart';
import 'package:power_vpn/screens/vpn_login.dart';

class VpnBottomPanel1 extends StatefulWidget {
  const VpnBottomPanel1({super.key});

  @override
  State<VpnBottomPanel1> createState() => VpnBottomPanel1State();
}

class VpnBottomPanel1State extends State<VpnBottomPanel1> {
  final double borderRadius = 12.0;
  bool isLoading = false;
  bool isConnect = false;
  String? errorMessage;
  String? authToken;
  bool isLoggedIn = false;
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();


  final List<String> flagImages = [
    'assets/images/flag/america.flag.png',
    'assets/images/flag/england.flag.png',
    'assets/images/flag/finland.flag.png',
    'assets/images/flag/france.flag.png',
    'assets/images/flag/germany.flag.png',
    'assets/images/flag/holland.flag.png',
    'assets/images/flag/india.flag.png',
    'assets/images/flag/russia.flag.png',
    'assets/images/flag/ukraine.flag.png',
  ];


  List<String> serverFlagImages = [];

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    String? refreshToken = await secureStorage.read(key: 'refresh_token');
    if (!mounted) return; 
    setState(
      () => isLoggedIn = refreshToken != null && refreshToken.isNotEmpty,
    );

    if (!isLoggedIn) {
      _navigateToLogin();
      return;
    }
    fetchData();
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const VpnLogin()),
    );
  }


  Future<void> fetchData() async {
    if (!isLoggedIn) {
      _navigateToLogin();
      return;
    }
    if (isLoading) return;

    if (!mounted) return; 
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    authToken = await secureStorage.read(key: 'access_token');

    if (authToken == null || authToken!.isEmpty) {
      _navigateToLogin();
      return;
    }

    final String url =
        DotenvCustom().get('API_BASE_URL_CONFIG') ?? '';
    final String csrfToken = DotenvCustom().get('CSRF_TOKEN') ?? '';

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'X-CSRFTOKEN': csrfToken,
          },
        ),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        var data = response.data;
        if (data.isEmpty) {
          setState(() {
            errorMessage = 'هیچ داده‌ای برای نمایش وجود ندارد';
          });
        } else {
          data.shuffle(Random());
          setState(() {
            Provider.of<ServerProvider>(
              context,
              listen: false,
            ).setServers(List<Map<String, dynamic>>.from(data));

            serverFlagImages = List.generate(
              data.length,
              (index) => flagImages[Random().nextInt(flagImages.length)],
            );
          });
        }
      } else {
        setState(() {
          errorMessage = 'خطا در دریافت اطلاعات: ${response.statusCode}';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = '⚠️ درخواست ناموفق : اینترنت خود را بررسی کنید!';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  void showServerList(BuildContext context) {
    if (!isLoggedIn) {
      _navigateToLogin();
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
        side: const BorderSide(color: Colors.white, width: 1),
      ),
      backgroundColor: const Color(0xFF2F2535),
      builder: (context) {
        return Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
            ),
            SizedBox(
              height: double.infinity,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.swipe_up, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'برای مشاهده بیشتر، لیست را به بالا بکشید',
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Vazirmatn',
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Container(
                        width: 158,
                        height: 55,
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: Color(0xFF464444),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: Color(0xFFC9C9C9),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            await fetchData();
                          },
                          child:
                              isLoading
                                  ? CircularProgressIndicator(
                                    color: Colors.white,
                                  ) 
                                  : Text(
                                    'آپدیت',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Vazirmatn',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Expanded(
                    child:
                        isLoading
                            ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : errorMessage != null
                            ? Center(
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            )
                            : Consumer<ServerProvider>(
                              builder: (context, serverProvider, child) {
                                final servers = serverProvider.servers;
                                return ListView.builder(
                                  itemCount: servers.length,
                                  itemBuilder: (context, index) {
                                    final server = servers[index];
                                    String randomImage =
                                        serverFlagImages.isNotEmpty
                                            ? serverFlagImages[index]
                                            : flagImages[Random().nextInt(
                                              flagImages.length,
                                            )];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          borderRadius,
                                        ),
                                      ),
                                      child: ListTile(
                                        leading:
                                            server["image"] == null
                                                ? Image.asset(
                                                  randomImage,
                                                  width: 40,
                                                  height: 40,
                                                )
                                                : const Icon(
                                                  Icons.language,
                                                  color: Colors.white,
                                                ),
                                        title: Text(
                                          " سرور (${(server["name"])})",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        trailing: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                        ),
                                        onTap: () async {
                                          final provider =
                                              Provider.of<ServerProvider>(
                                                context,
                                                listen: false,
                                              );

                                          if (provider.isConnected) {
                                            await provider
                                                .toggleConnected(); // قطع اتصال فعلی
                                          }
                                          provider.selectServer(servers[index]);
                                          await provider.toggleConnected();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _dio.close(
      force: true,
    ); // بستن تمام درخواست‌های باز برای جلوگیری از setState()
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: IconButton(
        onPressed: () => showServerList(context),
        icon: const Icon(Icons.chevron_right, color: Colors.white),
      ),
    );
  }
}
