import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/song/song_page.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import '../../../../../../core/infrastructure/localization/app_localizations.dart';
import '../../../../core/presentation/states/rs_failure_view.dart';
import 'bloc/alphabetical_index_bloc.dart';

class AlphabeticalIndexPage extends StatelessWidget {
  const AlphabeticalIndexPage({Key? key}) : super(key: key);

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
            return SafeArea(
              child: SingleChildScrollView(
                child: CupertinoListSection(
                  children: List.generate(
                    songs.length,
                    (index) => CupertinoListTile(
                      leadingSize: 40,
                      leading: CircleAvatar(
                        radius: 200,
                        backgroundColor: RSColors.white,
                        child: Text(
                          '99',
                          style: TextStyle(
                            color: RSColors.text,
                          ),
                        ),
                      ),
                      trailing: Icon(CupertinoIcons.chevron_right,
                          color: CupertinoColors.systemGrey),
                      title: Container(
                        height: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              songs[index].title!,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(
                            builder: (context) => SongPage(
                              songId: songs[index].id!,
                              languageCode: AppLocalizations.of(context)!
                                  .locale
                                  .languageCode,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
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