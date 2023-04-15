import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/infrastructure/songs/data/datasource/songs_datasource.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../infrastructure/localization/app_localizations.dart';

class SongPage extends StatelessWidget {
  final WebViewPlus songWebView;

  SongPage({
    Key? key,
    required this.songWebView,
  }) : super(key: key);

  BuildContext _currentContext() => _navigatorKey.currentContext!;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // data/songs_raw/raw-$languageCode/$songId
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.translate('back')!,
        middle: Text(AppLocalizations.of(context)!.translate('song')!),
      ),
      child: SafeArea(
        bottom: false,
        child: songWebView,
      ),
    );
  }
}
