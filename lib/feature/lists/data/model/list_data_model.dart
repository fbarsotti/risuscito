class ListDataModel {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;
  List<String> songs;

  ListDataModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.songs,
  });

  factory ListDataModel.fromJson(Map<String, dynamic> json) {
    return ListDataModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      songs: List<String>.from(json['songs'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'songs': songs,
    };
  }
}
