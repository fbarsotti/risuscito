import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';

class LiturgicalIndexDomainModel {
  final String categoryKey;
  final String categoryName;
  final List<SongDomainModel> songs;

  LiturgicalIndexDomainModel({
    required this.categoryKey,
    required this.categoryName,
    required this.songs,
  });
}
