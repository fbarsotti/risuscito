import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';

class PagedSongsDomainModel {
  List<SongDomainModel>? alphabeticalOrder;
  List<SongDomainModel>? numericalOrder;
  List<SongDomainModel>? biblicalOrder;

  PagedSongsDomainModel({
    this.alphabeticalOrder,
    this.numericalOrder,
    this.biblicalOrder,
  });
}
