import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risuscito/core/presentation/empty_page_message.dart';
import 'package:risuscito/core/presentation/states/rs_failure_view.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_tile.dart';

import 'bloc/favourites_bloc.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                return Expanded(
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
                  initialItemCount: favSongs.length,
                  itemBuilder: (context, index, animation) {
                    return SongTile(
                      song: favSongs[index],
                      forceRef: false,
                      divider: index != favSongs.length - 1,
                    );
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
