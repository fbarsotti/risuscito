import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../core/infrastructure/localization/app_localizations.dart';

class SongPage extends StatelessWidget {
  final WebViewPlus songWebView;
  final Color color;

  SongPage({
    Key? key,
    required this.songWebView,
    required this.color,
  }) : super(key: key);

  BuildContext _currentContext() => _navigatorKey.currentContext!;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // data/songs_raw/raw-$languageCode/$songId
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
        child: Container(
          height: 1024,
          color: color,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
          child: songWebView,
        ),
      ),
    );
  }
}
