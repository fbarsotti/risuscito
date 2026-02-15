import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/customization/theme/rs_theme_provider.dart';
import 'package:risuscito/core/presentation/song_search/song_search_bar.dart';
import 'package:risuscito/core/presentation/song_search/song_search_filter.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/feature/songs/presentation/bloc/songs_bloc.dart';

class EucharistSongPickerPage extends StatefulWidget {
  final String momentName;

  const EucharistSongPickerPage({
    Key? key,
    required this.momentName,
  }) : super(key: key);

  @override
  State<EucharistSongPickerPage> createState() =>
      _EucharistSongPickerPageState();
}

class _EucharistSongPickerPageState extends State<EucharistSongPickerPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedTag = 0;
  final FocusNode _searchFocusNode = FocusNode();
  DateTime? _focusLostTime;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        _focusLostTime = DateTime.now();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final keyboardWasOpen = _searchFocusNode.hasFocus ||
              (_focusLostTime != null &&
                  DateTime.now().difference(_focusLostTime!).inMilliseconds <
                      300);
          FocusManager.instance.primaryFocus?.unfocus();
          if (keyboardWasOpen) {
            await Future.delayed(const Duration(milliseconds: 300));
          }
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.momentName),
          previousPageTitle:
              AppLocalizations.of(context)!.translate('prepare_eucharist'),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SongSearchBar(
                controller: _searchController,
                selectedTag: _selectedTag,
                focusNode: _searchFocusNode,
                onTagChanged: (tag) {
                  setState(() {
                    _selectedTag = tag;
                  });
                },
              ),
              Expanded(
                child: BlocBuilder<SongsBloc, SongsState>(
                  builder: (context, state) {
                    if (state is SongsLoaded) {
                      final allSongs =
                          state.songs.alphabeticalOrder ?? <SongDomainModel>[];
                      final filtered = SongSearchFilter.filter(
                        songs: allSongs,
                        query: _searchController.text,
                        selectedTag: _selectedTag,
                      );

                      if (filtered.isEmpty) {
                        return Center(
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('no_result')!,
                            style: TextStyle(
                              color: CupertinoColors.inactiveGray,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final song = filtered[index];
                          return Container(
                            color: themeChange.darkTheme
                                ? RSColors.cardColorDark
                                : RSColors.white,
                            child: Column(
                              children: [
                                CupertinoListTile(
                                  leadingSize: 40,
                                  leading: themeChange.darkTheme ||
                                          song.color != Color(0xffFFFFFF)
                                      ? CircleAvatar(
                                          backgroundColor: song.color,
                                          child: Text(
                                            song.number!,
                                            style: TextStyle(
                                              color: RSColors.primary,
                                            ),
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor:
                                              CupertinoColors.black,
                                          child: CircleAvatar(
                                            backgroundColor: song.color,
                                            child: Text(
                                              song.number!,
                                              style: TextStyle(
                                                color: RSColors.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                  title: Container(
                                    height: 70,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          song.title!,
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: CupertinoListTileChevron(),
                                  onTap: () {
                                    Navigator.of(context).pop(song);
                                  },
                                ),
                                if (index != filtered.length - 1)
                                  Divider(
                                    height: 1,
                                    color: themeChange.darkTheme
                                        ? RSColors.dividerDark
                                        : RSColors.dividerLight,
                                    indent: 70,
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
