import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risuscito/core/infrastructure/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/core/infrastructure/songs/presentation/bloc/songs_bloc.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/song/song_page.dart';
import 'package:risuscito/core/presentation/song/song_tile.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../../../core/infrastructure/localization/app_localizations.dart';
import '../../../core/presentation/states/rs_failure_view.dart';

class AlphabeticalIndexPage extends StatelessWidget {
  const AlphabeticalIndexPage({Key? key}) : super(key: key);

  int _alphabeticalComparison(SongDomainModel a, SongDomainModel b) {
    return a.title!.compareTo(b.title!);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.translate('index')!,
        middle: Text(
            AppLocalizations.of(context)!.translate('alphabetical_index')!),
      ),
      child: BlocBuilder<SongsBloc, SongsState>(
        builder: (context, state) {
          if (state is SongsFailure)
            return RSFailureView(failure: state.failure);
          if (state is SongsLoaded) {
            state.songs.sort(_alphabeticalComparison); // sort list by index
            final songs = state.songs;
            return SafeArea(
              child: SingleChildScrollView(
                child: CupertinoListSection(children: [
                  Container(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CupertinoInkWell(
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: CupertinoColors.activeBlue,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.textformat_abc),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text('Indice prova'),
                                ],
                              ),
                              padding: EdgeInsets.all(6.0),
                            ),
                          ),
                          onTap: () {},
                          // deleteIcon: Icon(CupertinoIcons.add),
                          // onDeleted: () => ,
                        ),
                      ],
                    ),
                  ),
                  ...List.generate(
                    songs.length,
                    (index) => SongTile(
                      song: songs[index],
                    ),
                  ),
                ]),
              ),
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