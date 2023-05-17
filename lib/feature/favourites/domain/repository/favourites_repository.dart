import 'package:dartz/dartz.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:risuscito/feature/songs/domain/model/paged_songs_domain_model.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';

mixin FavouritesRepository {
  Future<Either<Failure, List<SongDomainModel>>> getFavourites(
    String languageCode,
  );
}
