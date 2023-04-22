import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/infrastructure/localization/bloc/language_bloc.dart';
import 'package:risuscito/core/infrastructure/localization/languages.dart';
import 'package:risuscito/core/infrastructure/songs/presentation/bloc/songs_bloc.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';

import '../../../core/presentation/customization/theme/rs_theme_provider.dart';

class SettingsLanguage extends StatefulWidget {
  const SettingsLanguage({Key? key}) : super(key: key);

  @override
  State<SettingsLanguage> createState() => _SettingsLanguageState();
}

class _SettingsLanguageState extends State<SettingsLanguage> {
  @override
  Widget build(BuildContext context) {
    List<RSLanguage> _languages = [
      RSLanguage(
        'it',
        AppLocalizations.of(context)!.translate('it'),
        Language.it,
      ),
      RSLanguage(
        'en',
        AppLocalizations.of(context)!.translate('en'),
        Language.en,
      ),
    ];
    final code = AppLocalizations.of(context)!.locale.languageCode;
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CupertinoListSection.insetGrouped(
      header:
          Text(AppLocalizations.of(context)!.translate("choose_a_language")!),
      backgroundColor:
          themeChange.darkTheme ? RSColors.bgDarkColor : RSColors.bgColor,
      children: List.generate(
        _languages.length,
        (index) {
          final language = _languages[index];
          return CupertinoListTile(
            leading: Text(
              language.code,
              style: TextStyle(
                color: RSColors.primary,
              ),
            ),
            title:
                Text(AppLocalizations.of(context)!.translate(language.code)!),
            trailing: code == language.code
                ? Icon(CupertinoIcons.checkmark_alt)
                : null,
            onTap: () {
              BlocProvider.of<LanguageBloc>(context)
                  .add(LanguageSelected(language.language));
              BlocProvider.of<SongsBloc>(context).add(
                GetLocalizedSongs(
                  languageCode: language.code,
                ),
              );
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
