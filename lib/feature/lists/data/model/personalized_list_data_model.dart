class PersonalizedListDataModel {
  late String listId;
  late String listName;
  late List<String> songs;

  PersonalizedListDataModel({
    required this.listId,
    required this.listName,
    required this.songs,
  });

  PersonalizedListDataModel.fromJson(Map<String, dynamic> json) {
    listId = json['listId'];
    listName = json['listName'];
    songs = json['songs'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listId'] = this.listId;
    data['listName'] = this.listName;
    data['songs'] = this.songs;
    return data;
  }
}
