import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../core/presentation/customization/rs_colors.dart';
import '../../core/presentation/customization/theme/rs_theme_provider.dart';
import '../../core/utils/rs_dates_utils.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
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
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                CupertinoListSection.insetGrouped(
                  header: const Text('My Reminders'),
                  children: [
                    CupertinoListTile.notched(
                      title: const Text('Open pull request'),
                      leading: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: CupertinoColors.activeGreen,
                      ),
                      trailing: const CupertinoListTileChevron(),
                      onTap: null,
                    ),
                    CupertinoListTile.notched(
                      title: const Text('Push to master'),
                      leading: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: CupertinoColors.systemRed,
                      ),
                      additionalInfo: const Text('Not available'),
                    ),
                    CupertinoListTile.notched(
                      title: const Text('View last commit'),
                      leading: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: CupertinoColors.activeOrange,
                      ),
                      additionalInfo: const Text('12 days ago'),
                      trailing: const CupertinoListTileChevron(),
                      onTap: null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      // child: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       Text(RSDatesUtils.localizedTimeMessage(context)!),
      //       CupertinoSearchTextField(),
      //     ],
      //   ),
      // ),
    );
  }
}
