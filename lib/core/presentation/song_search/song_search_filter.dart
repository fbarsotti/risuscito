import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';

class SongSearchFilter {
  // Lowercased title/lyrics cached per song instance: lyrics are long, and
  // lowercasing all of them on every keystroke made lyrics search slow.
  static final Expando<String> _lowerTitles = Expando<String>();
  static final Expando<String> _lowerContents = Expando<String>();

  static String? _lowerTitle(SongDomainModel song) {
    if (song.title == null) return null;
    return _lowerTitles[song] ??= song.title!.toLowerCase();
  }

  static String? _lowerContent(SongDomainModel song) {
    if (song.content == null) return null;
    return _lowerContents[song] ??= song.content!.toLowerCase();
  }

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
          return _lowerTitle(song)?.contains(lowerQuery) ?? false;
        case 1:
          return _lowerContent(song)?.contains(lowerQuery) ?? false;
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
