import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/infrastructure/error/handler.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:risuscito/core/infrastructure/error/types/successes.dart';
import 'package:risuscito/feature/favourites/data/datasource/favourites_local_datasource.dart';
import 'package:risuscito/feature/favourites/domain/repository/favourites_repository.dart';
import 'package:risuscito/feature/songs/data/datasource/songs_datasource.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_tile.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:xml/xml.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  final FavouritesLocalDatasource favouritesLocalDatasource;
  final SongsDatasource localDatasource;

  FavouritesRepositoryImpl({
    required this.localDatasource,
    required this.favouritesLocalDatasource,
  });

  int _alphabeticalComparison(SongDomainModel a, SongDomainModel b) {
    return a.title!.compareTo(b.title!);
  }

  @override
  Future<Either<Failure, List<SongDomainModel>>> getFavourites(
    String languageCode,
  ) async {
    try {
      final favSongsId = favouritesLocalDatasource.getFavourites();
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
        if (favSongsId.contains(
          title.getAttribute('name')!.replaceAll('_title', '').toLowerCase(),
        )) {
          final id = title
              .getAttribute('name')!
              .replaceAll('_title', '')
              .toLowerCase();
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
                content: null,
              ),
            );
          }
        }
      }
      songs.sort(_alphabeticalComparison);
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

  @override
  Future<Either<Failure, List<SongDomainModel>>> saveFavourite(
    String languageCode,
    String songId,
  ) async {
    await favouritesLocalDatasource.saveFavourite(songId);
    return await getFavourites(languageCode);
  }

  @override
  Future<Either<Failure, Success>> removeFavourite(
    String songId,
  ) async {
    try {
      await favouritesLocalDatasource.removeFavourite(songId);
      return Right(Success());
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }
}
