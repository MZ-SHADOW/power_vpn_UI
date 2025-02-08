import 'package:flutter/material.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';

class VpnInfoData extends StatefulWidget {
  const VpnInfoData({super.key});

  @override
  State<VpnInfoData> createState() => _VpnInfoDataState();
}

class _VpnInfoDataState extends State<VpnInfoData> {
  var v2rayStatus = ValueNotifier<V2RayStatus>(V2RayStatus());
  late final FlutterV2ray flutterV2ray = FlutterV2ray(
    onStatusChanged: (status) {
      v2rayStatus.value = status;
    },
  );
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: v2rayStatus,
        builder: (context, value, child) {
          return Opacity(
            opacity: 0.9,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: const Color.fromARGB(27, 24, 30, 100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.upload,
                        color: Colors.white,
                      ),
                      Column(
                        children: [
                          Text(
                            'up/speed',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'IstokWeb',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            value.uploadSpeed.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'IstokWeb',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'down/speed',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'IstokWeb',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            value.downloadSpeed.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'IstokWeb',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.download,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
