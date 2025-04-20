// lib/feature/songs/presentation/song_page.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/feature/favourites/presentation/bloc/favourites_bloc.dart';
import 'package:risuscito/feature/songs/presentation/sections/edit/barre_selector_button.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_recording.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/feature/songs/presentation/sections/edit/song_transposer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:risuscito/core/utils/chord_transposer.dart';

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
  int transposeOffset = 0;
  int? barreOffset = 0;
  bool _editingTranspose = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(widget.color);
    _loadAndDisplay();
  }

  @override
  void dispose() {
    _controller.clearCache();
    _controller.clearLocalStorage();
    super.dispose();
  }

  Future<void> _loadAndDisplay() async {
    final assetPath = "assets/data/songs_raw/raw-it/${widget.songId}";
    final offset = await loadTransposeOffset(widget.songId);
    final barre = await loadBarreOffset(widget.songId);

    final html = await processSongHtml(assetPath, widget.songId);

    setState(() {
      transposeOffset = offset;
      barreOffset = barre;
      _controller.loadHtmlString(html);
    });
  }

  // Future<void> _loadAndDisplay() async {
  //   final assetPath = "assets/data/songs_raw/raw-it/${widget.songId}";
  //   final offset =
  //       await loadTransposeOffset(widget.songId); // 🔁 recupero aggiornato
  //   final html = await loadAndTransposeHtml(assetPath, widget.songId);
  //   final barre = await loadBarreOffset(widget.songId);
  //   setState(() {
  //     transposeOffset = offset;
  //     barreOffset = barre;
  //     _controller.loadHtmlString(withBarre); // usa processSongHtml()
  //   });

  //   // setState(() {
  //   //   transposeOffset = offset; // 🔁 aggiorno lo stato
  //   //   _controller.loadHtmlString(html);
  //   // });
  // }

  Future<void> _updateTranspose(int delta) async {
    setState(() => transposeOffset += delta);
    await saveTransposeOffset(transposeOffset, widget.songId);
    _loadAndDisplay();
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
          style: TextStyle(color: RSColors.black),
        ),
        trailing: BlocBuilder<FavouritesBloc, FavouritesState>(
          builder: (context, state) {
            final isFav = state is FavouritesLoaded &&
                state.songs.any((song) => song.id == widget.songId);

            return CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                _editingTranspose
                    ? CupertinoIcons.check_mark
                    : CupertinoIcons.ellipsis_vertical,
              ),
              onPressed: () {
                if (_editingTranspose) {
                  // Conferma modifiche → chiudi modalità modifica
                  setState(() => _editingTranspose = false);
                } else {
                  // Mostra menu con opzioni
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);
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
                          isDestructiveAction: isFav,
                          child: Text(
                            isFav
                                ? AppLocalizations.of(context)!
                                    .translate('remove_from_favourites')!
                                : AppLocalizations.of(context)!
                                    .translate('add_to_favourites')!,
                          ),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() => _editingTranspose = true);
                          },
                          child: const Text('Modifica'),
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annulla'),
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (_editingTranspose)
              SongTransposer(
                transposeOffset: transposeOffset,
                onTranspose: (delta) => _updateTranspose(delta),
              ),
            if (_editingTranspose)
              BarreSelectorButton(
                barreOffset: barreOffset,
                onChanged: (newOffset) async {
                  setState(() => barreOffset = newOffset);
                  await saveBarreOffset(newOffset, widget.songId);
                  _loadAndDisplay(); // ricarica HTML aggiornato
                },
                onReset: () async {
                  setState(() => barreOffset = null); // UI reset
                  await clearBarreOffset(
                      widget.songId); // elimina del tutto la preferenza
                  _loadAndDisplay();
                },
              ),
            Expanded(child: WebViewWidget(controller: _controller)),
            SongRecording(url: widget.url),
          ],
        ),
      ),
    );
  }
}
