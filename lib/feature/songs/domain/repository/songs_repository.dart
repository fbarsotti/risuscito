import 'package:dartz/dartz.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';

import '../model/paged_songs_domain_model.dart';

mixin SongsRepository {
  Future<Either<Failure, PagedSongsDomainModel>> getLocalizedSongs(
    String languageCode,
  );
}
