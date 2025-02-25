import 'package:flutter/material.dart';
import 'package:power_vpn/constants/serverprovider.dart';
import 'package:power_vpn/screens/vpn_bottom_panel1.dart';
import 'package:provider/provider.dart';

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
    final serverProvider = Provider.of<ServerProvider>(context);
    final selectedServer = serverProvider.selectedServer; // ✅ سرور انتخاب‌شده

    return GestureDetector(
      onTap: () {
        // دسترسی به متد showServerList از طریق GlobalKey
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
                      Text(
                        selectedServer?["name"] ??
                            'هنوز سروری انتخاب نکردید', // ✅ اصلاح مقداردهی
                        style: const TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      VpnBottomPanel1(
                          key: vpnPanelKey), // ✅ اطمینان از مقداردهی کلید
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
