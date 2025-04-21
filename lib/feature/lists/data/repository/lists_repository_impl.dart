import 'package:dartz/dartz.dart';
import 'package:risuscito/core/infrastructure/error/handler.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:risuscito/feature/lists/data/datasource/lists_local_datasource.dart';
import 'package:risuscito/feature/lists/domain/model/list_domain_model.dart';
import 'package:risuscito/feature/lists/domain/repository/lists_repository.dart';
import 'package:risuscito/feature/songs/domain/utils/song_parser.dart';

class ListsRepositoryImpl implements ListsRepository {
  final ListsLocalDatasource listsLocalDatasource;
  final SongParser songParser;

  ListsRepositoryImpl({
    required this.listsLocalDatasource,
    required this.songParser,
  });

  @override
  Future<Either<Failure, List<ListDomainModel>>> getAllLists(
    String languageCode,
  ) async {
    try {
      final lists = await listsLocalDatasource.loadAllLists();

      final domainModelLists = await Future.wait(
        lists.map((list) async {
          return ListDomainModel(
            id: list.id,
            name: list.name,
            description: list.description,
            createdAt: DateTime.parse(list.createdAt),
            updatedAt: DateTime.parse(list.updatedAt),
            songs: await songParser.parseSongs(list.songs, languageCode),
          );
        }),
      );

      return Right(domainModelLists);
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }
}
