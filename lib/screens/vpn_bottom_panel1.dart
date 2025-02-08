import 'package:flutter/material.dart';

class VpnBottomPanel1 extends StatefulWidget {
  const VpnBottomPanel1({super.key});

  @override
  State<VpnBottomPanel1> createState() => VpnBottomPanel1State();
}

class VpnBottomPanel1State extends State<VpnBottomPanel1> {
  final double borderRadius = 12.0;

  void showServerList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
        side: BorderSide(color: Colors.white, width: 1),
      ),
      backgroundColor: const Color(0xFF2F2535),
      builder: (context) {
        final List<Map<String, dynamic>> servers = [
          {
            "name": "آمریکا",
            "flag": "🇺🇸",
            "image": "assets/images/flag/america.flag.png",
            "ping": 85
          },
          {
            "name": "آلمان",
            "flag": "🇩🇪",
            "image": "assets/images/flag/germany.flag.png",
            "ping": 42
          },
          {
            "name": "فرانسه",
            "flag": "🇫🇷",
            "image": "assets/images/flag/france.flag.png",
            "ping": 55
          },
          {
            "name": "فنلاند",
            "flag": "🇫🇮",
            "image": "assets/images/flag/finland.flag.png",
            "ping": 70
          },
          {
            "name": "هلند",
            "flag": "🇳🇱",
            "image": "assets/images/flag/holland.flag.png",
            "ping": 48
          },
          {
            "name": "اوکراین",
            "flag": "🇺🇦",
            "image": "assets/images/flag/ukraine.flag.png",
            "ping": 60
          },
          {
            "name": "انگلیس",
            "flag": "🇬🇧",
            "image": "assets/images/flag/england.flag.png",
            "ping": 52
          },
          {
            "name": "روسیه",
            "flag": "🇷🇺",
            "image": "assets/images/flag/russia.flag.png",
            "ping": 90
          },
        ];

        return Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black54,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            SizedBox(
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                              Icons.keyboard_double_arrow_down_sharp,
                              color: Colors.white),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Action for the button
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 69, 69, 70),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            side: BorderSide(color: Colors.white),
                          ),
                          child: const Text(
                            'UPDATE',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'IstokWeb',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.swipe_up,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'برای مشاهده بیشتر، لیست را به بالا بکشید',
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Vazirmatn',
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: servers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          child: ListTile(
                            leading: Image.asset(
                              servers[index]["image"]!,
                              width: 40,
                              height: 40,
                            ),
                            title: Text(
                              "سرور ${servers[index]["name"]}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "Ping: ${servers[index]["ping"]} ms",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: IconButton(
        onPressed: () => showServerList(context),
        icon: const Icon(Icons.chevron_right, color: Colors.white),
      ),
    );
  }
}
