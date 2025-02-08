import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2F2535),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 5,
                top: 50,
                bottom: 5,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage('assets/images/image2.png'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                  SizedBox(height: 5),
                  Text(
                    'GGCGUfxdulhfuildhafludsada2645dasighja',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'IstokWeb',
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '12454862',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'IstokWeb',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        ' : روز های باقی مانده',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Vazirmatn',
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      SizedBox(height: 50),
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
