import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';

import '../../../../../../core/infrastructure/localization/app_localizations.dart';
import '../domain/model/song_domain_model.dart';

class AlphabeticalIndexPage extends StatefulWidget {
  const AlphabeticalIndexPage({Key? key}) : super(key: key);

  @override
  State<AlphabeticalIndexPage> createState() => _AlphabeticalIndexPageState();
}

class _AlphabeticalIndexPageState extends State<AlphabeticalIndexPage> {
  List<SongDomainModel> songs = [];

  @override
  void initState() {
    super.initState();
    //final code = AppLocalizations.of(context)!.locale.languageCode;
    final file =
        new File('../../../core/data/song_values/values-it/titoli.xml');
    final document = XmlDocument.parse(file.readAsStringSync());
    final resourcesNode = document.findElements('resources').first;
    final resources = resourcesNode.findElements('string');
    for (final resource in resources) {
      songs.add(SongDomainModel(
        id: null,
        title: resource.text,
        number: null,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.translate('index')!,
        middle: Text(
            AppLocalizations.of(context)!.translate('alphabetical_index')!),
      ),
      child: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return CupertinoListTile(title: Text(songs[index].title!));
        },
      ),
    );
  }
}
