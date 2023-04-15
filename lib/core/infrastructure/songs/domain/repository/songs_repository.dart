import 'package:dartz/dartz.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:risuscito/core/infrastructure/songs/domain/model/song_domain_model.dart';

mixin SongsRepository {
  Future<Either<Failure, List<SongDomainModel>>> getLocallizedSongs(
    String languageCode,
  );
}
