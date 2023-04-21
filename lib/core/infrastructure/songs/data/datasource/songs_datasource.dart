import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongsDatasource {
  final SharedPreferences? sharedPreferences;

  SongsDatasource({
    required this.sharedPreferences,
  });

  Future<String> _getFileContent(
    String path,
    String filename,
  ) async {
    return await rootBundle.loadString('$path/$filename.xml');
  }

  String getAssetsPath() {
    return 'assets/';
  }

  String _getValuesPath() {
    return 'assets/data/song_values/';
  }

  String _getRawPath() {
    return 'assets/data/song_raw/';
  }

  String _getLocalizedValuesPath(String languageCode) {
    return 'assets/data/songs_values/values-$languageCode';
  }

  Future<String> getLocalizedTitlesFileContent(String languageCode) async {
    var path = _getLocalizedValuesPath(languageCode);
    var content = await _getFileContent(path, 'titoli');
    return content;
  }

  Future<String> getLocalizedPagesFileContent(String languageCode) async {
    var path = _getLocalizedValuesPath(languageCode);
    var content = await _getFileContent(path, 'pagine');
    return content;
  }

  Future<String> getLocalizedBiblicalRefsFileContent(
    String languageCode,
  ) async {
    var path = _getLocalizedValuesPath(languageCode);
    var content = await _getFileContent(path, 'indice_biblico');
    return content;
  }

  Future<String> getLocalizedSongPath(
    String languageCode,
    String songTitle,
  ) async {
    return await rootBundle
        .loadString('assets/data/songs_raw/raw-$languageCode/$songTitle');
  }

  Future<String> getLocalizedSongSources(
    String languageCode,
  ) async {
    return await rootBundle.loadString(
        'assets/data/songs_values/values-$languageCode/sorgenti.xml');
  }
}
