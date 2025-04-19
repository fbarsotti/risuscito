import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key}) : super(key: key);

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  Map<String, Object> _prefsMap = {};

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final map = <String, Object>{};
    for (final key in keys) {
      final value = prefs.get(key);
      if (value != null) map[key] = value;
    }
    setState(() {
      _prefsMap = map;
    });
  }

  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _loadPrefs();
  }

  Future<void> _removeKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    await _loadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug SharedPreferences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Svuota tutto',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Conferma'),
                  content: const Text(
                      'Sicuro di voler svuotare tutte le SharedPreferences?'),
                  actions: [
                    TextButton(
                      child: const Text('Annulla'),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    ElevatedButton(
                      child: const Text('Svuota'),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await _clearPrefs();
              }
            },
          )
        ],
      ),
      body: _prefsMap.isEmpty
          ? const Center(child: Text('Nessuna preferenza salvata.'))
          : ListView(
              children: _prefsMap.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  subtitle: Text(entry.value.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeKey(entry.key),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
