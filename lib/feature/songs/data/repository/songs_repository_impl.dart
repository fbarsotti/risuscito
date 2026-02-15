import 'package:flutter/services.dart';
import 'package:risuscito/core/infrastructure/error/handler.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:risuscito/feature/songs/data/datasource/songs_datasource.dart';
import 'package:risuscito/feature/songs/domain/repository/songs_repository.dart';
// import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import '../../domain/model/liturgical_index_domain_model.dart';
import '../../domain/model/paged_songs_domain_model.dart';
import '../../domain/model/song_domain_model.dart';

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

      // Parse sorgenti.xml and link.xml once instead of per-song
      final existingSongIds = await _loadExistingSongIds(languageCode);
      final songUrls = await _loadSongUrls(languageCode);

      // Build pages lookup map for O(1) access
      final Map<String, String> pagesMap = {};
      for (final page in pages) {
        final key = page.getAttribute('name')!.replaceAll('_page', '').toLowerCase();
        pagesMap[key] = page.text;
      }

      for (final title in titles) {
        final id =
            title.getAttribute('name')!.replaceAll('_title', '').toLowerCase();
        final exists = existingSongIds.contains(id);
        if (exists) {
          final content =
              await localDatasource.getLocalizedSongPath(languageCode, id);
          final color = content.split('BGCOLOR="#')[1].substring(0, 6);
          songs.add(
            SongDomainModel(
              id: id,
              title: title.text,
              number: pagesMap[id] ?? '',
              htmlContent: content,
              url: songUrls[id],
              color: Color(
                int.parse('0xff$color'),
              ),
              content: _extractBlackFontLines(content),
            ),
          );
        }
      }

      final biblicalOrder = await getLocalizedSongsBiblical(
        languageCode,
        existingSongIds: existingSongIds,
      );
      for (final biblicalRef in biblicalOrder) {
        songs[songs.indexWhere((element) => element.id == biblicalRef.id)]
            .biblicalRef = biblicalRef.title;
      }
      songs.sort(_alphabeticalComparison);
      final alphabeticalOrder = new List<SongDomainModel>.from(songs);
      songs.sort(_numericalComparison);
      final numericalOrder = new List<SongDomainModel>.from(songs);

      final liturgicalOrder = await getLocalizedSongsLiturgical(
        languageCode,
        alphabeticalOrder,
      );

      PagedSongsDomainModel pagedSongs = PagedSongsDomainModel(
        alphabeticalOrder: alphabeticalOrder,
        numericalOrder: numericalOrder,
        biblicalOrder: biblicalOrder,
        liturgicalOrder: liturgicalOrder,
      );
      return Right(pagedSongs);
    } catch (e, s) {
      return Left(handleError(e, s));
    }
  }

  Future<List<SongDomainModel>> getLocalizedSongsBiblical(
    String languageCode, {
    Set<String>? existingSongIds,
  }) async {
    List<SongDomainModel> songs = [];

    final titlesContent =
        await localDatasource.getLocalizedTitlesFileContent(languageCode);
    final pagesContent =
        await localDatasource.getLocalizedPagesFileContent(languageCode);
    final biblicalContent =
        await localDatasource.getLocalizedBiblicalRefsFileContent(languageCode);

    final titlesDocument = XmlDocument.parse(titlesContent);
    final pagesDocument = XmlDocument.parse(pagesContent);
    final biblicalDocument = XmlDocument.parse(biblicalContent);

    final titlesNode = titlesDocument.findElements('resources').first;
    final titles = titlesNode.findElements('string');

    final pagesNode = pagesDocument.findElements('resources').first;
    final pages = pagesNode.findElements('string');

    final biblicalNode = biblicalDocument.findElements('resources').first;
    final biblicalRefs = biblicalNode.findElements('string');

    // Reuse pre-loaded set or load once
    existingSongIds ??= await _loadExistingSongIds(languageCode);

    // Build pages lookup map for O(1) access
    final Map<String, String> pagesMap = {};
    for (final page in pages) {
      final key = page.getAttribute('name')!.replaceAll('_page', '').toLowerCase();
      pagesMap[key] = page.text;
    }

    // Build titles lookup map
    final Map<String, String> titlesMap = {};
    for (final title in titles) {
      final key = title.getAttribute('name')!.replaceAll('_title', '').toLowerCase();
      titlesMap[key] = title.text;
    }

    // Load song URLs once
    final songUrls = await _loadSongUrls(languageCode);

    for (final biblicalRef in biblicalRefs) {
      var id = biblicalRef
          .getAttribute('name')!
          .replaceAll('_biblico', '')
          .toLowerCase();
      final exists = existingSongIds.contains(id);
      if (exists) {
        if (id.contains('_ii') && !pagesMap.containsKey(id)) {
          id = id.split('_ii')[0];
        }
        final content =
            await localDatasource.getLocalizedSongPath(languageCode, id);
        final color = content.split('BGCOLOR="#')[1].substring(0, 6);
        songs.add(
          SongDomainModel(
            id: id,
            title: titlesMap[id] ?? biblicalRef.text,
            biblicalRef: biblicalRef.text,
            number: pagesMap[id] ?? '',
            htmlContent: content,
            url: songUrls[id],
            color: Color(
              int.parse('0xff$color'),
            ),
            content: _extractBlackFontLines(content),
          ),
        );
      }
    }
    return songs;
  }

  Future<List<LiturgicalIndexDomainModel>> getLocalizedSongsLiturgical(
    String languageCode,
    List<SongDomainModel> allSongs,
  ) async {
    final namesContent =
        await localDatasource.getLocalizedLiturgicalNamesContent(languageCode);
    final indexContent =
        await localDatasource.getLocalizedLiturgicalIndexContent(languageCode);

    final namesDocument = XmlDocument.parse(namesContent);
    final namesNode = namesDocument.findElements('resources').first;
    final names = namesNode.findElements('string');

    // Build categoryKey -> categoryName map
    final Map<String, String> categoryNames = {};
    for (final name in names) {
      final key = name.getAttribute('name')!;
      categoryNames[key] = name.text.replaceAll('\\', '');
    }

    final indexDocument = XmlDocument.parse(indexContent);
    final indexNode = indexDocument.findElements('resources').first;
    final arrays = indexNode.findElements('string-array');

    // Build a map of song ID -> SongDomainModel for quick lookup
    final Map<String, SongDomainModel> songMap = {};
    for (final song in allSongs) {
      if (song.id != null) {
        songMap[song.id!] = song;
      }
    }

    final List<LiturgicalIndexDomainModel> result = [];
    for (final array in arrays) {
      final categoryKey = array.getAttribute('name')!;
      final items = array.findElements('item');
      final List<SongDomainModel> categorySongs = [];

      for (final item in items) {
        final songId = item.text.toLowerCase();
        if (songMap.containsKey(songId)) {
          categorySongs.add(songMap[songId]!);
        }
      }

      if (categorySongs.isNotEmpty && categoryNames.containsKey(categoryKey)) {
        result.add(LiturgicalIndexDomainModel(
          categoryKey: categoryKey,
          categoryName: _toTitleCase(categoryNames[categoryKey]!),
          songs: categorySongs,
        ));
      }
    }

    return result;
  }

  Future<Set<String>> _loadExistingSongIds(String languageCode) async {
    final sourcesContent =
        await localDatasource.getLocalizedSongSources(languageCode);
    final sourcesDocument = XmlDocument.parse(sourcesContent);
    final sourcesNode = sourcesDocument.findElements('resources').first;
    final sources = sourcesNode.findElements('string');
    return sources.map((source) => source.text).toSet();
  }

  Future<Map<String, String>> _loadSongUrls(String languageCode) async {
    final sourcesContent =
        await localDatasource.getLocalizedSongLinks(languageCode);
    final sourcesDocument = XmlDocument.parse(sourcesContent);
    final sourcesNode = sourcesDocument.findElements('resources').first;
    final sources = sourcesNode.findElements('string');

    final Map<String, String> urls = {};
    for (final source in sources) {
      final key = source.getAttribute('name')!.replaceAll('_link', '').toLowerCase();
      urls[key] = source.text;
    }
    return urls;
  }

  String _toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String _extractBlackFontLines(String html) {
    dom.Document document = parse(html);
    List<dom.Element> preElements = document.querySelectorAll('h3 pre');
    String blackFontLines = '';

    for (dom.Element preElement in preElements) {
      List<dom.Element> textElements = preElement.getElementsByTagName('font');
      for (dom.Element textElement in textElements) {
        if (textElement.attributes['color'] == '#000000') {
          String line = textElement.text.trim();
          if (line.isNotEmpty) {
            blackFontLines += ' ' + line;
          }
        }
      }
    }
    //.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ')
    return blackFontLines;
  }
}
