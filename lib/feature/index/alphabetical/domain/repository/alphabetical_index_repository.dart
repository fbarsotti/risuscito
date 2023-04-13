import 'package:dartz/dartz.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:risuscito/feature/index/alphabetical/domain/model/song_domain_model.dart';

mixin AlphabeticalIndexRepository {
  Future<Either<Failure, List<SongDomainModel>>> getAlphabeticalIndexedSongs(
    String languageCode,
  );
}
