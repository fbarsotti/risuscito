import 'package:flutter/cupertino.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:risuscito/core/core_container.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/empty_page_message.dart';
import 'package:risuscito/feature/favourites/presentation/bloc/favourites_bloc.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_tile.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/infrastructure/localization/app_localizations.dart';

class LiturgicalIndexPage extends StatefulWidget {
  final String categoryName;
  final List<SongDomainModel> songs;

  const LiturgicalIndexPage({
    Key? key,
    required this.categoryName,
    required this.songs,
  }) : super(key: key);

  @override
  State<LiturgicalIndexPage> createState() => _LiturgicalIndexPageState();
}

class _LiturgicalIndexPageState extends State<LiturgicalIndexPage> {
  SharedPreferences prefs = rs();

  @override
  Widget build(BuildContext context) {
    final favSongIds = prefs.getStringList('favourites') ?? [];
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.translate('index')!,
        middle: Text(widget.categoryName),
      ),
      child: widget.songs.isEmpty
          ? SafeArea(
              child: Center(
                child: EmptyPageMessage(
                  icon: CupertinoIcons.calendar,
                  title:
                      AppLocalizations.of(context)!.translate('no_songs')!,
                  subtitle:
                      AppLocalizations.of(context)!.translate('no_songs_full')!,
                ),
              ),
            )
          : SafeArea(
              child: ListView.builder(
                itemCount: widget.songs.length,
                itemBuilder: (context, index) {
                  final song = widget.songs[index];
                  return SwipeActionCell(
                    key: ObjectKey(song),
                    trailingActions: [
                      SwipeAction(
                        color: favSongIds.contains(song.id!)
                            ? CupertinoColors.systemRed
                            : CupertinoColors.systemYellow,
                        icon: Icon(
                          favSongIds.contains(song.id!)
                              ? CupertinoIcons.trash
                              : CupertinoIcons.star_fill,
                          color: CupertinoColors.white,
                        ),
                        onTap: (CompletionHandler handler) async {
                          handler(false);
                          if (favSongIds.contains(song.id!)) {
                            BlocProvider.of<FavouritesBloc>(context).add(
                              RemoveFavourite(
                                songId: song.id!,
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
                                songId: song.id!,
                              ),
                            );
                          Fluttertoast.showToast(
                            msg: favSongIds.contains(song.id!)
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
                      song: song,
                      forceRef: false,
                      divider: index != widget.songs.length - 1,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
