import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/bulked_cupertino_list_tile.dart';
import 'package:risuscito/feature/index/pages/biblical_index_page.dart';
import 'package:risuscito/feature/index/pages/generic_indexes_page.dart';
import 'package:risuscito/feature/index/pages/liturgical_index_page.dart';
import 'package:risuscito/feature/songs/presentation/bloc/songs_bloc.dart';
import '../../core/presentation/customization/rs_colors.dart';
import '../../core/presentation/customization/theme/rs_theme_provider.dart';

const _liturgicalIcons = <String, IconData>{
  'tempo_avvento': CupertinoIcons.calendar,
  'tempo_natale': CupertinoIcons.calendar,
  'tempo_quaresima': CupertinoIcons.calendar,
  'tempo_pasqua': CupertinoIcons.calendar,
  'canti_pentecoste': CupertinoIcons.calendar,
  'canti_vergine': CupertinoIcons.music_note_2,
  'canti_bambini': CupertinoIcons.music_note_2,
  'lodi_vespri': CupertinoIcons.music_note_2,
  'canti_ingresso': CupertinoIcons.bookmark,
  'canti_pace': CupertinoIcons.bookmark,
  'canti_pane': CupertinoIcons.bookmark,
  'canti_comunione': CupertinoIcons.bookmark,
  'canti_fine': CupertinoIcons.bookmark,
};

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
                          .translate('generic_indexes')!,
                      icon: Icon(
                        CupertinoIcons.textformat_abc,
                        size: 30,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => GenericIndexesPage(),
                          ),
                        );
                      },
                    ),
                    BulkedCupertinoListTile(
                      text: AppLocalizations.of(context)!
                          .translate('biblical_index')!,
                      icon: Icon(
                        CupertinoIcons.book,
                        size: 30,
                      ),
                      onTap: () {
                        // BlocProvider.of<SongsBiblicalBloc>(context).add(
                        //   GetLocalizedSongsBiblical(
                        //     languageCode: AppLocalizations.of(context)!
                        //         .locale
                        //         .languageCode,
                        //   ),
                        // );
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => BiblicalIndexPage(),
                          ),
                        );
                      },
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
                BlocBuilder<SongsBloc, SongsState>(
                  builder: (context, state) {
                    if (state is SongsLoaded &&
                        state.songs.liturgicalOrder != null &&
                        state.songs.liturgicalOrder!.isNotEmpty) {
                      final categories = state.songs.liturgicalOrder!;
                      return CupertinoListSection.insetGrouped(
                        header: Text(
                          AppLocalizations.of(context)!
                              .translate('liturgical_index')!,
                        ),
                        children: categories
                            .map(
                              (category) => BulkedCupertinoListTile(
                                text: category.categoryName,
                                icon: Icon(
                                  _liturgicalIcons[category.categoryKey] ??
                                      CupertinoIcons.calendar,
                                  size: 30,
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => LiturgicalIndexPage(
                                        categoryName: category.categoryName,
                                        songs: category.songs,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                            .toList(),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 16,
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
