import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/header_text.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_card.dart';
import 'package:risuscito/feature/home/sections/empty_card.dart';
import '../../../core/presentation/customization/rs_colors.dart';
import '../../../core/presentation/customization/theme/rs_theme_provider.dart';

class LastSongs extends StatelessWidget {
  const LastSongs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CupertinoFormSection.insetGrouped(
          //   header: Text('Prova'),
          //   children: [
          //     SongCard(
          //       title: 'Gesù percorreva tutte le città',
          //       number: 98,
          //       color: CupertinoColors.activeGreen,
          //     ),
          //     SongCard(
          //       title: 'Gesù percorreva tutte le città',
          //       number: 98,
          //       color: CupertinoColors.activeGreen,
          //     ),
          //   ],
          // ),
          HeaderText(
            text: AppLocalizations.of(context)!.translate('seen_recently')!,
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 8,
          ),
          EmptyCard(),
          // SongCard(
          //   title: 'Gesù percorreva tutte le città',
          //   number: 98,
          //   color: CupertinoColors.activeGreen,
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          // SongCard(
          //   title: 'La croce gloriosa',
          //   number: 35,
          //   color: CupertinoColors.activeBlue,
          // ),
        ],
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
