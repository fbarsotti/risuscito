import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/core_container.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/song_search/song_search_bar.dart';
import 'package:risuscito/core/presentation/song_search/song_search_filter.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_tile.dart';
import 'package:risuscito/core/presentation/states/rs_failure_view.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:risuscito/feature/search/sections/empty_search.dart';
import 'package:risuscito/feature/search/sections/not_searching.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/presentation/customization/rs_colors.dart';
import '../../core/presentation/customization/theme/rs_theme_provider.dart';
import '../favourites/presentation/bloc/favourites_bloc.dart';
import '../songs/domain/model/song_domain_model.dart';
import '../songs/presentation/bloc/songs_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<SongDomainModel> songs = [];
  List<SongDomainModel> _filteredSongs = [];
  SharedPreferences prefs = rs();
  int selectedTag = 0;

  @override
  void initState() {
    super.initState();
    selectedTag = 0;
    _searchController.addListener(() {
      setState(() {
        _filteredSongs = _searchController.text.isEmpty
            ? []
            : SongSearchFilter.filter(
                songs: songs,
                query: _searchController.text,
                selectedTag: selectedTag,
              );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final favSongIds = prefs.getStringList('favourites') ?? [];
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            border: Border.all(color: CupertinoColors.black.withOpacity(0)),
            backgroundColor: themeChange.darkTheme
                ? RSColors.bgDarkColor
                : RSColors.bgLightColor,
            largeTitle:
                Text(AppLocalizations.of(context)!.translate('search')!),
          ),
          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              child: BlocBuilder<SongsBloc, SongsState>(
                builder: (context, state) {
                  if (state is SongsFailure)
                    return RSFailureView(failure: state.failure);
                  if (state is SongsLoaded) {
                    songs = state.songs.alphabeticalOrder!;
                    _filteredSongs = _searchController.text.isEmpty
                        ? []
                        : SongSearchFilter.filter(
                            songs: songs,
                            query: _searchController.text,
                            selectedTag: selectedTag,
                          );
                    return Column(
                      children: [
                        SongSearchBar(
                          controller: _searchController,
                          selectedTag: selectedTag,
                          onTagChanged: (tag) {
                            setState(() {
                              selectedTag = tag;
                              _filteredSongs = _searchController.text.isEmpty
                                  ? []
                                  : SongSearchFilter.filter(
                                      songs: songs,
                                      query: _searchController.text,
                                      selectedTag: selectedTag,
                                    );
                            });
                          },
                        ),
                        if (_filteredSongs.length == 0 &&
                            _searchController.text.isEmpty)
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 6,
                          ),
                        if (_filteredSongs.length == 0 &&
                            _searchController.text.isEmpty)
                          NotSearching(
                            selectedTag: selectedTag,
                          ),

                        if (_filteredSongs.length == 0 &&
                            _searchController.text.isNotEmpty)
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 6,
                          ),
                        if (_filteredSongs.length == 0 &&
                            _searchController.text.isNotEmpty)
                          EmptySearch(),
                        const SizedBox(
                          height: 24,
                        ),
                        if (_filteredSongs.length > 0)
                          ...List.generate(
                            _filteredSongs.length,
                            (index) => SwipeActionCell(
                              key: ObjectKey(songs[index]),
                              trailingActions: [
                                SwipeAction(
                                  color: favSongIds
                                          .contains(_filteredSongs[index].id!)
                                      ? CupertinoColors.systemOrange
                                      : CupertinoColors.systemYellow,
                                  icon: Icon(
                                    favSongIds
                                            .contains(_filteredSongs[index].id!)
                                        ? CupertinoIcons.star_slash
                                        : CupertinoIcons.star_fill,
                                    color: CupertinoColors.white,
                                  ),
                                  onTap: (CompletionHandler handler) async {
                                    handler(false);
                                    if (favSongIds
                                        .contains(_filteredSongs[index].id!)) {
                                      BlocProvider.of<FavouritesBloc>(context)
                                          .add(
                                        RemoveFavourite(
                                          songId: _filteredSongs[index].id!,
                                          reload: true,
                                          languageCode:
                                              AppLocalizations.of(context)!
                                                  .locale
                                                  .languageCode,
                                        ),
                                      );
                                    } else
                                      BlocProvider.of<FavouritesBloc>(context)
                                          .add(
                                        SaveFavourite(
                                          languageCode:
                                              AppLocalizations.of(context)!
                                                  .locale
                                                  .languageCode,
                                          songId: _filteredSongs[index].id!,
                                        ),
                                      );
                                    Fluttertoast.showToast(
                                      msg: favSongIds.contains(
                                              _filteredSongs[index].id!)
                                          ? AppLocalizations.of(context)!
                                              .translate('favourite_removed')!
                                          : AppLocalizations.of(context)!
                                              .translate('favourite_added')!,
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 2,
                                      backgroundColor: RSColors.cardColorDark
                                          .withOpacity(0.95),
                                      textColor: CupertinoColors.white,
                                      fontSize: 16.0,
                                    );
                                    setState(() {});
                                  },
                                )
                              ],
                              child: SongTile(
                                song: _filteredSongs[index],
                                forceRef: selectedTag == 2,
                                divider: index != songs.length - 1,
                              ),
                            ),
                          ),
                      ],
                    );
                  } else
                    return RSLoadingView();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
