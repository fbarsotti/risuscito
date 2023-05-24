import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/core_container.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../../core/infrastructure/localization/app_localizations.dart';

class SongPage extends StatefulWidget {
  final WebViewPlus songWebView;
  final Color color;

  SongPage({
    Key? key,
    required this.songWebView,
    required this.color,
  }) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  void initState() {
    super.initState();

    SharedPreferences prefs = rs();
    if (prefs.getBool('always_on_display') ?? true)
      Wakelock.enable();
    else
      Wakelock.disable();
  }

  @override
  Widget build(BuildContext context) {
    // data/songs_raw/raw-$languageCode/$songId
    return CupertinoPageScaffold(
      backgroundColor: widget.color,
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
        child: Container(
          height: 1024,
          color: widget.color,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
          child: widget.songWebView,
        ),
      ),
    );
  }
}
