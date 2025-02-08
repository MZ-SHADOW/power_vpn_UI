import 'package:flutter/material.dart';
import 'package:power_vpn/screens/vpn_bottom_panel1.dart';

class VpnRegions extends StatefulWidget {
  const VpnRegions({super.key});

  @override
  State<VpnRegions> createState() => _VpnRegionsState();
}

class _VpnRegionsState extends State<VpnRegions> {
  final GlobalKey<VpnBottomPanel1State> vpnPanelKey =
      GlobalKey<VpnBottomPanel1State>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        vpnPanelKey.currentState?.showServerList(context);
      },
      child: Opacity(
        opacity: 0.9,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(27, 24, 30, 100),
              border: Border.all(color: Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/image2.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      const Text(
                        'هنوز سروری انتخاب نکردید',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      VpnBottomPanel1(key: vpnPanelKey),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
