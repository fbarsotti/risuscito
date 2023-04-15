import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/bulked_cupertino_list_tile.dart';
import '../../core/presentation/customization/rs_colors.dart';
import '../../core/presentation/customization/theme/rs_theme_provider.dart';
import '../../core/utils/rs_dates_utils.dart';
import 'pages/alphabetical_index_page.dart';

class IndexesPage extends StatefulWidget {
  const IndexesPage({Key? key}) : super(key: key);

  @override
  State<IndexesPage> createState() => _IndexesPageState();
}

class _IndexesPageState extends State<IndexesPage> {
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
                    BulkedCupertinoListTile(
                      text: AppLocalizations.of(context)!
                          .translate('alphabetical_index')!,
                      icon: Icon(
                        CupertinoIcons.textformat_abc,
                        size: 30,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => AlphabeticalIndexPage(),
                          ),
                        );
                      },
                    ),
                    // CupertinoListTile.notched(
                    //   title: Text(
                    //     AppLocalizations.of(context)!
                    //         .translate('alphabetical_index')!,
                    //   ),
                    //   leading: Icon(CupertinoIcons.textformat_abc),
                    //   trailing: const CupertinoListTileChevron(),
                    //   onTap: () {
                    //     Navigator.of(context).push(
                    //       CupertinoPageRoute(
                    //         builder: (context) => AlphabeticalIndexPage(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    BulkedCupertinoListTile(
                      text: AppLocalizations.of(context)!
                          .translate('biblical_index')!,
                      icon: Icon(
                        CupertinoIcons.book,
                        size: 30,
                      ),
                      onTap: () {},
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
