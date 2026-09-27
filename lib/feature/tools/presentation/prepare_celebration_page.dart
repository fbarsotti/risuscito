import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show CircleAvatar;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/customization/theme/rs_theme_provider.dart';
import 'package:risuscito/feature/history/presentation/bloc/history_bloc.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_page.dart';
import 'package:risuscito/feature/tools/presentation/song_picker_page.dart';
import 'package:url_launcher/url_launcher.dart';

class PrepareCelebrationPage extends StatefulWidget {
  final String titleKey;
  final String shareTitleKey;
  final List<String> momentKeys;

  const PrepareCelebrationPage({
    Key? key,
    required this.titleKey,
    required this.shareTitleKey,
    required this.momentKeys,
  }) : super(key: key);

  const PrepareCelebrationPage.word({Key? key})
      : this(
          key: key,
          titleKey: 'prepare_word',
          shareTitleKey: 'word_share_title',
          momentKeys: const [
            'word_entry_song',
            'word_reading_1',
            'word_reading_2',
            'word_reading_3',
            'word_final_song',
          ],
        );

  const PrepareCelebrationPage.eucharist({Key? key})
      : this(
          key: key,
          titleKey: 'prepare_eucharist',
          shareTitleKey: 'eucharist_share_title',
          momentKeys: const [
            'eucharist_entry_song',
            'eucharist_peace_song',
            'eucharist_bread_song',
            'eucharist_wine_song',
            'eucharist_final_song',
          ],
        );

  @override
  State<PrepareCelebrationPage> createState() => _PrepareCelebrationPageState();
}

class _PrepareCelebrationPageState extends State<PrepareCelebrationPage> {
  late final Map<String, SongDomainModel?> _selectedSongs = {
    for (final key in widget.momentKeys) key: null,
  };

  bool get _hasAnySong => _selectedSongs.values.any((song) => song != null);

  /// With [whatsAppFormatting] the title is bold (*...*) and song titles
  /// are italic (_..._); otherwise plain text is returned.
  String _buildShareText({bool whatsAppFormatting = false}) {
    final loc = AppLocalizations.of(context)!;
    final bold = whatsAppFormatting ? '*' : '';
    final italic = whatsAppFormatting ? '_' : '';
    final buffer = StringBuffer();
    buffer.writeln('$bold${loc.translate(widget.shareTitleKey)}$bold');
    buffer.writeln();

    for (final key in widget.momentKeys) {
      final song = _selectedSongs[key];
      final value = song != null ? '$italic${song.title}$italic' : '-';
      buffer.writeln('• ${loc.translate(key)}: $value');
    }

    return buffer.toString().trimRight();
  }

  Future<void> _shareOnWhatsApp() async {
    final text = Uri.encodeComponent(
      _buildShareText(whatsAppFormatting: true),
    );
    final url = Uri.parse('https://wa.me/?text=$text');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _copyShareText() async {
    await Clipboard.setData(ClipboardData(text: _buildShareText()));
    if (!mounted) return;
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
          }
        });
        return CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.translate('text_copied')!),
        );
      },
    );
  }

  void _showShareOptions() {
    final loc = AppLocalizations.of(context)!;
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              _shareOnWhatsApp();
            },
            child: Text(loc.translate('share_whatsapp')!),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _copyShareText();
            },
            child: Text(loc.translate('copy_text')!),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text(loc.translate('cancel')!),
        ),
      ),
    );
  }

  Future<void> _pickSong(String momentKey) async {
    final loc = AppLocalizations.of(context)!;
    final song = await Navigator.of(context).push<SongDomainModel>(
      CupertinoPageRoute(
        builder: (context) => SongPickerPage(
          momentName: loc.translate(momentKey)!,
          previousPageTitle: loc.translate(widget.titleKey),
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
    final langCode = AppLocalizations.of(context)!.locale.languageCode;
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
        middle: Text(loc.translate(widget.titleKey)!),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _hasAnySong ? _showShareOptions : null,
          child: Icon(
            CupertinoIcons.share,
            color:
                _hasAnySong ? RSColors.primary : CupertinoColors.inactiveGray,
          ),
        ),
      ),
      child: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: widget.momentKeys.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final key = widget.momentKeys[index];
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
                    isFilled ? song!.title! : loc.translate('select_song')!,
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
