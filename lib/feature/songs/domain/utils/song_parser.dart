import 'dart:ui';

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:risuscito/feature/songs/data/datasource/songs_datasource.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';
import 'package:xml/xml.dart';

class SongParser {
  final SongsDatasource localDatasource;

  SongParser({required this.localDatasource});

  Future<List<SongDomainModel>> parseSongs(
    List<String> ids,
    String languageCode,
  ) async {
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

    // Build biblical ref lookup map
    final Map<String, String> biblicalMap = {};
    for (final ref in biblicalRefs) {
      final key =
          ref.getAttribute('name')!.replaceAll('_biblico', '').toLowerCase();
      biblicalMap[key] = ref.text;
    }

    for (final title in titles) {
      if (ids.contains(
        title.getAttribute('name')!.replaceAll('_title', '').toLowerCase(),
      )) {
        final id =
            title.getAttribute('name')!.replaceAll('_title', '').toLowerCase();
        final exists = await _checkIfSongExists(languageCode, id);
        if (exists) {
          final htmlContent =
              await localDatasource.getLocalizedSongPath(languageCode, id);
          final color = htmlContent.split('BGCOLOR="#')[1].substring(0, 6);
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
              htmlContent: htmlContent,
              url: await _getSongUrl(languageCode, id),
              color: Color(
                int.parse('0xff$color'),
              ),
              content: _extractBlackFontLines(htmlContent),
              biblicalRef: biblicalMap[id],
            ),
          );
        }
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
    return blackFontLines;
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
}
