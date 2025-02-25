import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/serverprovider.dart';

class VpnInfoData extends StatefulWidget {
  const VpnInfoData({super.key});

  @override
  State<VpnInfoData> createState() => _VpnInfoDataState();
}

class _VpnInfoDataState extends State<VpnInfoData> {
  @override
  Widget build(BuildContext context) {
    final serverProvider = Provider.of<ServerProvider>(context);

    return Opacity(
      opacity: 0.9,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: const Color.fromARGB(27, 24, 30, 100),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(Icons.upload, color: Colors.white),
                Column(
                  children: [
                    const Text(
                      'Up Speed',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'IstokWeb',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '${serverProvider.uploadSpeed.toStringAsFixed(2)} KB/s', 
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'IstokWeb',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Down Speed',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'IstokWeb',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '${serverProvider.downloadSpeed.toStringAsFixed(2)} KB/s',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'IstokWeb',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.download, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
