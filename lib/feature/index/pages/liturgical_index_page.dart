import 'package:flutter/cupertino.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:risuscito/core/core_container.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/empty_page_message.dart';
import 'package:risuscito/core/presentation/song_search/song_search_bar.dart';
import 'package:risuscito/core/presentation/song_search/song_search_filter.dart';
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
        middle: Text(widget.categoryName),
        trailing: widget.songs.isEmpty
            ? null
            : CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  _isSearching
                      ? CupertinoIcons.xmark
                      : CupertinoIcons.search,
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
                    child: Builder(
                      builder: (context) {
                        final displaySongs = _isSearching
                            ? SongSearchFilter.filter(
                                songs: widget.songs,
                                query: _searchController.text,
                                selectedTag: _selectedTag,
                              )
                            : widget.songs;
                        return ListView.builder(
                          itemCount: displaySongs.length,
                          itemBuilder: (context, index) {
                            final song = displaySongs[index];
                            return SwipeActionCell(
                              key: ObjectKey(song),
                              trailingActions: [
                                SwipeAction(
                                  color: favSongIds.contains(song.id!)
                                      ? CupertinoColors.systemOrange
                                      : CupertinoColors.systemYellow,
                                  icon: Icon(
                                    favSongIds.contains(song.id!)
                                        ? CupertinoIcons.star_slash
                                        : CupertinoIcons.star_fill,
                                    color: CupertinoColors.white,
                                  ),
                                  onTap: (CompletionHandler handler) async {
                                    handler(false);
                                    if (favSongIds.contains(song.id!)) {
                                      BlocProvider.of<FavouritesBloc>(context)
                                          .add(
                                        RemoveFavourite(
                                          songId: song.id!,
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
                                song: song,
                                forceRef: _isSearching && _selectedTag == 2,
                                divider: index != displaySongs.length - 1,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
