import 'package:dartz/dartz.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:risuscito/core/infrastructure/songs/domain/model/paged_songs_domain_model.dart';
import 'package:risuscito/core/infrastructure/songs/domain/model/song_domain_model.dart';

mixin SongsRepository {
  Future<Either<Failure, PagedSongsDomainModel>> getLocalizedSongs(
    String languageCode,
  );
}
