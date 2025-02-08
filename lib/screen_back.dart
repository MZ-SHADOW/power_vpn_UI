// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_v2ray/flutter_v2ray.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   var v2rayStatus = ValueNotifier<V2RayStatus>(V2RayStatus());
//   late final FlutterV2ray flutterV2ray = FlutterV2ray(
//     onStatusChanged: (status) {
//       v2rayStatus.value = status;
//     },
//   );
//   final config = TextEditingController();
//   bool proxyOnly = false;
//   final bypassSubnetController = TextEditingController();
//   List<String> bypassSubnets = [];
//   String? coreVersion;

//   String remark = "Default Remark";

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
//         final V2RayURL v2rayURL = FlutterV2ray.parseFromURL(link);
//         remark = v2rayURL.remark;
//         config.text = v2rayURL.getFullConfiguration();
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 'موفقیت آمیز بود',
//               ),
//             ),
//           );
//         }
//       } catch (error) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 'خطا: $error',
//               ),
//             ),
//           );
//         }
//       }
//     }
//   }

//   void delay() async {
//     late int delay;
//     if (v2rayStatus.value.state == 'CONNECTED') {
//       delay = await flutterV2ray.getConnectedServerDelay();
//     } else {
//       delay = await flutterV2ray.getServerDelay(config: config.text);
//     }
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           '${delay}ms',
//         ),
//       ),
//     );
//   }

//   void bypassSubnet() {
//     bypassSubnetController.text = bypassSubnets.join("\n");
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'زیرشبکه‌ها:',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               TextFormField(
//                 controller: bypassSubnetController,
//                 maxLines: 5,
//                 minLines: 5,
//                 decoration: const InputDecoration(
//                   hintText: 'زیرشبکه‌ها را وارد کنید',
//                 ),
//               ),
//               const SizedBox(height: 5),
//               ElevatedButton(
//                 onPressed: () {
//                   bypassSubnets =
//                       bypassSubnetController.text.trim().split('\n');
//                   if (bypassSubnets.first.isEmpty) {
//                     bypassSubnets = [];
//                   }
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('ثبت'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     flutterV2ray
//         .initializeV2Ray(
//       notificationIconResourceType: "mipmap",
//       notificationIconResourceName: "ic_launcher",
//     )
//         .then((value) async {
//       coreVersion = await flutterV2ray.getCoreVersion();
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     config.dispose();
//     bypassSubnetController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 5),
//               const Text(
//                 'پیکربندی V2Ray (json):',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               TextFormField(
//                 controller: config,
//                 maxLines: 10,
//                 minLines: 10,
//                 decoration: const InputDecoration(
//                   hintText: 'پیکربندی را وارد کنید',
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ValueListenableBuilder(
//                 valueListenable: v2rayStatus,
//                 builder: (context, value, child) {
//                   return Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Text(value.state),
//                           const SizedBox(height: 10),
//                           Text(value.duration),
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text('سرعت:'),
//                               const SizedBox(width: 10),
//                               Text(value.uploadSpeed.toString()),
//                               const Text('↑'),
//                               const SizedBox(width: 10),
//                               Text(value.downloadSpeed.toString()),
//                               const Text('↓'),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text('حجم ترافیک:'),
//                               const SizedBox(width: 10),
//                               Text(value.upload.toString()),
//                               const Text('↑'),
//                               const SizedBox(width: 10),
//                               Text(value.download.toString()),
//                               const Text('↓'),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           Text('نسخه هسته: $coreVersion'),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 10),
//               Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: connect,
//                     icon: const Icon(Icons.connect_without_contact),
//                     label: const Text('اتصال'),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () => flutterV2ray.stopV2Ray(),
//                     icon: const Icon(Icons.stop),
//                     label: const Text('قطع اتصال'),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: importConfig,
//                     icon: const Icon(Icons.link),
//                     label: const Text('وارد کردن از لینک v2ray'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
