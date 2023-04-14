import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/data/local/base_local_datasource.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../infrastructure/localization/app_localizations.dart';

class SongPage extends StatelessWidget {
  final String songId;
  final String languageCode;

  SongPage({
    Key? key,
    required this.songId,
    required this.languageCode,
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
        child: FutureBuilder(
            future:
                BaseLocalDatasource.getLocalizedSongPath(languageCode, songId),
            builder: (context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData)
                return WebViewPlus(
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    controller.loadString(snapshot.data!);
                  },
                );
              else
                return RSLoadingView();
            }),
      ),
    );
  }
}
