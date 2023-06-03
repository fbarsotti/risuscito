import 'package:flutter/cupertino.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/feature/home/home_page.dart';
import 'package:risuscito/feature/index/indexes_page.dart';

import '../search/search_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _pages = [
    SearchPage(),
    HomePage(),
    IndexesPage(),
  ];

  Future<void> checkAppVersion() async {
    final newVersionPlus =
        NewVersionPlus(iOSId: 'com.fbarsotti.risuscito', androidId: '');
    final value = await newVersionPlus.getVersionStatus();
    if (value!.canUpdate)
      newVersionPlus.showUpdateDialog(
        context: context,
        versionStatus: value,
        dialogTitle:
            AppLocalizations.of(context)!.translate('update_available')!,
        dialogText:
            AppLocalizations.of(context)!.translate('update_available_full')!,
        updateButtonText: AppLocalizations.of(context)!.translate('update')!,
        dismissButtonText: AppLocalizations.of(context)!.translate('cancel')!,
      );
  }

  @override
  void initState() {
    checkAppVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: AppLocalizations.of(context)!.translate('search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: AppLocalizations.of(context)!.translate('home')!,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: AppLocalizations.of(context)!.translate('index'),
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
