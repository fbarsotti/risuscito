import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';

class ListDomainModel {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SongDomainModel>? songs;

  ListDomainModel({
    required this.songs,
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  String toString() {
    return 'ListDomainModel{id: $id, name: $name, description: $description, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
