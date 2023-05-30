import 'package:dartz/dartz.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:risuscito/core/infrastructure/error/types/successes.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';

mixin FavouritesRepository {
  Future<Either<Failure, List<SongDomainModel>>> getFavourites(
    String languageCode,
  );

  Future<Either<Failure, List<SongDomainModel>>> saveFavourite(
    String languageCode,
    String songId,
  );

  Future<Either<Failure, Success>> removeFavourite(
    String songId,
  );
}
