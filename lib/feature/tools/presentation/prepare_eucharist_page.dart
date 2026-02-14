import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show CircleAvatar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/customization/theme/rs_theme_provider.dart';
import 'package:risuscito/feature/history/presentation/bloc/history_bloc.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_page.dart';
import 'package:risuscito/feature/tools/presentation/eucharist_song_picker_page.dart';
import 'package:url_launcher/url_launcher.dart';

class PrepareEucharistPage extends StatefulWidget {
  const PrepareEucharistPage({Key? key}) : super(key: key);

  @override
  State<PrepareEucharistPage> createState() => _PrepareEucharistPageState();
}

class _PrepareEucharistPageState extends State<PrepareEucharistPage> {
  static const _momentKeys = [
    'eucharist_entry_song',
    'eucharist_peace_song',
    'eucharist_bread_song',
    'eucharist_wine_song',
    'eucharist_final_song',
  ];

  final Map<String, SongDomainModel?> _selectedSongs = {
    'eucharist_entry_song': null,
    'eucharist_peace_song': null,
    'eucharist_bread_song': null,
    'eucharist_wine_song': null,
    'eucharist_final_song': null,
  };

  bool get _hasAnySong =>
      _selectedSongs.values.any((song) => song != null);

  Future<void> _shareOnWhatsApp() async {
    final loc = AppLocalizations.of(context)!;
    final buffer = StringBuffer();
    buffer.writeln('*${loc.translate('eucharist_share_title')}*');
    buffer.writeln();

    for (final key in _momentKeys) {
      final song = _selectedSongs[key];
      if (song != null) {
        buffer.writeln('${loc.translate(key)}: ${song.title}');
      }
    }

    final text = Uri.encodeComponent(buffer.toString().trimRight());
    final url = Uri.parse('https://wa.me/?text=$text');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _pickSong(String momentKey) async {
    final loc = AppLocalizations.of(context)!;
    final song = await Navigator.of(context).push<SongDomainModel>(
      CupertinoPageRoute(
        builder: (context) => EucharistSongPickerPage(
          momentName: loc.translate(momentKey)!,
        ),
      ),
    );
    if (song != null) {
      setState(() {
        _selectedSongs[momentKey] = song;
      });
    }
  }

  void _openSong(SongDomainModel song) {
    final langCode =
        AppLocalizations.of(context)!.locale.languageCode;
    BlocProvider.of<HistoryBloc>(context).add(
      SaveInHistory(
        languageCode: langCode,
        songId: song.id!,
      ),
    );
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (context) => SongPage(
          url: song.url,
          htmlContent: song.htmlContent!,
          songId: song.id!,
          color: song.color!,
          languageCode: langCode,
        ),
      ),
    );
  }

  void _removeSong(String momentKey) {
    setState(() {
      _selectedSongs[momentKey] = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(loc.translate('prepare_eucharist')!),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _hasAnySong ? _shareOnWhatsApp : null,
          child: Icon(
            CupertinoIcons.share,
            color: _hasAnySong
                ? RSColors.primary
                : CupertinoColors.inactiveGray,
          ),
        ),
      ),
      child: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _momentKeys.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final key = _momentKeys[index];
            final song = _selectedSongs[key];
            return _MomentSlotCard(
              momentName: loc.translate(key)!,
              song: song,
              isDark: themeChange.darkTheme,
              onTapEmpty: () => _pickSong(key),
              onTapFilled: () => _openSong(song!),
              onRemove: () => _removeSong(key),
            );
          },
        ),
      ),
    );
  }
}

class _MomentSlotCard extends StatelessWidget {
  final String momentName;
  final SongDomainModel? song;
  final bool isDark;
  final VoidCallback onTapEmpty;
  final VoidCallback onTapFilled;
  final VoidCallback onRemove;

  const _MomentSlotCard({
    Key? key,
    required this.momentName,
    required this.song,
    required this.isDark,
    required this.onTapEmpty,
    required this.onTapFilled,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isFilled = song != null;

    return CupertinoButton(
      pressedOpacity: isDark ? 0.8 : 0.4,
      padding: EdgeInsets.zero,
      onPressed: isFilled ? onTapFilled : onTapEmpty,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? RSColors.cardColorDark : RSColors.cardColorLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (!isFilled)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? CupertinoColors.systemGrey
                      : CupertinoColors.systemGrey4,
                ),
                child: Icon(
                  CupertinoIcons.add,
                  size: 20,
                  color: isDark ? RSColors.darkText : RSColors.text,
                ),
              ),
            if (isFilled && (isDark || song!.color != Color(0xffFFFFFF)))
              CircleAvatar(
                radius: 20,
                backgroundColor: song!.color,
                child: Text(
                  song!.number!,
                  style: TextStyle(color: RSColors.primary),
                ),
              ),
            if (isFilled && !isDark && song!.color == Color(0xffFFFFFF))
              CircleAvatar(
                radius: 20,
                backgroundColor: CupertinoColors.black,
                child: CircleAvatar(
                  radius: 19,
                  backgroundColor: song!.color,
                  child: Text(
                    song!.number!,
                    style: TextStyle(color: RSColors.primary),
                  ),
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    momentName,
                    style: TextStyle(
                      color: RSColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isFilled
                        ? song!.title!
                        : loc.translate('select_song')!,
                    style: TextStyle(
                      color: isFilled
                          ? (isDark ? RSColors.darkText : RSColors.text)
                          : CupertinoColors.inactiveGray,
                      fontSize: 16,
                      fontWeight:
                          isFilled ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (isFilled)
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 30,
                onPressed: onRemove,
                child: Icon(
                  CupertinoIcons.xmark_circle_fill,
                  size: 22,
                  color: CupertinoColors.inactiveGray,
                ),
              ),
            if (!isFilled)
              Icon(
                CupertinoIcons.chevron_right,
                size: 18,
                color: CupertinoColors.inactiveGray,
              ),
          ],
        ),
      ),
    );
  }
}
