class SongDomainModel {
  String? id;
  String? title;
  int? number;

  SongDomainModel({
    this.id,
    this.title,
    this.number,
  });

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is SongDomainModel &&
  //       other.id == id &&
  //       other.title == title &&
  //       other.number == number;
  // }
}
