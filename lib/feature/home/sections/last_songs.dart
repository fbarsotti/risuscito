import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';

class LastSongs extends StatelessWidget {
  const LastSongs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!.translate('last_songs')!),
          CupertinoButton(
            onPressed: () {},
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Card(
                color: RSColors.primary,
              ),
            ),
          )
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
