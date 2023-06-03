import 'package:shared_preferences/shared_preferences.dart';

class HistoryLocalDatasource {
  final SharedPreferences? sharedPreferences;
  static const String _historyKey = 'history';

  HistoryLocalDatasource({
    required this.sharedPreferences,
  });

  List<String> getHistory() {
    List<String>? history = sharedPreferences!.getStringList(_historyKey);
    return history ?? [];
  }

  Future<void> saveInHistory(String songId) async {
    List<String>? history = sharedPreferences!.getStringList(_historyKey);
    if (history == null) history = [];
    if ((history.contains(songId))) history.remove(songId);
    history.insert(0, songId);
    if (history.length == 21) history.removeAt(20);
    await sharedPreferences!.setStringList(_historyKey, history);
  }

  Future<void> removeFromHistory(String songId) async {
    List<String>? history = sharedPreferences!.getStringList(_historyKey);
    history!.remove(songId);
    await sharedPreferences!.setStringList(_historyKey, history);
  }

  Future<void> deleteHistory() async {
    await sharedPreferences!.setStringList(_historyKey, []);
  }
}
