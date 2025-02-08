import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';

class ConfigHistoryScreen extends StatefulWidget {
  final Function onHistoryDeleted;
  const ConfigHistoryScreen({super.key, required this.onHistoryDeleted});

  @override
  State<ConfigHistoryScreen> createState() => _ConfigHistoryScreenState();
}

class _ConfigHistoryScreenState extends State<ConfigHistoryScreen> {
  List<String> history = [];
  late FlutterV2ray flutterV2ray;

  @override
  void initState() {
    super.initState();
    flutterV2ray = FlutterV2ray(onStatusChanged: (status) {});
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      history = prefs.getStringList('configHistory') ?? [];
    });
  }

  Future<void> _deleteHistoryItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      history.removeAt(index);
    });
    await prefs.setStringList('configHistory', history);

    widget.onHistoryDeleted();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تنظیمات حذف شد و اتصال VPN قطع گردید')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تاریخچه تنظیمات'),
      ),
      body: history.isEmpty
          ? const Center(child: Text('هیچ تنظیماتی در تاریخچه وجود ندارد'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('تنظیمات ${index + 1}'),
                  subtitle: Text(history[index]),
                  onTap: () {
                    Navigator.pop(context, history[index]);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _deleteHistoryItem(index);
                    },
                  ),
                );
              },
            ),
    );
  }
}
