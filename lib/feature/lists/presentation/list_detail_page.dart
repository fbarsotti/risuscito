import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:risuscito/core/core_container.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/empty_page_message.dart';
import 'package:risuscito/core/presentation/song_search/song_search_bar.dart';
import 'package:risuscito/core/presentation/song_search/song_search_filter.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:risuscito/feature/favourites/presentation/bloc/favourites_bloc.dart';
import 'package:risuscito/feature/lists/domain/model/list_domain_model.dart';
import 'package:risuscito/feature/lists/presentation/bloc/lists_bloc.dart';
import 'package:risuscito/feature/lists/presentation/list_add_song_page.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListDetailPage extends StatefulWidget {
  final ListDomainModel list;

  const ListDetailPage({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<ListDetailPage> createState() => _ListDetailPageState();
}

class _ListDetailPageState extends State<ListDetailPage> {
  late ListDomainModel currentList;
  final TextEditingController _searchController = TextEditingController();
  int _selectedTag = 0;
  SharedPreferences prefs = rs();

  @override
  void initState() {
    super.initState();
    currentList = widget.list;
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favSongIds = prefs.getStringList('favourites') ?? [];
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(currentList.name),
        previousPageTitle:
            AppLocalizations.of(context)!.translate('personalized_lists'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => ListAddSongPage(
                  list: currentList,
                ),
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        child: BlocConsumer<ListsBloc, ListsState>(
          listener: (context, state) {
            if (state is ListsInfoLoaded) {
              setState(() {
                currentList = state.list;
              });
            }
          },
          buildWhen: (previous, current) => current is! ListsLoaded,
          builder: (context, state) {
            final songs = currentList.songs ?? [];
            if (state is ListsLoading) {
              return RSLoadingView();
            }
            if (songs.isEmpty) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        child: EmptyPageMessage(
                          icon: CupertinoIcons.music_note_list,
                          title: AppLocalizations.of(context)!
                              .translate('no_songs_in_list')!,
                          subtitle: AppLocalizations.of(context)!
                              .translate('no_songs_in_list_full')!,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            final filteredSongs = SongSearchFilter.filter(
              songs: songs,
              query: _searchController.text,
              selectedTag: _selectedTag,
            );
            return Column(
              children: [
                SongSearchBar(
                  controller: _searchController,
                  selectedTag: _selectedTag,
                  onTagChanged: (tag) {
                    setState(() {
                      _selectedTag = tag;
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = filteredSongs[index];
                      final isFav = favSongIds.contains(song.id!);
                      return SwipeActionCell(
                        key: ObjectKey(song.id),
                        trailingActions: <SwipeAction>[
                          SwipeAction(
                            color: CupertinoColors.systemRed,
                            icon: const Icon(
                              CupertinoIcons.minus_circle_fill,
                              color: CupertinoColors.white,
                            ),
                            onTap: (CompletionHandler handler) async {
                              await handler(true);
                              BlocProvider.of<ListsBloc>(context).add(
                                ListsRemoveSongFromListEvent(
                                  listId: currentList.id,
                                  songId: song.id!,
                                  languageCode:
                                      AppLocalizations.of(context)!
                                          .locale
                                          .languageCode,
                                ),
                              );
                            },
                          ),
                          SwipeAction(
                            color: isFav
                                ? CupertinoColors.systemOrange
                                : CupertinoColors.systemYellow,
                            icon: Icon(
                              isFav
                                  ? CupertinoIcons.star_slash
                                  : CupertinoIcons.star_fill,
                              color: CupertinoColors.white,
                            ),
                            onTap: (CompletionHandler handler) async {
                              handler(false);
                              if (isFav) {
                                BlocProvider.of<FavouritesBloc>(context).add(
                                  RemoveFavourite(
                                    songId: song.id!,
                                    reload: true,
                                    languageCode:
                                        AppLocalizations.of(context)!
                                            .locale
                                            .languageCode,
                                  ),
                                );
                              } else {
                                BlocProvider.of<FavouritesBloc>(context).add(
                                  SaveFavourite(
                                    languageCode:
                                        AppLocalizations.of(context)!
                                            .locale
                                            .languageCode,
                                    songId: song.id!,
                                  ),
                                );
                              }
                              Fluttertoast.showToast(
                                msg: isFav
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
                          ),
                        ],
                        child: SongTile(
                          song: song,
                          forceRef: _selectedTag == 2,
                          divider: index != filteredSongs.length - 1,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
