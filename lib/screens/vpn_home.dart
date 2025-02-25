import 'dart:math';
import 'package:flutter/material.dart';
import 'package:power_vpn/constants/serverprovider.dart';
import 'package:provider/provider.dart';
import '../screens/vpn_left_panel.dart';
import '../widgets/vpn_regions.dart';
import '../widgets/vpn_info_data.dart';
import '../widgets/vpn_header.dart';
import '../widgets/vpn_status.dart';
import '../widgets/vpn_info_card.dart';

class VpnHome extends StatefulWidget {
  const VpnHome({super.key});

  @override
  State<VpnHome> createState() => _VpnHomeState();
}

class _VpnHomeState extends State<VpnHome> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    Future.delayed(Duration.zero, () {
      Provider.of<ServerProvider>(
        context,
        listen: false,
      ).setAnimationController(_controller);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverProvider = Provider.of<ServerProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;
        double buttonSize = screenWidth * 0.3;

        return Scaffold(
          body: Consumer<ServerProvider>(
            builder: (_, ServerProvider value, __) {
              bool isConnect = serverProvider.isConnected;
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    SafeArea(
                      child: Column(
                        children: [
                          const VpnHeader(),
                          SizedBox(height: screenHeight * 0.02),
                          GestureDetector(
                            onTap: serverProvider.toggleConnected,
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AnimatedBuilder(
                                    animation: _controller,
                                    builder:
                                        (_, __) => CustomPaint(
                                          size: Size(buttonSize, buttonSize),
                                          painter: CircularTimelinePainter(
                                            progress: _controller.value,
                                            isOn:
                                                context
                                                    .watch<ServerProvider>()
                                                    .isConnected,
                                          ),
                                        ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    height: buttonSize,
                                    width: buttonSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          isConnect ? Colors.green : Colors.red,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              isConnect
                                                  ? Colors.green.withOpacity(
                                                    0.4,
                                                  )
                                                  : Colors.red.withOpacity(0.4),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        isConnect
                                            ? 'assets/images/on.png'
                                            : 'assets/images/off.png',
                                        width: buttonSize * 0.9,
                                        height: buttonSize * 0.6,
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
              );
            },
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
    final progressPaint =
        Paint()
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
