import 'dart:convert';

import 'package:risuscito/feature/lists/data/model/list_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListsLocalDatasource {
  final SharedPreferences? sharedPreferences;
  static const String _listPrefixKey = 'list_';
  static const String _counterKey = 'list_counter';
  static const String _allListIdsKey = 'all_list_ids';

  ListsLocalDatasource({
    required this.sharedPreferences,
  });

  Future<void> _updateListIds(String newId) async {
    final prefs = sharedPreferences!;
    final raw = prefs.getString(_allListIdsKey);
    final List<String> ids =
        raw != null ? List<String>.from(jsonDecode(raw)) : [];
    if (!ids.contains(newId)) {
      ids.add(newId);
      prefs.setString(_allListIdsKey, jsonEncode(ids));
    }
  }

  void createList(String name, String description, String languageCode) {
    int counter = sharedPreferences!.getInt(_counterKey) ?? 0;
    sharedPreferences!.setInt(_counterKey, counter + 1);

    // Semplice creazione di un ID per la lista
    // in questo caso è un contatore incrementale
    final String listId = _listPrefixKey + '$counter';

    final String createdAt = DateTime.now().toIso8601String();
    final String updatedAt = DateTime.now().toIso8601String();
    final List<String> songs = [];
    final list = new ListDataModel(
      id: listId,
      name: name,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
      songs: songs,
    );
    final listData = list.toJson();
    sharedPreferences!.setString(listId, jsonEncode(listData));

    _updateListIds(listId);
  }

  // metodo per aggiungere una canzone alla lista
  void addSongToList(String listId, String songId) {
    final String? listData = sharedPreferences!.getString(listId);
    if (listData != null) {
      // final list = ListDataModel.fromJson(listData);
      // parsare listData in un Map<String, dynamic>
      // e poi creare un oggetto ListDataModel
      final list =
          ListDataModel.fromJson(jsonDecode(listData) as Map<String, dynamic>);
      // A questo punto list è un oggetto ListDataModel
      // Aggiungi la canzone alla lista
      list.songs.add(songId);
      final updatedListData = list.toJson();
      sharedPreferences!.setString(listId, jsonEncode(updatedListData));
    }
  }

  void removeSongFromList(String listId, String songId) {
    final String? listData = sharedPreferences!.getString(listId);
    if (listData != null) {
      final list =
          ListDataModel.fromJson(jsonDecode(listData) as Map<String, dynamic>);
      list.songs.remove(songId);
      final updatedListData = list.toJson();
      sharedPreferences!.setString(listId, jsonEncode(updatedListData));
    }
  }

  void deleteList(String listId) {
    sharedPreferences!.remove(listId);
    final raw = sharedPreferences!.getString(_allListIdsKey);
    if (raw != null) {
      final ids = List<String>.from(jsonDecode(raw));
      ids.remove(listId);
      sharedPreferences!.setString(_allListIdsKey, jsonEncode(ids));
    }
  }

  Future<List<ListDataModel>> loadAllLists() async {
    final prefs = sharedPreferences!;
    final raw = prefs.getString(_allListIdsKey);
    if (raw == null) return [];

    final ids = List<String>.from(jsonDecode(raw));
    final lists = <ListDataModel>[];
    for (final id in ids) {
      final data = prefs.getString(id);
      if (data != null) {
        lists.add(ListDataModel.fromJson(jsonDecode(data)));
      }
    }
    return lists;
  }
}
