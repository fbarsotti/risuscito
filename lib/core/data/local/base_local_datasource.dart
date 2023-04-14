import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseLocalDatasource {
  final SharedPreferences? sharedPreferences;

  BaseLocalDatasource({
    required this.sharedPreferences,
  });

  String getAssetsPath() {
    return 'assets/';
  }

  String _getValuesPath() {
    return 'assets/data/song_values/';
  }

  String _getRawPath() {
    return 'assets/data/song_raw/';
  }

  String _getLocalizedValuePath(String languageCode) {
    return 'assets/data/songs_values/values-$languageCode';
  }

  Future<String> getLocalizedTitlesFileContent(String languageCode) async {
    var path = _getLocalizedValuePath(languageCode);
    var content = await _getFileContent(path);
    return content;
  }

  static Future<String> getLocalizedSongPath(
      String languageCode, String songTitle) async {
    return await rootBundle
        .loadString('assets/data/songs_raw/raw-$languageCode/$songTitle');
  }

  Future<String> _getFileContent(String path) async {
    return await rootBundle.loadString('$path/titoli.xml');
  }
}
