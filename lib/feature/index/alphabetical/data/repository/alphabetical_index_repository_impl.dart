import 'dart:io';

import 'package:risuscito/core/data/local/local_datasource.dart';
import 'package:risuscito/core/infrastructure/error/handler.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:risuscito/feature/index/alphabetical/domain/model/song_domain_model.dart';
import 'package:risuscito/feature/index/alphabetical/domain/repository/alphabetical_index_repository.dart';
import 'package:xml/xml.dart';

class AlphabeticalIndexRepositoryImpl implements AlphabeticalIndexRepository {
  final LocalDatasource localDatasource;

  AlphabeticalIndexRepositoryImpl({
    required this.localDatasource,
  });
  @override
  Future<Either<Failure, List<SongDomainModel>>>
      getAlphabeticalIndexedSongs() async {
    try {
      var path = await localDatasource.getPath();
      // /core/data/song_values/values-it/titoli.xml
      final file = new File(path);
      final document = XmlDocument.parse(file.readAsStringSync());
      // parse on Datasource
      return Right([]);
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }
}
