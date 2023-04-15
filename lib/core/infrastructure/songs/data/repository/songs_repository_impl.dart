import 'dart:io';
import 'package:flutter/services.dart';
import 'package:risuscito/core/infrastructure/songs/data/datasource/songs_datasource.dart';
import 'package:risuscito/core/infrastructure/error/handler.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:risuscito/core/infrastructure/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/core/infrastructure/songs/domain/repository/songs_repository.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:xml/xml.dart';

class SongsRepositoryImpl implements SongsRepository {
  final SongsDatasource localDatasource;

  SongsRepositoryImpl({
    required this.localDatasource,
  });
  @override
  Future<Either<Failure, List<SongDomainModel>>> getLocallizedSongs(
    String languageCode,
  ) async {
    try {
      // /core/data/song_values/values-it/titoli.xml
      final titlesContent =
          await localDatasource.getLocalizedTitlesFileContent(languageCode);
      final pagesContent =
          await localDatasource.getLocalizedPagesFileContent(languageCode);
      List<SongDomainModel> songs = [];

      final titlesDocument = XmlDocument.parse(titlesContent);
      final pagesDocument = XmlDocument.parse(pagesContent);

      final titlesNode = titlesDocument.findElements('resources').first;
      final titles = titlesNode.findElements('string');

      final pagesNode = pagesDocument.findElements('resources').first;
      final pages = pagesNode.findElements('string');

      for (final title in titles) {
        final content = await localDatasource.getLocalizedSongPath(
          languageCode,
          title.getAttribute('name')!.replaceAll('_title', '').toLowerCase(),
        );
        final color = content.split('BGCOLOR="#')[1].substring(0, 6);
        print(color);
        songs.add(
          SongDomainModel(
            id: title
                .getAttribute('name')!
                .replaceAll('_title', '')
                .toLowerCase(),
            title: title.text,
            number: pages
                .where(
                  (element) =>
                      element
                          .getAttribute('name')!
                          .replaceAll('_page', '')
                          .toLowerCase() ==
                      title
                          .getAttribute('name')!
                          .replaceAll('_title', '')
                          .toLowerCase(),
                )
                .first
                .text,
            songWebView: WebViewPlus(
              javascriptMode: JavascriptMode.unrestricted,
              backgroundColor: Color(int.parse('0xff$color')),
              onWebViewCreated: (controller) {
                controller.loadString(content);
              },
            ),
            color: Color(
              int.parse('0xff$color'),
            ),
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
