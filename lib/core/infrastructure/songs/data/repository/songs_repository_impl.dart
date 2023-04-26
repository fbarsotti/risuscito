import 'dart:io';
import 'package:flutter/services.dart';
import 'package:risuscito/core/infrastructure/songs/data/datasource/songs_datasource.dart';
import 'package:risuscito/core/infrastructure/error/handler.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:risuscito/core/infrastructure/songs/domain/model/paged_songs_domain_model.dart';
import 'package:risuscito/core/infrastructure/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/core/infrastructure/songs/domain/repository/songs_repository.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:xml/xml.dart';

class SongsRepositoryImpl implements SongsRepository {
  final SongsDatasource localDatasource;

  SongsRepositoryImpl({
    required this.localDatasource,
  });

  int _alphabeticalComparison(SongDomainModel a, SongDomainModel b) {
    return a.title!.compareTo(b.title!);
  }

  int _numericalComparison(SongDomainModel a, SongDomainModel b) {
    return int.parse(a.number!) < int.parse(b.number!)
        ? -1
        : int.parse(a.number!) > int.parse(b.number!)
            ? 1
            : 0;
  }

  @override
  Future<Either<Failure, PagedSongsDomainModel>> getLocalizedSongs(
    String languageCode,
  ) async {
    try {
      List<SongDomainModel> songs = [];

      final titlesContent =
          await localDatasource.getLocalizedTitlesFileContent(languageCode);
      final pagesContent =
          await localDatasource.getLocalizedPagesFileContent(languageCode);

      final titlesDocument = XmlDocument.parse(titlesContent);
      final pagesDocument = XmlDocument.parse(pagesContent);

      final titlesNode = titlesDocument.findElements('resources').first;
      final titles = titlesNode.findElements('string');

      final pagesNode = pagesDocument.findElements('resources').first;
      final pages = pagesNode.findElements('string');

      for (final title in titles) {
        final id =
            title.getAttribute('name')!.replaceAll('_title', '').toLowerCase();
        final exists = await _checkIfSongExists(languageCode, id);
        if (exists) {
          final content =
              await localDatasource.getLocalizedSongPath(languageCode, id);
          final color = content.split('BGCOLOR="#')[1].substring(0, 6);
          songs.add(
            SongDomainModel(
              id: id,
              title: title.text,
              number: pages
                  .where(
                    (element) =>
                        element
                            .getAttribute('name')!
                            .replaceAll('_page', '')
                            .toLowerCase() ==
                        id,
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
      }

      final biblicalOrder = await getLocalizedSongsBiblical(languageCode);
      for (final biblicalRef in biblicalOrder) {
        songs[songs.indexWhere((element) => element.id == biblicalRef.id)]
            .biblicalRef = biblicalRef.title;
      }
      songs.sort(_alphabeticalComparison);
      final alphabeticalOrder = new List<SongDomainModel>.from(songs);
      songs.sort(_numericalComparison);
      final numericalOrder = new List<SongDomainModel>.from(songs);

      PagedSongsDomainModel pagedSongs = PagedSongsDomainModel(
        alphabeticalOrder: alphabeticalOrder,
        numericalOrder: numericalOrder,
        biblicalOrder: biblicalOrder,
      );
      return Right(pagedSongs);
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  Future<List<SongDomainModel>> getLocalizedSongsBiblical(
    String languageCode,
  ) async {
    List<SongDomainModel> songs = [];

    final pagesContent =
        await localDatasource.getLocalizedPagesFileContent(languageCode);
    final biblicalContent =
        await localDatasource.getLocalizedBiblicalRefsFileContent(languageCode);

    final pagesDocument = XmlDocument.parse(pagesContent);
    final biblicalDocument = XmlDocument.parse(biblicalContent);

    final pagesNode = pagesDocument.findElements('resources').first;
    final pages = pagesNode.findElements('string');

    final biblicalNode = biblicalDocument.findElements('resources').first;
    final biblicalRefs = biblicalNode.findElements('string');

    for (final biblicalRef in biblicalRefs) {
      var id = biblicalRef
          .getAttribute('name')!
          .replaceAll('_biblico', '')
          .toLowerCase();
      final exists = await _checkIfSongExists(languageCode, id);
      if (exists) {
        if (id.contains('_ii') &&
            pages
                .where((element) =>
                    element
                        .getAttribute('name')!
                        .replaceAll('_page', '')
                        .toLowerCase() ==
                    id)
                .isEmpty) id = id.split('_ii')[0];
        final content =
            await localDatasource.getLocalizedSongPath(languageCode, id);
        final color = content.split('BGCOLOR="#')[1].substring(0, 6);
        songs.add(
          SongDomainModel(
            id: id,
            title: biblicalRef.text,
            number: pages
                .where(
                  (element) =>
                      element
                          .getAttribute('name')!
                          .replaceAll('_page', '')
                          .toLowerCase() ==
                      id,
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
    }
    return songs;
  }

  Future<bool> _checkIfSongExists(String languageCode, String songId) async {
    final sourcesContent =
        await localDatasource.getLocalizedSongSources(languageCode);
    final sourcesDocument = XmlDocument.parse(sourcesContent);
    final sourcesNode = sourcesDocument.findElements('resources').first;
    final sources = sourcesNode.findElements('string');

    for (final source in sources) {
      if (source.text == songId) return true;
    }
    return false;
  }
}
