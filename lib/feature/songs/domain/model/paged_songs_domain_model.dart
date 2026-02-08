import 'package:risuscito/feature/songs/domain/model/liturgical_index_domain_model.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';

class PagedSongsDomainModel {
  List<SongDomainModel>? alphabeticalOrder;
  List<SongDomainModel>? numericalOrder;
  List<SongDomainModel>? biblicalOrder;
  List<LiturgicalIndexDomainModel>? liturgicalOrder;

  PagedSongsDomainModel({
    this.alphabeticalOrder,
    this.numericalOrder,
    this.biblicalOrder,
    this.liturgicalOrder,
  });
}
