import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/core_container.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_recording.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../../core/infrastructure/localization/app_localizations.dart';

class SongPage extends StatelessWidget {
  final String? url;
  final String htmlContent;
  // final WebViewPlus songWebView;
  final Color color;

  SongPage({
    Key? key,
    required this.url,
    required this.htmlContent,
    // required this.songWebView,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: color,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemFill,
        previousPageTitle: AppLocalizations.of(context)!.translate('back')!,
        middle: Text(
          AppLocalizations.of(context)!.translate('song')!,
          style: TextStyle(
            color: RSColors.black,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Container(
                // height: 1024,
                color: color,
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                // child: widget.songWebView,
                child: WebViewWidget(
                  controller: WebViewController()
                    ..loadHtmlString(
                      htmlContent,
                    )
                    ..setBackgroundColor(color),
                ),
              ),
            ),
            if (url != null && url!.isNotEmpty) SongRecording(url: url!),
          ],
        ),
      ),
    );
  }
}
