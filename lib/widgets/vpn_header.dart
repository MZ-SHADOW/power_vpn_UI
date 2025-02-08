import 'package:flutter/material.dart';

class VpnHeader extends StatelessWidget {
  const VpnHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Opacity(
        opacity: 0.8,
        child: AppBar(
          backgroundColor: Color.fromARGB(211, 206, 206, 206),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(2),
            ),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu),
              );
            },
          ),
          title: const Text('PowerVpn'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_business_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
