import 'package:dartz/dartz.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:risuscito/core/infrastructure/error/types/successes.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';

mixin HistoryRepository {
  Future<Either<Failure, List<SongDomainModel>>> getHistory(
    String languageCode,
  );

  Future<Either<Failure, List<SongDomainModel>>> saveInHistory(
    String languageCode,
    String songId,
  );

  Future<Either<Failure, Success>> removeFromHistory(
    String songId,
  );

  Future<Either<Failure, Success>> deleteHistory();
}
