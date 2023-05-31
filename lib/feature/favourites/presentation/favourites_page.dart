import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/empty_page_message.dart';
import 'package:risuscito/core/presentation/states/rs_failure_view.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_tile.dart';

import 'bloc/favourites_bloc.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    final myListKey = GlobalKey<AnimatedListState>();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppLocalizations.of(context)!.translate('favourites')!),
        previousPageTitle: AppLocalizations.of(context)!.translate('home'),
      ),
      child: SafeArea(
        child: BlocBuilder<FavouritesBloc, FavouritesState>(
          builder: (context, state) {
            if (state is FavouritesLoaded) {
              if (state.songs.isEmpty)
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
                final favSongs = state.songs;
                return ListView.builder(
                  key: myListKey,
                  itemCount: favSongs.length,
                  itemBuilder: (context, index) {
                    return SwipeActionCell(
                      key: ObjectKey(index),
                      trailingActions: <SwipeAction>[
                        SwipeAction(
                          color: CupertinoColors.systemRed,
                          icon: Icon(
                            CupertinoIcons.trash,
                            color: CupertinoColors.white,
                          ),
                          onTap: (CompletionHandler handler) async {
                            /// await handler(true) : will delete this row
                            /// And after delete animation,setState will called to
                            /// sync your data source with your UI

                            await handler(true);
                            BlocProvider.of<FavouritesBloc>(context).add(
                              RemoveFavourite(
                                songId: favSongs[index].id!,
                                reload: false,
                              ),
                            );

                            setState(() {
                              favSongs.remove(favSongs[index]);
                            });
                          },
                        ),
                      ],
                      child: SongTile(
                        song: favSongs[index],
                        forceRef: false,
                        divider: index != favSongs.length - 1,
                      ),
                    );
                    // return SizeTransition(
                    //   sizeFactor: animation,
                    //   child: Slidable(
                    //     endActionPane: ActionPane(
                    //       extentRatio: 0.25,
                    //       motion: DrawerMotion(),
                    //       children: [
                    //         SlidableAction(
                    //           onPressed: (context) {
                    //             BlocProvider.of<FavouritesBloc>(context).add(
                    //               RemoveFavourite(
                    //                 languageCode: AppLocalizations.of(context)!
                    //                     .locale
                    //                     .languageCode,
                    //                 songId: favSongs[index].id!,
                    //                 index: index,
                    //                 listKey: myListKey,
                    //               ),
                    //             );
                    //             myListKey.currentState!.removeItem(
                    //               index,
                    //               (context, animation) => SizeTransition(
                    //                 sizeFactor: animation,
                    //                 child: SongTile(
                    //                   song: favSongs[index],
                    //                   forceRef: false,
                    //                   divider: index != favSongs.length - 1,
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //           backgroundColor: CupertinoColors.systemRed,
                    //           foregroundColor: RSColors.white,
                    //           icon: CupertinoIcons.trash,
                    //           label: AppLocalizations.of(context)!
                    //               .translate('remove'),
                    //         ),
                    //         // SlidableAction(
                    //         //   onPressed: null,
                    //         //   backgroundColor: Color(0xFF0392CF),
                    //         //   foregroundColor: RSColors.white,
                    //         //   icon: CupertinoIcons.folder,
                    //         //   label: 'Save',
                    //         // ),
                    //       ],
                    //     ),
                    //     child: SongTile(
                    //       song: favSongs[index],
                    //       forceRef: false,
                    //       divider: index != favSongs.length - 1,
                    //     ),
                    //   ),
                    // );
                  },
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
