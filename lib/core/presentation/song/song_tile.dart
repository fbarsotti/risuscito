import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/core/presentation/song/song_page.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../customization/rs_colors.dart';
import '../customization/theme/rs_theme_provider.dart';

class SongTile extends StatelessWidget {
  final SongDomainModel song;

  const SongTile({
    Key? key,
    required this.song,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CupertinoListTile(
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
              song.title!,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(
            builder: (context) => SongPage(
              songWebView: song.songWebView!,
            ),
          ),
        );
      },
    );
  }
}
