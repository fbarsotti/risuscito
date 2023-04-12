import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';

import '../../core/presentation/customization/rs_colors.dart';
import '../../core/presentation/customization/theme/rs_theme_provider.dart';
import '../../core/utils/rs_dates_utils.dart';
import 'alphabetical/presentation/alphabetical_index_page.dart';

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
            largeTitle: Text(
              AppLocalizations.of(context)!.translate('index')!,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                CupertinoListSection.insetGrouped(
                  header: Text(
                    AppLocalizations.of(context)!.translate('browse_lists')!,
                  ),
                  children: [
                    CupertinoListTile.notched(
                      title: Text(
                        AppLocalizations.of(context)!
                            .translate('alphabetical_index')!,
                      ),
                      leading: Icon(CupertinoIcons.textformat_abc),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => AlphabeticalIndexPage(),
                        ),
                      ),
                    ),
                    // CupertinoListTile.notched(
                    //   title: const Text('Push to master'),
                    //   leading: Container(
                    //     width: double.infinity,
                    //     height: double.infinity,
                    //     color: CupertinoColors.systemRed,
                    //   ),
                    //   additionalInfo: const Text('Not available'),
                    // ),
                    // CupertinoListTile.notched(
                    //   title: const Text('View last commit'),
                    //   leading: Container(
                    //     width: double.infinity,
                    //     height: double.infinity,
                    //     color: CupertinoColors.activeOrange,
                    //   ),
                    //   additionalInfo: const Text('12 days ago'),
                    //   trailing: const CupertinoListTileChevron(),
                    //   onTap: null,
                    // ),
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
