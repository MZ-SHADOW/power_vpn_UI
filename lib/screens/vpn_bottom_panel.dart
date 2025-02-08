// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_v2ray/flutter_v2ray.dart';
// import 'package:power_vpn/screens/config_historyscreen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class VpnBottomPanel extends StatefulWidget {
//   const VpnBottomPanel({super.key});

//   @override
//   State<VpnBottomPanel> createState() => _BottomSheetState();
// }

// class _BottomSheetState extends State<VpnBottomPanel> {
//   bool isConnect = false;
//   bool isReversed = false;

//   final TextEditingController config = TextEditingController();
//   String remark = "Default Remark";

//   var v2rayStatus = ValueNotifier<V2RayStatus>(V2RayStatus());
//   late final FlutterV2ray flutterV2ray = FlutterV2ray(
//     onStatusChanged: (status) {
//       v2rayStatus.value = status;
//     },
//   );
//   bool proxyOnly = false;
//   List<String> bypassSubnets = [];
//   void connect() async {
//     if (await flutterV2ray.requestPermission()) {
//       flutterV2ray.startV2Ray(
//         remark: remark,
//         config: config.text,
//         proxyOnly: proxyOnly,
//         bypassSubnets: bypassSubnets,
//         notificationDisconnectButtonName: "DISCONNECT",
//       );
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('دسترسی رد شد'),
//           ),
//         );
//       }
//     }
//   }

//   void importConfig() async {
//     if (await Clipboard.hasStrings()) {
//       try {
//         final String link =
//             (await Clipboard.getData('text/plain'))?.text?.trim() ?? '';
//         print(link);
//         final V2RayURL v2rayURL = FlutterV2ray.parseFromURL(link);
//         remark = v2rayURL.remark;

//         config.text = v2rayURL.getFullConfiguration();
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 'لینک V2Ray با موفقیت وارد شد',
//               ),
//             ),
//           );
//         }
//       } catch (error) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 'خطا در وارد کردن لینک: $error',
//               ),
//             ),
//           );
//         }
//       }
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('هیچ متنی در کلیپ‌بورد وجود ندارد'),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> resetConfigFromClipboard() async {
//     if (await Clipboard.hasStrings()) {
//       final String link =
//           (await Clipboard.getData('text/plain'))?.text?.trim() ?? '';

//       if (link.isNotEmpty) {
//         try {
//           final V2RayURL v2rayURL = FlutterV2ray.parseFromURL(link);

//           // ذخیره داده‌های جدید
//           remark = v2rayURL.remark;
//           config.text = v2rayURL.getFullConfiguration();

//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('remark', remark);
//           await prefs.setString('config', config.text);

//           // به‌روزرسانی رابط کاربری
//           setState(() {});

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('تنظیمات جدید با موفقیت اعمال شد!'),
//             ),
//           );
//         } catch (e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('خطا در پردازش لینک: $e'),
//             ),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('کلیپ‌بورد خالی است یا متن نامعتبر است'),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('هیچ متنی در کلیپ‌بورد وجود ندارد'),
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     config.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(12)),
//         border: Border.all(color: Colors.white),
//       ),
//       child: IconButton(
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(20),
//               ),
//             ),
//             builder: (context) {
//               return Container(
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       const Color.fromARGB(184, 3, 56, 149),
//                       const Color.fromARGB(255, 3, 53, 139),
//                     ],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(20),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'وارد کردن لینک V2Ray',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 10),
//                         ElevatedButton.icon(
//                           onPressed: importConfig,
//                           icon: const Icon(Icons.link),
//                           label: const Text('وارد کردن از لینک'),
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.redAccent,
//                           ),
//                           onPressed: () async {
//                             await resetConfigFromClipboard();
//                           },
//                           child: const Text(
//                             "بارگذاری جدید از کلیپ‌بورد",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
                       
//                         ElevatedButton(
//                           onPressed: () async {
//                             final selectedConfig = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ConfigHistoryScreen(
//                                   onHistoryDeleted: () {
                                  
//                                     setState(() {
//                                       isConnect =
//                                           false; 
//                                     });
                                    
//                                     flutterV2ray.stopV2Ray();
//                                   },
//                                 ),
//                               ),
//                             );

//                             if (selectedConfig != null) {
//                               setState(() {
//                                 config.text = selectedConfig;
//                                 isConnect = false; 
//                               });
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content: Text('تنظیمات اعمال شد')),
//                               );
//                             }
//                           },
//                           child: const Text('مشاهده تاریخچه'),
//                         ),
//                         // بارگذاری جدید از کلیپ‌بورد
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//         icon: const Icon(Icons.chevron_right, color: Colors.white),
//       ),
//     );
//   }
// }
