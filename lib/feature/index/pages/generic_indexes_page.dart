import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:risuscito/core/core_container.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/song_search/song_search_bar.dart';
import 'package:risuscito/core/presentation/song_search/song_search_filter.dart';
import 'package:risuscito/feature/favourites/presentation/bloc/favourites_bloc.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_tile.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:risuscito/feature/songs/presentation/bloc/songs_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/infrastructure/localization/app_localizations.dart';
import '../../../core/presentation/states/rs_failure_view.dart';

class AlphabeticalIndexPage extends StatefulWidget {
  const AlphabeticalIndexPage({Key? key}) : super(key: key);

  @override
  State<AlphabeticalIndexPage> createState() => _AlphabeticalIndexPageState();
}

class _AlphabeticalIndexPageState extends State<AlphabeticalIndexPage> {
  SharedPreferences prefs = rs();
  final TextEditingController _searchController = TextEditingController();
  int _selectedTag = 0;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
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
        previousPageTitle: AppLocalizations.of(context)!.translate('index')!,
        middle: Text(
            AppLocalizations.of(context)!.translate('alphabetical_index')!),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            _isSearching ? CupertinoIcons.xmark : CupertinoIcons.search,
          ),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                _selectedTag = 0;
              }
            });
          },
        ),
      ),
      child: BlocBuilder<SongsBloc, SongsState>(
        builder: (context, state) {
          if (state is SongsFailure)
            return RSFailureView(failure: state.failure);
          if (state is SongsLoaded) {
            final allSongs = state.songs.alphabeticalOrder!;
            final displaySongs = _isSearching
                ? SongSearchFilter.filter(
                    songs: allSongs,
                    query: _searchController.text,
                    selectedTag: _selectedTag,
                  )
                : allSongs;
            return SafeArea(
              child: Column(
                children: [
                  AnimatedCrossFade(
                    firstChild: const SizedBox(width: double.infinity),
                    secondChild: SongSearchBar(
                      controller: _searchController,
                      selectedTag: _selectedTag,
                      onTagChanged: (tag) {
                        setState(() {
                          _selectedTag = tag;
                        });
                      },
                    ),
                    crossFadeState: _isSearching
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: displaySongs.length,
                      itemBuilder: (context, index) => SwipeActionCell(
                        key: ObjectKey(displaySongs[index]),
                        trailingActions: [
                          SwipeAction(
                            color:
                                favSongIds.contains(displaySongs[index].id!)
                                    ? CupertinoColors.systemOrange
                                    : CupertinoColors.systemYellow,
                            icon: Icon(
                              favSongIds.contains(displaySongs[index].id!)
                                  ? CupertinoIcons.star_slash
                                  : CupertinoIcons.star_fill,
                              color: CupertinoColors.white,
                            ),
                            onTap: (CompletionHandler handler) async {
                              handler(false);
                              if (favSongIds
                                  .contains(displaySongs[index].id!)) {
                                BlocProvider.of<FavouritesBloc>(context).add(
                                  RemoveFavourite(
                                    songId: displaySongs[index].id!,
                                    reload: true,
                                    languageCode:
                                        AppLocalizations.of(context)!
                                            .locale
                                            .languageCode,
                                  ),
                                );
                              } else
                                BlocProvider.of<FavouritesBloc>(context).add(
                                  SaveFavourite(
                                    languageCode:
                                        AppLocalizations.of(context)!
                                            .locale
                                            .languageCode,
                                    songId: displaySongs[index].id!,
                                  ),
                                );
                              Fluttertoast.showToast(
                                msg: favSongIds
                                        .contains(displaySongs[index].id!)
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
                          song: displaySongs[index],
                          forceRef: _isSearching && _selectedTag == 2,
                          divider: index != displaySongs.length - 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else
            return RSLoadingView();
        },
      ),
    );
  }
}
