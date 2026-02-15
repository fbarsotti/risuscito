import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/empty_page_message.dart';
import 'package:risuscito/core/presentation/song_search/song_search_bar.dart';
import 'package:risuscito/core/presentation/song_search/song_search_filter.dart';
import 'package:risuscito/core/presentation/states/rs_failure_view.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_tile.dart';

import '../../songs/domain/model/song_domain_model.dart';
import 'bloc/favourites_bloc.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  late List<SongDomainModel> favSongs;
  final myListKey = GlobalKey<AnimatedListState>();
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppLocalizations.of(context)!.translate('favourites')!),
        previousPageTitle: AppLocalizations.of(context)!.translate('home'),
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
      child: SafeArea(
        child: BlocBuilder<FavouritesBloc, FavouritesState>(
          builder: (context, state) {
            if (state is FavouritesLoaded) {
              favSongs = state.songs;
              if (favSongs.isEmpty)
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          child: EmptyPageMessage(
                            icon: CupertinoIcons.text_badge_star,
                            title: AppLocalizations.of(context)!
                                .translate('no_favourites')!,
                            subtitle: AppLocalizations.of(context)!
                                .translate('no_favourites_full')!,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              else {
                final displaySongs = _isSearching
                    ? SongSearchFilter.filter(
                        songs: favSongs,
                        query: _searchController.text,
                        selectedTag: _selectedTag,
                      )
                    : favSongs;
                return Column(
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
                        key: myListKey,
                        itemCount: displaySongs.length,
                        itemBuilder: (context, index) {
                          return SwipeActionCell(
                            key: ObjectKey(displaySongs[index].id),
                            trailingActions: <SwipeAction>[
                              SwipeAction(
                                color: CupertinoColors.systemOrange,
                                icon: Icon(
                                  CupertinoIcons.star_slash,
                                  color: CupertinoColors.white,
                                ),
                                onTap: (CompletionHandler handler) async {
                                  await handler(true);
                                  BlocProvider.of<FavouritesBloc>(context).add(
                                    RemoveFavourite(
                                      songId: displaySongs[index].id!,
                                      reload: false,
                                    ),
                                  );

                                  setState(() {
                                    favSongs.remove(displaySongs[index]);
                                  });
                                },
                              ),
                            ],
                            child: SongTile(
                              song: displaySongs[index],
                              forceRef: _isSearching && _selectedTag == 2,
                              divider: index != displaySongs.length - 1,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            } else if (state is FavouritesFailure)
              return RSFailureView(failure: state.failure);
            else
              return RSLoadingView();
          },
        ),
      ),
    );
  }
}
