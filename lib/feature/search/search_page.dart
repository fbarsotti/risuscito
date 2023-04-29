import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/infrastructure/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/core/infrastructure/songs/presentation/bloc/songs_bloc.dart';
import 'package:risuscito/core/presentation/song/song_tile.dart';
import 'package:risuscito/core/presentation/states/rs_failure_view.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:risuscito/feature/search/sections/empty_search.dart';
import 'package:risuscito/feature/search/sections/not_searching.dart';
import 'package:risuscito/feature/search/sections/search_tag.dart';
import '../../core/presentation/customization/rs_colors.dart';
import '../../core/presentation/customization/theme/rs_theme_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<SongDomainModel> songs = [];
  List<SongDomainModel> _filteredSongs = [];
  late int selectedTag;

  @override
  void initState() {
    super.initState();
    selectedTag = 0;
    _searchController.addListener(() {
      setState(() {
        if (_searchController.text.length >= 3)
          _filteredSongs = songs
              .where(
                (element) => element.title!.toLowerCase().contains(
                      _searchController.text,
                    ),
              )
              .toList();
        else
          _filteredSongs = [];
      });
    });
  }

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
            largeTitle:
                Text(AppLocalizations.of(context)!.translate('search')!),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<SongsBloc, SongsState>(
              builder: (context, state) {
                if (state is SongsFailure)
                  return RSFailureView(failure: state.failure);
                if (state is SongsLoaded) {
                  songs = state.songs.alphabeticalOrder!;
                  return Column(
                    children: [
                      const SizedBox(
                        height: 16.0,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: CupertinoSearchTextField(
                          padding: EdgeInsets.all(12),
                          controller: _searchController,
                          placeholder: AppLocalizations.of(context)!
                              .translate('search_a_song'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            SearchTag(
                              onTap: () {
                                setState(() {
                                  selectedTag = 0;
                                });
                              },
                              text: 'Titolo',
                              icon: CupertinoIcons.textformat_abc,
                              selected: selectedTag == 0,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SearchTag(
                              onTap: () {
                                setState(() {
                                  selectedTag = 1;
                                });
                              },
                              text: 'Testo',
                              icon: CupertinoIcons.doc_plaintext,
                              selected: selectedTag == 1,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SearchTag(
                              onTap: () {
                                setState(() {
                                  selectedTag = 2;
                                });
                              },
                              text: 'Riferimenti',
                              icon: CupertinoIcons.book,
                              selected: selectedTag == 2,
                            ),
                          ],
                        ),
                      ),
                      if (_filteredSongs.length == 0)
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                        ),
                      if (_filteredSongs.length == 0 &&
                          _searchController.text.length < 3)
                        NotSearching(),

                      if (_filteredSongs.length == 0 &&
                          _searchController.text.length >= 3)
                        EmptySearch(),
                      if (_filteredSongs.length > 0)
                        CupertinoListSection(
                          children: [
                            ...List.generate(
                              _filteredSongs.length,
                              (index) => SongTile(
                                song: _filteredSongs[index],
                              ),
                            ),
                          ],
                        ),

                      // Row(
                      //   children: [
                      //     Container(
                      //       height: 100,
                      //       width: MediaQuery.of(context).size.width / 2,
                      //       color: RSColors.white,
                      //     )
                      // Container(
                      //   height: 100,
                      //   width: MediaQuery.of(context).size.width / 2,
                      //   color: RSColors.white,
                      // )
                      // ],
                      // )
                    ],
                  );
                } else
                  return RSLoadingView();
              },
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
