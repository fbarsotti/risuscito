import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/customization/theme/rs_theme_provider.dart';
import 'package:risuscito/feature/home/sections/quick_actions.dart';
import 'package:risuscito/feature/home/sections/tools_section.dart';
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
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            border: Border.all(color: CupertinoColors.black.withOpacity(0)),
            backgroundColor: themeChange.darkTheme
                ? RSColors.bgDarkColor
                : RSColors.bgLightColor,
            // largeTitle: Text(RSDatesUtils.localizedTimeMessage(context)!),
            largeTitle: Text(AppLocalizations.of(context)!.translate('home')!),
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
                const SizedBox(
                  height: 16,
                ),
                ToolsSection(),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LastSongs(),
                ),
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
