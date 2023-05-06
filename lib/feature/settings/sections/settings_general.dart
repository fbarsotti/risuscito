import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/feature/settings/sections/help/help_page.dart';
import 'package:risuscito/feature/settings/sections/settings_language.dart';

import '../../../core/presentation/customization/theme/rs_theme_provider.dart';

class SettingsGeneral extends StatefulWidget {
  const SettingsGeneral({Key? key}) : super(key: key);

  @override
  State<SettingsGeneral> createState() => _SettingsGeneralState();
}

class _SettingsGeneralState extends State<SettingsGeneral> {
  @override
  void initState() {
    super.initState();
  }

  String? _getCurrentLanguage(BuildContext context) {
    final code = AppLocalizations.of(context)!.locale.languageCode;
    return AppLocalizations.of(context)!.translate(code);
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CupertinoListSection.insetGrouped(
      header: Text(AppLocalizations.of(context)!.translate('generals')!),
      backgroundColor:
          themeChange.darkTheme ? RSColors.bgDarkColor : RSColors.bgColor,
      children: [
        CupertinoListTile.notched(
          title: Text(AppLocalizations.of(context)!.translate('dark_theme')!),
          leading: Icon(
            themeChange.darkTheme
                ? CupertinoIcons.moon_stars
                : CupertinoIcons.sun_max,
          ),
          trailing: CupertinoSwitch(
            value: themeChange.darkTheme,
            onChanged: (value) {
              themeChange.darkTheme = value;
            },
          ),
        ),
        CupertinoListTile.notched(
          title: Text(AppLocalizations.of(context)!.translate('language')!),
          leading: Icon(CupertinoIcons.globe),
          subtitle: Text(_getCurrentLanguage(context) ?? ''),
          trailing: Icon(CupertinoIcons.forward),
          onTap: () => showCupertinoModalBottomSheet(
            context: context,
            builder: (context) => SettingsLanguage(),
          ),
        ),
        CupertinoListTile.notched(
          title: Text(AppLocalizations.of(context)!.translate('help')!),
          leading: Icon(CupertinoIcons.question_circle),
          trailing: Icon(CupertinoIcons.forward),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => HelpPage(),
            ),
          ),
        ),
      ],
    );
  }
}
