import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/infrastructure/localization/bloc/language_bloc.dart';
import 'package:risuscito/core/infrastructure/localization/languages.dart';

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
    return CupertinoListSection.insetGrouped(
        header:
            Text(AppLocalizations.of(context)!.translate("choose_a_language")!),
        children: List.generate(
          _languages.length,
          (index) {
            final language = _languages[index];
            return CupertinoListTile(
              title:
                  Text(AppLocalizations.of(context)!.translate(language.code)!),
              trailing: code == language.code
                  ? Icon(CupertinoIcons.checkmark_alt)
                  : null,
              onTap: () {
                BlocProvider.of<LanguageBloc>(context)
                    .add(LanguageSelected(language.language));
                Navigator.pop(context);
              },
            );
          },
        )
        // [

        //   CupertinoListTile(
        //     title: Text(AppLocalizations.of(context)!.translate("en")!),
        //     trailing: code == "en" ? Icon(CupertinoIcons.checkmark_alt) : null,
        //     onTap: () {},
        //   ),
        // ],
        );
    ;
  }
}
