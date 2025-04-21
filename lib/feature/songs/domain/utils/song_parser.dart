import 'dart:ui';

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

    final titlesDocument = XmlDocument.parse(titlesContent);
    final pagesDocument = XmlDocument.parse(pagesContent);

    final titlesNode = titlesDocument.findElements('resources').first;
    final titles = titlesNode.findElements('string');

    final pagesNode = pagesDocument.findElements('resources').first;
    final pages = pagesNode.findElements('string');

    for (final title in titles) {
      if (ids.contains(
        title.getAttribute('name')!.replaceAll('_title', '').toLowerCase(),
      )) {
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
