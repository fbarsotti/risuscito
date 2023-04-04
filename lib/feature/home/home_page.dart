import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/feature/home/sections/last_songs.dart';
import 'package:risuscito/feature/settings/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle:
                Text(AppLocalizations.of(context)!.translate('home_title')!),
            trailing: CupertinoButton(
              child: Icon(
                CupertinoIcons.settings,
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialWithModalsPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CupertinoSearchTextField(),
                ),
                LastSongs(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
