import 'package:shared_preferences/shared_preferences.dart';

class FavouritesLocalDatasource {
  final SharedPreferences? sharedPreferences;
  static const String _favouritesKey = 'favorites';

  FavouritesLocalDatasource({
    required this.sharedPreferences,
  });

  List<String> getFavourites() {
    List<String>? favSongs = sharedPreferences!.getStringList(_favouritesKey);
    return favSongs ?? [];
  }

  Future<void> saveFavourite(String songId) async {
    List<String>? favSongs = sharedPreferences!.getStringList(_favouritesKey);
    if (favSongs == null) favSongs = [];
    if (!(favSongs.contains(songId))) favSongs.add(songId);
    await sharedPreferences!.setStringList(_favouritesKey, favSongs);
  }

  Future<void> removeFavourite(String songId) async {
    List<String>? favSongs = sharedPreferences!.getStringList(_favouritesKey);
    favSongs!.remove(songId);
    await sharedPreferences!.setStringList(_favouritesKey, favSongs);
  }
}
