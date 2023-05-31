import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/infrastructure/error/handler.dart';
import 'package:risuscito/core/infrastructure/error/types/successes.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:risuscito/feature/history/data/datasource/history_local_datasource.dart';
import 'package:risuscito/feature/history/domain/repository/history_repository.dart';
import 'package:risuscito/feature/songs/data/datasource/songs_datasource.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';
import 'package:xml/xml.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDatasource historyLocalDatasource;
  final SongsDatasource localDatasource;

  HistoryRepositoryImpl({
    required this.historyLocalDatasource,
    required this.localDatasource,
  });
  @override
  Future<Either<Failure, List<SongDomainModel>>> getHistory(
      String languageCode) async {
    try {
      final historySongs = historyLocalDatasource.getHistory();
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

      for (final id in historySongs) {
        final exists = await _checkIfSongExists(languageCode, id);
        if (exists) {
          final content =
              await localDatasource.getLocalizedSongPath(languageCode, id);
          final color = content.split('BGCOLOR="#')[1].substring(0, 6);
          songs.add(
            SongDomainModel(
              id: id,
              title: titles
                  .where(
                    (element) =>
                        element
                            .getAttribute('name')!
                            .replaceAll('_title', '')
                            .toLowerCase() ==
                        id,
                  )
                  .first
                  .text,
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
              htmlContent: content,
              // songWebView: WebViewPlus(
              //   javascriptMode: JavascriptMode.unrestricted,
              //   backgroundColor: Color(int.parse('0xff$color')),
              //   onWebViewCreated: (controller) {
              //     controller.loadString(content);
              //   },
              // ),
              url: await _getSongUrl(languageCode, id),
              color: Color(
                int.parse('0xff$color'),
              ),
              content: null,
            ),
          );
        }
      }
      return Right(songs);
    } catch (e, s) {
      return Left(handleError(e, s));
    }
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

  Future<String?> _getSongUrl(String languageCode, String songId) async {
    final sourcesContent =
        await localDatasource.getLocalizedSongLinks(languageCode);
    final sourcesDocument = XmlDocument.parse(sourcesContent);
    final sourcesNode = sourcesDocument.findElements('resources').first;
    final sources = sourcesNode.findElements('string');

    for (final source in sources) {
      if (source.getAttribute('name')!.replaceAll('_link', '').toLowerCase() ==
          songId) return source.text;
    }
    return null;
  }

  @override
  Future<Either<Failure, List<SongDomainModel>>> saveInHistory(
    String languageCode,
    String songId,
  ) async {
    await historyLocalDatasource.saveInHistory(songId);
    return getHistory(languageCode);
  }

  @override
  Future<Either<Failure, Success>> removeFromHistory(String songId) async {
    try {
      await historyLocalDatasource.removeFromHistory(songId);
      return Right(Success());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  @override
  Future<Either<Failure, Success>> deleteHistory() async {
    try {
      await historyLocalDatasource.deleteHistory();
      return Right(Success());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }
}
