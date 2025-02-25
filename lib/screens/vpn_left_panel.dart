import 'package:flutter/material.dart';
import 'package:power_vpn/constants/serverprovider.dart';
import 'package:provider/provider.dart';

class LeftPanel extends StatefulWidget {
  const LeftPanel({super.key});

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<ServerProvider>(context, listen: false).fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: const Color(0xFF2F2535)),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 5,
                top: 50,
                bottom: 5,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage('assets/images/image2.png'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        ': نام کاربری',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Vazirmatn',
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  Consumer<ServerProvider>(
                    builder: (context, serverProvider, child) {
                      if (serverProvider.userData == null) {
                        return const CircularProgressIndicator(); 
                      }

                      String username =
                          serverProvider
                              .userData?['active_account_app']?['customer']?['username'] ??
                          'نام کاربری یافت نشد';

                      return Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'IstokWeb',
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        ' : روز های باقی مانده',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Vazirmatn',
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<ServerProvider>(
                        builder: (context, serverProvider, child) {
                          if (serverProvider.userData == null) {
                            return const Text(
                              'اطلاعات کاربر یافت نشد',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'IstokWeb',
                                fontWeight: FontWeight.w300,
                              ),
                            );
                          }

                          var remainingDays =
                              serverProvider.userData?['time_remain'];

                          if (remainingDays == null) {
                            return const Text(
                              'منتظر بمانید',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'IstokWeb',
                                fontWeight: FontWeight.w300,
                              ),
                            );
                          }

                          return Text(
                            '$remainingDays روز',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'IstokWeb',
                              fontWeight: FontWeight.w300,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              'خانه',
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.wifi),
            title: Text(
              'کانفیگ',
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'تنظیمات',
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'خروج',
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Version: 32',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'IstokWeb',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
