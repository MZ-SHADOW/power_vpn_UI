import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import '../screens/vpn_left_panel.dart';
import '../widgets/vpn_regions.dart';
import '../widgets/vpn_info_data.dart';
import '../widgets/vpn_header.dart';
import '../widgets/vpn_status.dart';
import '../widgets/vpn_info_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VpnHome extends StatefulWidget {
  const VpnHome({super.key});

  @override
  State<VpnHome> createState() => _VpnHomeState();
}

class _VpnHomeState extends State<VpnHome> with SingleTickerProviderStateMixin {
  bool isConnect = false;
  late AnimationController _controller;
  bool isReversed = false;
  var v2rayStatus = ValueNotifier<V2RayStatus>(V2RayStatus());
  late final FlutterV2ray flutterV2ray = FlutterV2ray(
    onStatusChanged: (status) {
      v2rayStatus.value = status;
    },
  );
  final config = TextEditingController();
  bool isImportAndToggleCalled = false;
  String remark = "Default Remark";

  @override
  void initState() {
    super.initState();
    loadConfig();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    flutterV2ray.initializeV2Ray(
      notificationIconResourceType: "mipmap",
      notificationIconResourceName: "ic_launcher",
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    config.dispose();
    super.dispose();
  }

  Future<void> toggleConnected() async {
    if (isConnect) {
      await flutterV2ray.stopV2Ray();
      setState(() {
        isConnect = false;
        _controller.stop();
        if (!isReversed) {
          _controller.reverse();
        }
        isReversed = true;
      });
    } else if (await flutterV2ray.requestPermission()) {
      try {
        await flutterV2ray.startV2Ray(
          remark: remark,
          config: config.text,
          proxyOnly: false,
          bypassSubnets: [],
          notificationDisconnectButtonName: "DISCONNECT",
        );
        setState(() {
          isConnect = true;
          isReversed = false;
          _controller.forward();
        });
      } catch (e) {
        setState(() {
          isConnect = false;
          _controller.stop();
          _controller.reverse();
          isReversed = true;
        });
      }
    }
  }

  Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      remark = prefs.getString('remark') ?? "Default Remark";
      config.text = prefs.getString('config') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;
        double buttonSize = screenWidth * 0.3;

        return Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      const VpnHeader(),
                      SizedBox(height: screenHeight * 0.02),
                      GestureDetector(
                        onTap: () async {
                          await toggleConnected();
                        },
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  return CustomPaint(
                                    size: Size(buttonSize, buttonSize),
                                    painter: CircularTimelinePainter(
                                      progress: _controller.value,
                                      isOn: isConnect,
                                    ),
                                  );
                                },
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                height: buttonSize,
                                width: buttonSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isConnect ? Colors.green : Colors.red,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (isConnect
                                          // ignore: deprecated_member_use
                                          ? Colors.green.withOpacity(0.4)
                                          // ignore: deprecated_member_use
                                          : Colors.red.withOpacity(0.4)),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    isConnect
                                        ? Icons.power_sharp
                                        : Icons.power_off_sharp,
                                    color: Colors.white,
                                    size: buttonSize * 0.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      VpnStatus(isConnect: isConnect),
                      const VpnInfoCard(),
                      const VpnInfoData(),
                      const VpnRegions(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          drawer: const LeftPanel(),
        );
      },
    );
  }
}

class CircularTimelinePainter extends CustomPainter {
  final double progress;
  final bool isOn;

  CircularTimelinePainter({required this.progress, required this.isOn});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final backgroundPaint = Paint()..color = isOn ? Colors.green : Colors.grey;
    canvas.drawCircle(center, radius, backgroundPaint);
    final progressPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (pi / 180),
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
