import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/feature/favourites/presentation/bloc/favourites_bloc.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_recording.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/infrastructure/localization/app_localizations.dart';

class SongPage extends StatefulWidget {
  final String? url;
  final String htmlContent;
  final String songId;
  final Color color;

  SongPage({
    Key? key,
    required this.url,
    required this.htmlContent,
    required this.songId,
    required this.color,
  }) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    _controller = WebViewController();
    super.initState();
  }

  Future<bool> loadHtml() async {
    try {
      final assetPath = "assets/data/songs_raw/raw-it/${widget.songId}";
      final rawHtml = await rootBundle.loadString(assetPath);

      _controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(widget.color)
        ..loadHtmlString(rawHtml);

      return true;
    } catch (e) {
      print('❌ Errore nel caricamento HTML: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = AppLocalizations.of(context)!.locale.languageCode;

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
        trailing: BlocBuilder<FavouritesBloc, FavouritesState>(
          builder: (context, state) {
            final isFav = state is FavouritesLoaded &&
                state.songs.any((song) => song.id == widget.songId);

            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                final bloc = context.read<FavouritesBloc>();

                if (isFav) {
                  bloc.add(RemoveFavourite(
                    songId: widget.songId,
                    reload: true,
                    languageCode: langCode,
                  ));
                } else {
                  bloc.add(SaveFavourite(
                    songId: widget.songId,
                    languageCode: langCode,
                  ));
                }
              },
              child: Icon(
                isFav ? CupertinoIcons.star_fill : CupertinoIcons.star,
                color: isFav ? RSColors.primary : RSColors.black,
              ),
            );
          },
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: loadHtml(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(
                          child: CupertinoActivityIndicator(
                            color: RSColors.red,
                          ),
                        )
                      : Container(
                          color: widget.color,
                          child: WebViewWidget(
                            controller: _controller,
                          ),
                        );
                },
              ),
            ),
            SongRecording(url: widget.url),
          ],
        ),
      ),
    );
  }
}
