import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:risuscito/core/core_container.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/feature/favourites/presentation/bloc/favourites_bloc.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_tile.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/feature/songs/presentation/bloc/songs_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/infrastructure/localization/app_localizations.dart';
import '../../../core/presentation/states/rs_failure_view.dart';

class BiblicalIndexPage extends StatefulWidget {
  const BiblicalIndexPage({Key? key}) : super(key: key);

  @override
  State<BiblicalIndexPage> createState() => _BiblicalIndexPageState();
}

class _BiblicalIndexPageState extends State<BiblicalIndexPage> {
  late List<SongDomainModel> songs;
  SharedPreferences prefs = rs();

  @override
  Widget build(BuildContext context) {
    final favSongIds = prefs.getStringList('favourites') ?? [];
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.translate('index')!,
        middle:
            Text(AppLocalizations.of(context)!.translate('biblical_index')!),
      ),
      child: BlocBuilder<SongsBloc, SongsState>(
        builder: (context, state) {
          if (state is SongsFailure)
            return RSFailureView(failure: state.failure);
          if (state is SongsLoaded) {
            songs = state.songs.biblicalOrder!;
            return SafeArea(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) => SwipeActionCell(
                  key: ObjectKey(songs[index]),
                  trailingActions: [
                    SwipeAction(
                      color: favSongIds.contains(songs[index].id!)
                          ? CupertinoColors.systemRed
                          : CupertinoColors.systemYellow,
                      icon: Icon(
                        favSongIds.contains(songs[index].id!)
                            ? CupertinoIcons.trash
                            : CupertinoIcons.text_badge_star,
                        color: CupertinoColors.white,
                      ),
                      onTap: (CompletionHandler handler) async {
                        handler(false);
                        if (favSongIds.contains(songs[index].id!)) {
                          BlocProvider.of<FavouritesBloc>(context).add(
                            RemoveFavourite(
                              songId: songs[index].id!,
                              reload: true,
                              languageCode: AppLocalizations.of(context)!
                                  .locale
                                  .languageCode,
                            ),
                          );
                        } else
                          BlocProvider.of<FavouritesBloc>(context).add(
                            SaveFavourite(
                              languageCode: AppLocalizations.of(context)!
                                  .locale
                                  .languageCode,
                              songId: songs[index].id!,
                            ),
                          );
                        Fluttertoast.showToast(
                          msg: favSongIds.contains(songs[index].id!)
                              ? AppLocalizations.of(context)!
                                  .translate('favourite_removed')!
                              : AppLocalizations.of(context)!
                                  .translate('favourite_added')!,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 2,
                          backgroundColor:
                              RSColors.cardColorDark.withOpacity(0.95),
                          textColor: CupertinoColors.white,
                          fontSize: 16.0,
                        );
                        setState(() {});
                      },
                    )
                  ],
                  child: SongTile(
                    song: songs[index],
                    forceRef: false,
                    divider: index != songs.length - 1,
                  ),
                ),
              ),
              // child: CupertinoListSection(
              //   children: [
              //     ...List.generate(
              //       songs.length,
              //       (index) => SongTile(
              //         song: songs[index],
              //         forceRef: false,
              //       ),
              //     ),
              //   ],
              // ),
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