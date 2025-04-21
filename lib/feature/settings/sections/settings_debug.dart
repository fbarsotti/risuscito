import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/feature/settings/sections/debug/debug_page.dart';

import '../../../core/presentation/customization/theme/rs_theme_provider.dart';

class SettingsDebug extends StatefulWidget {
  const SettingsDebug({Key? key}) : super(key: key);

  @override
  State<SettingsDebug> createState() => _SettingsDebugState();
}

class _SettingsDebugState extends State<SettingsDebug> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CupertinoListSection.insetGrouped(
      header: Text('DEBUG'),
      backgroundColor:
          themeChange.darkTheme ? RSColors.bgDarkColor : RSColors.bgColor,
      children: [
        CupertinoListTile.notched(
          title: Text('Debug'),
          leading: Icon(CupertinoIcons.ant),
          trailing: Icon(CupertinoIcons.forward),
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => DebugPage(),
            ),
          ),
        ),
      ],
    );
  }
}
