import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/customization/theme/rs_theme_provider.dart';
import 'package:risuscito/feature/history/presentation/bloc/history_bloc.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_page.dart';

class SongCard extends StatelessWidget {
  final SongDomainModel song;

  const SongCard({
    Key? key,
    required this.song,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CupertinoButton(
      pressedOpacity: themeChange.darkTheme ? 0.8 : 0.4,
      padding: EdgeInsets.zero,
      onPressed: () {
        BlocProvider.of<HistoryBloc>(context).add(
          SaveInHistory(
            languageCode: AppLocalizations.of(context)!.locale.languageCode,
            songId: song.id!,
          ),
        );
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(
            builder: (context) => SongPage(
                url: song.url,
                htmlContent: song.htmlContent!,
                color: song.color!),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: song.color!.value != Color(0xffffffff).value
              ? song.color
              : themeChange.darkTheme
                  ? RSColors.cardColorDark
                  : RSColors.cardColorLight,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate('song')! +
                        ' ${song.number}',
                    style: TextStyle(
                      color: RSColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: RSColors.primary,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                song.title!,
                style: TextStyle(
                  color: song.color!.value != Color(0xffffffff).value
                      ? RSColors.text
                      : themeChange.darkTheme
                          ? RSColors.darkText
                          : RSColors.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
