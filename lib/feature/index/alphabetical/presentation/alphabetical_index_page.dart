import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:xml/xml.dart';

import '../../../../../../core/infrastructure/localization/app_localizations.dart';
import '../../../../core/presentation/states/rs_failure_view.dart';
import '../domain/model/song_domain_model.dart';
import 'bloc/alphabetical_index_bloc.dart';

class AlphabeticalIndexPage extends StatefulWidget {
  const AlphabeticalIndexPage({Key? key}) : super(key: key);

  @override
  State<AlphabeticalIndexPage> createState() => _AlphabeticalIndexPageState();
}

class _AlphabeticalIndexPageState extends State<AlphabeticalIndexPage> {
  @override
  void initState() {
    super.initState();
    //final code = AppLocalizations.of(context)!.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.translate('index')!,
        middle: Text(
            AppLocalizations.of(context)!.translate('alphabetical_index')!),
      ),
      child: BlocBuilder<AlphabeticalIndexBloc, AlphabeticalIndexState>(
        builder: (context, state) {
          if (state is AlphabeticalIndexFailure)
            return RSFailureView(failure: state.failure);
          if (state is AlphabeticalIndexLoaded) {
            final songs = state.songs;
            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return CupertinoListTile(title: Text(songs[index].title!));
              },
            );
          } else
            return RSLoadingView();
        },
      ),
    );
  }
}


// ListView.builder(
//         itemCount: songs.length,
//         itemBuilder: (context, index) {
//           return CupertinoListTile(title: Text(songs[index].title!));
//         },
//       ),