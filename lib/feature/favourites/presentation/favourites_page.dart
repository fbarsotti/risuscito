import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
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
        middle: Text('Preferiti'),
        previousPageTitle: 'Home',
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
                            title: 'Nessun preferito',
                            subtitle:
                                'Qui potrai trovare tutti i tuoi canti preferiti. Aggiungine qualcuno!',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              else {
                final favSongs = state.songs;
                print(favSongs.length);
                return AnimatedList(
                  key: myListKey,
                  initialItemCount: favSongs.length,
                  itemBuilder: (context, index, animation) {
                    return SwipeActionCell(
                      key: ObjectKey(favSongs[index]),
                      trailingActions: <SwipeAction>[
                        SwipeAction(
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
                              ),
                            );

                            setState(() {
                              favSongs.removeAt(index);
                            });
                          },
                          color: CupertinoColors.systemRed,
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
