import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/core_container.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/presentation/customization/theme/rs_theme_provider.dart';

class SettingsAdvanced extends StatefulWidget {
  const SettingsAdvanced({Key? key}) : super(key: key);

  @override
  State<SettingsAdvanced> createState() => _SettingsAdvancedState();
}

class _SettingsAdvancedState extends State<SettingsAdvanced> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences prefs = rs();
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CupertinoListSection.insetGrouped(
      header: Text(AppLocalizations.of(context)!.translate('advanced')!),
      backgroundColor:
          themeChange.darkTheme ? RSColors.bgDarkColor : RSColors.bgColor,
      children: [
        CupertinoListTile.notched(
          title: Text(AppLocalizations.of(context)!.translate('always_on')!),
          subtitle: Text(
            AppLocalizations.of(context)!.translate('always_on_description')!,
          ),
          leading: Icon(CupertinoIcons.device_phone_portrait),
          trailing: CupertinoSwitch(
            value: prefs.getBool('always_on') ?? true, //alwaysOn,
            onChanged: (bool value) async {
              await prefs.setBool('always_on', value);
              setState(() {});

              // alwaysOn = value;
            },
          ),
        ),
      ],
    );
  }
}
