import 'package:flutter/material.dart';

class VpnStatus extends StatelessWidget {
  final bool isConnect;

  const VpnStatus({required this.isConnect, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Status',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'IstokWeb',
              fontWeight: FontWeight.w400,
            )),
        Text(
          isConnect ? 'Connected' : 'Disconnected',
          style: TextStyle(
            fontSize: 20,
            color: isConnect ? Colors.green : Colors.red,
            fontFamily: 'IstokWeb',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
