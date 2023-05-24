import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_tile.dart';
import 'package:risuscito/core/presentation/states/rs_failure_view.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:risuscito/feature/search/sections/empty_search.dart';
import 'package:risuscito/feature/search/sections/not_searching.dart';
import 'package:risuscito/feature/search/sections/search_tag.dart';
import '../../core/presentation/customization/rs_colors.dart';
import '../../core/presentation/customization/theme/rs_theme_provider.dart';
import '../songs/domain/model/song_domain_model.dart';
import '../songs/presentation/bloc/songs_bloc.dart';

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

  void _controllerBehaviour() {
    if (_searchController.text.length >= 3) {
      if (selectedTag == 0)
        _filteredSongs = songs
            .where(
              (element) => _titlesSearchCondition(
                element,
              ),
            )
            .toList();
      if (selectedTag == 1)
        _filteredSongs = songs
            .where(
              (element) => _contentSearchCondition(
                element,
              ),
            )
            .toList();
      if (selectedTag == 2)
        _filteredSongs = songs
            .where(
              (element) => _refsSearchCondition(
                element,
              ),
            )
            .toList();
    } else
      _filteredSongs = [];
  }

  bool _titlesSearchCondition(SongDomainModel element) {
    return element.title!.toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );
  }

  bool _contentSearchCondition(SongDomainModel element) {
    return element.content!.toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );
  }

  bool _refsSearchCondition(SongDomainModel element) {
    return element.biblicalRef != null
        ? element.biblicalRef!.split(' - ')[0].toLowerCase().contains(
              _searchController.text.toLowerCase(),
            )
        : false;
  }

  @override
  void initState() {
    super.initState();
    selectedTag = 0;
    _searchController.addListener(() {
      setState(() {
        _controllerBehaviour();
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
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CupertinoSearchTextField(
                              padding: EdgeInsets.all(12),
                              controller: _searchController,
                              placeholder: AppLocalizations.of(context)!
                                  .translate('search_a_song'),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('search_in')!,
                              style: TextStyle(
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            SearchTag(
                              onTap: () {
                                setState(() {
                                  selectedTag = 0;
                                  _controllerBehaviour();
                                });
                              },
                              text: AppLocalizations.of(context)!
                                  .translate('title')!,
                              icon: CupertinoIcons.textbox,
                              selected: selectedTag == 0,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SearchTag(
                              onTap: () {
                                setState(() {
                                  selectedTag = 1;
                                  _controllerBehaviour();
                                });
                              },
                              text: AppLocalizations.of(context)!
                                  .translate('lyrics')!,
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
                                  _controllerBehaviour();
                                });
                              },
                              text: AppLocalizations.of(context)!
                                  .translate('biblical_reference')!,
                              icon: CupertinoIcons.book,
                              selected: selectedTag == 2,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                      if (_filteredSongs.length == 0)
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 6,
                        ),
                      if (_filteredSongs.length == 0 &&
                          _searchController.text.length < 3)
                        NotSearching(),

                      if (_filteredSongs.length == 0 &&
                          _searchController.text.length >= 3)
                        EmptySearch(),
                      // if (_filteredSongs.length > 0)
                      const SizedBox(
                        height: 24,
                      ),
                      if (_filteredSongs.length > 0)
                        ...List.generate(
                          _filteredSongs.length,
                          (index) => SongTile(
                            song: _filteredSongs[index],
                            forceRef: selectedTag == 2,
                            divider: index != _filteredSongs.length - 1,
                          ),
                        ),
                      // CupertinoListSection(
                      //   children: [
                      //     ...List.generate(
                      //       _filteredSongs.length,
                      //       (index) => SongTile(
                      //         song: _filteredSongs[index],
                      //         forceRef: selectedTag == 2,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  );
                } else
                  return RSLoadingView();
              },
            ),
          ),
        ],
      ),
    );
  }
}
