import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/flavors_utils.dart';
import 'package:risuscito/feature/settings/sections/settings_advanced.dart';
import 'package:risuscito/feature/settings/sections/settings_debug.dart';
import 'package:risuscito/feature/settings/sections/settings_general.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.translate('home')!,
        middle: Text(AppLocalizations.of(context)!.translate('settings')!),
      ),
      child: ListView(
        children: [
          SettingsGeneral(),
          SettingsAdvanced(),
          isDev() ? SettingsDebug() : Container(),
        ],
      ),
    );
  }
}
