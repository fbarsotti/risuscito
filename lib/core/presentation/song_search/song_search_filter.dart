import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';

class SongSearchFilter {
  /// Filters a list of songs based on [query] and [selectedTag].
  /// Tag 0 = title, 1 = lyrics, 2 = biblical reference.
  /// Returns all songs when [query] is empty.
  static List<SongDomainModel> filter({
    required List<SongDomainModel> songs,
    required String query,
    required int selectedTag,
  }) {
    if (query.isEmpty) return songs;
    final lowerQuery = query.toLowerCase();
    return songs.where((song) {
      switch (selectedTag) {
        case 0:
          return song.title?.toLowerCase().contains(lowerQuery) ?? false;
        case 1:
          return song.content?.toLowerCase().contains(lowerQuery) ?? false;
        case 2:
          if (song.biblicalRef == null) return false;
          return song.biblicalRef!
              .split(' - ')[0]
              .toLowerCase()
              .contains(lowerQuery);
        default:
          return false;
      }
    }).toList();
  }
}
