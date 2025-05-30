import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/feature/history/presentation/bloc/history_bloc.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_page.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';
import '../../../../core/presentation/customization/rs_colors.dart';
import '../../../../core/presentation/customization/theme/rs_theme_provider.dart';

class SongTile extends StatelessWidget {
  final SongDomainModel song;
  final bool forceRef;
  final bool divider;

  const SongTile({
    Key? key,
    required this.song,
    required this.forceRef,
    required this.divider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      color: themeChange.darkTheme ? RSColors.cardColorDark : RSColors.white,
      child: Column(
        children: [
          CupertinoListTile(
            // backgroundColor:
            //     themeChange.darkTheme ? RSColors.cardColorDark : RSColors.white,
            leadingSize: 40,
            leading: themeChange.darkTheme || song.color != Color(0xffFFFFFF)
                ? CircleAvatar(
                    backgroundColor: song.color,
                    child: Text(
                      song.number!,
                      style: TextStyle(
                        color: RSColors.primary,
                      ),
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: CupertinoColors.black,
                    child: CircleAvatar(
                      backgroundColor: song.color,
                      child: Text(
                        song.number!,
                        style: TextStyle(
                          color: RSColors.primary,
                        ),
                      ),
                    ),
                  ),
            trailing: const CupertinoListTileChevron(),
            title: Container(
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    forceRef ? song.biblicalRef! : song.title!,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            onTap: () {
              FocusScope.of(context).unfocus();
              BlocProvider.of<HistoryBloc>(context).add(
                SaveInHistory(
                  languageCode:
                      AppLocalizations.of(context)!.locale.languageCode,
                  songId: song.id!,
                ),
              );
              // print("----> PUSH STARTED:" + DateTime.now().toString());
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (context) => SongPage(
                    url: song.url,
                    htmlContent: song.htmlContent!,
                    songId: song.id!,
                    color: song.color!,
                  ),
                ),
              );
              // print("----> PUSH FINISHED:" + DateTime.now().toString());
            },
          ),
          if (divider)
            Divider(
              height: 1,
              color: themeChange.darkTheme
                  ? RSColors.dividerDark
                  : RSColors.dividerLight,
              indent: 70,
            )
        ],
      ),
    );
  }
}


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:risuscito/core/infrastructure/songs/domain/model/song_domain_model.dart';
// import 'package:risuscito/core/presentation/song/song_page.dart';
// import '../customization/rs_colors.dart';
// import '../customization/theme/rs_theme_provider.dart';

// class SongTile extends StatelessWidget {
//   final SongDomainModel song;

//   const SongTile({
//     Key? key,
//     required this.song,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final themeChange = Provider.of<DarkThemeProvider>(context);
//     return CupertinoContextMenu.builder(
//       actions: [
//         CupertinoContextMenuAction(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           isDefaultAction: true,
//           trailingIcon: CupertinoIcons.doc_on_clipboard_fill,
//           child: const Text('Copy'),
//         ),
//         CupertinoContextMenuAction(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           isDefaultAction: true,
//           trailingIcon: CupertinoIcons.doc_on_clipboard_fill,
//           child: const Text('Copy'),
//         ),
//       ],
//       builder: (context, animation) => animation.value <
//               CupertinoContextMenu.animationOpensAt
//           ? CupertinoListTile(
//               leadingSize: 40,
//               leading: themeChange.darkTheme || song.color != Color(0xffFFFFFF)
//                   ? CircleAvatar(
//                       backgroundColor: song.color,
//                       child: Text(
//                         song.number!,
//                         style: TextStyle(
//                           color: RSColors.primary,
//                         ),
//                       ),
//                     )
//                   : CircleAvatar(
//                       backgroundColor: CupertinoColors.black,
//                       child: CircleAvatar(
//                         backgroundColor: song.color,
//                         child: Text(
//                           song.number!,
//                           style: TextStyle(
//                             color: RSColors.primary,
//                           ),
//                         ),
//                       ),
//                     ),
//               trailing: const CupertinoListTileChevron(),
//               title: Container(
//                 height: 70,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       song.title!,
//                       textAlign: TextAlign.start,
//                     ),
//                   ],
//                 ),
//               ),
//               onTap: () {
//                 Navigator.of(context, rootNavigator: true).push(
//                   CupertinoPageRoute(
//                     builder: (context) => SongPage(
//                       songWebView: song.songWebView!,
//                     ),
//                   ),
//                 );
//               },
//             )
//           : Container(
//               child: song.songWebView,
//             ),
//     );
//   }
// }
