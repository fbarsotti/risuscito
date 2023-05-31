import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/header_text.dart';
import 'package:risuscito/feature/history/presentation/bloc/history_bloc.dart';
import 'package:risuscito/feature/home/sections/empty_card.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_card.dart';

class LastSongs extends StatelessWidget {
  const LastSongs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoaded)
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(
                  text:
                      AppLocalizations.of(context)!.translate('seen_recently')!,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 8,
                ),
                if (state.songs.length == 0) EmptyCard(),
                if (state.songs.length > 0)
                  const SizedBox(
                    height: 8,
                  ),
                if (state.songs.length > 0)
                  SongCard(
                    song: state.songs[0],
                  ),
                if (state.songs.length > 1)
                  const SizedBox(
                    height: 8,
                  ),
                if (state.songs.length > 1)
                  SongCard(
                    song: state.songs[1],
                  ),
              ],
            );
          else if (state is HistoryFailure)
            return EmptyCard();
          else
            return CupertinoActivityIndicator();
        },
      ),
    );
  }
}

// class LastSongs extends StatelessWidget {
//   const LastSongs({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoListSection.insetGrouped(
//       header: Text('Ultimi canti'),
//       children: [
//         CupertinoListTile.notched(
//           title: const Text('Mi indicherai il sentiero della vita'),
//           leading: Container(
//             width: double.infinity,
//             height: double.infinity,
//             color: CupertinoColors.activeGreen,
//           ),
//           trailing: Icon(CupertinoIcons.forward),
//           onTap: () {},
//         ),
//         CupertinoListTile.notched(
//           title: const Text('Dajenù'),
//           leading: Container(
//             width: double.infinity,
//             height: double.infinity,
//             color: CupertinoColors.activeGreen,
//           ),
//         ),
//         CupertinoListTile.notched(
//           title: const Text('La croce gloriosa'),
//           leading: Container(
//             width: double.infinity,
//             height: double.infinity,
//             color: CupertinoColors.activeGreen,
//           ),
//         ),
//       ],
//     );
//   }
// }
