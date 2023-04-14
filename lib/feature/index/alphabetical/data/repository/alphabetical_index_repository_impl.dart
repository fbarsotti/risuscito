import 'dart:io';

import 'package:risuscito/core/data/local/base_local_datasource.dart';
import 'package:risuscito/core/infrastructure/error/handler.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:risuscito/feature/index/alphabetical/domain/model/song_domain_model.dart';
import 'package:risuscito/feature/index/alphabetical/domain/repository/alphabetical_index_repository.dart';
import 'package:xml/xml.dart';

class AlphabeticalIndexRepositoryImpl implements AlphabeticalIndexRepository {
  final BaseLocalDatasource localDatasource;

  AlphabeticalIndexRepositoryImpl({
    required this.localDatasource,
  });
  @override
  Future<Either<Failure, List<SongDomainModel>>> getAlphabeticalIndexedSongs(
    String languageCode,
  ) async {
    try {
      // /core/data/song_values/values-it/titoli.xml
      final titlesContent =
          await localDatasource.getLocalizedTitlesFileContent(languageCode);

      List<SongDomainModel> songs = [];

      final document = XmlDocument.parse(titlesContent);
      final resourcesNode = document.findElements('resources').first;
      final resources = resourcesNode.findElements('string');
      for (final resource in resources) {
        songs.add(
          SongDomainModel(
            id: resource
                .getAttribute('name')!
                .replaceAll('_title', '')
                .toLowerCase(),
            title: resource.text,
            number: null,
          ),
        );
      }
      // parse on Datasource
      return Right(songs);
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }
}
