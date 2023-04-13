import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/utils/rs_dates_utils.dart';
import 'package:risuscito/feature/home/sections/logo_card.dart';
import 'package:risuscito/feature/home/sections/quick_actions.dart';
import 'package:risuscito/feature/settings/settings_page.dart';

import '../../core/presentation/customization/theme/rs_theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            border: Border.all(color: CupertinoColors.black.withOpacity(0)),
            backgroundColor: themeChange.darkTheme
                ? RSColors.bgDarkColor
                : RSColors.bgLightColor,
            largeTitle: Text(RSDatesUtils.localizedTimeMessage(context)!),
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
          SliverToBoxAdapter(
            child: Column(
              children: [
                // LogoCard(),
                const SizedBox(
                  height: 16.0,
                ),
                QuickActions(),
                // CircleAvatar(
                //   radius: 140,
                //   backgroundColor: RSColors.primary,
                //   child: CircleAvatar(
                //     radius: 135,
                //     backgroundColor: themeChange.darkTheme
                //         ? RSColors.bgDarkColor
                //         : RSColors.bgLightColor,
                //     child: Image.asset(
                //       'assets/images/risuscito_logo_primary.png',
                //       scale: 3,
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
