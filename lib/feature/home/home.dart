import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/feature/home/home_page.dart';
import 'package:risuscito/feature/settings/settings_page.dart';

import '../search/search_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _pages = [
    HomePage(),
    SettingsPage(),
    SearchPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: AppLocalizations.of(context)!.translate('home')!,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: AppLocalizations.of(context)!.translate('index'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: AppLocalizations.of(context)!.translate('search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.circle_grid_3x3_fill),
            label: 'Keypad',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return Center(
              child: _pages[index],
            );
          },
        );
      },
    );
  }
}
