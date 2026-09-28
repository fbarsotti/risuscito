import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/bulked_cupertino_list_tile.dart';
import 'package:risuscito/feature/index/pages/biblical_index_page.dart';
import 'package:risuscito/feature/index/pages/generic_indexes_page.dart';
import 'package:risuscito/feature/index/pages/liturgical_index_page.dart';
import 'package:risuscito/feature/index/pages/numerical_index_page.dart';
import 'package:risuscito/feature/songs/domain/model/liturgical_index_domain_model.dart';
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
  'canti_ingresso': CupertinoIcons.group_solid,
  'canti_pace': CupertinoIcons.group_solid,
  'canti_pane': CupertinoIcons.group_solid,
  'canti_comunione': CupertinoIcons.group_solid,
  'canti_fine': CupertinoIcons.group_solid,
};

/// Liturgical categories grouped into sections (header key -> category keys).
/// Categories not listed here end up in the "other_songs" section.
const _liturgicalSections = <String, List<String>>{
  'liturgical_seasons': [
    'tempo_avvento',
    'tempo_natale',
    'tempo_quaresima',
    'tempo_pasqua',
    'canti_pentecoste',
  ],
  'eucharistic_celebration': [
    'canti_ingresso',
    'canti_pace',
    'canti_pane',
    'canti_comunione',
    'canti_fine',
  ],
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
      resizeToAvoidBottomInset: false,
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
                    BulkedCupertinoListTile(
                      text: AppLocalizations.of(context)!
                          .translate('numerical_index')!,
                      icon: Icon(
                        CupertinoIcons.number,
                        size: 30,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => NumericalIndexPage(),
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
                      final grouped = _liturgicalSections.values
                          .expand((keys) => keys)
                          .toSet();
                      // Keeps the XML order inside each section
                      final sections =
                          <String, List<LiturgicalIndexDomainModel>>{
                        for (final entry in _liturgicalSections.entries)
                          entry.key: categories
                              .where((c) => entry.value.contains(c.categoryKey))
                              .toList(),
                        'other_songs': categories
                            .where((c) => !grouped.contains(c.categoryKey))
                            .toList(),
                      };
                      return Column(
                        children: sections.entries
                            .where((section) => section.value.isNotEmpty)
                            .map(
                              (section) => _LiturgicalSection(
                                title: AppLocalizations.of(context)!
                                    .translate(section.key)!,
                                categories: section.value,
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

class _LiturgicalSection extends StatelessWidget {
  final String title;
  final List<LiturgicalIndexDomainModel> categories;

  const _LiturgicalSection({
    Key? key,
    required this.title,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: Text(title),
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
}
