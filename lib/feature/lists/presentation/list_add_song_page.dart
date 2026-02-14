import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/customization/theme/rs_theme_provider.dart';
import 'package:risuscito/feature/lists/domain/model/list_domain_model.dart';
import 'package:risuscito/feature/lists/presentation/bloc/lists_bloc.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/feature/songs/presentation/bloc/songs_bloc.dart';

class ListAddSongPage extends StatefulWidget {
  final ListDomainModel list;

  const ListAddSongPage({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<ListAddSongPage> createState() => _ListAddSongPageState();
}

class _ListAddSongPageState extends State<ListAddSongPage> {
  String _searchQuery = '';
  late Set<String> _addedSongIds;

  @override
  void initState() {
    super.initState();
    _addedSongIds =
        widget.list.songs?.map((s) => s.id!).toSet() ?? <String>{};
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          FocusManager.instance.primaryFocus?.unfocus();
          await Future.delayed(const Duration(milliseconds: 50));
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            AppLocalizations.of(context)!.translate('add_song')!,
          ),
          previousPageTitle: widget.list.name,
        ),
        child: SafeArea(
        child: BlocListener<ListsBloc, ListsState>(
          listener: (context, state) {
            if (state is ListsInfoLoaded) {
              setState(() {
                _addedSongIds = state.list.songs
                        ?.map((s) => s.id!)
                        .toSet() ??
                    <String>{};
              });
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoSearchTextField(
                  placeholder:
                      AppLocalizations.of(context)!.translate('search_a_song'),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<SongsBloc, SongsState>(
                  builder: (context, state) {
                    if (state is SongsLoaded) {
                      final allSongs =
                          state.songs.alphabeticalOrder ?? <SongDomainModel>[];
                      final filtered = allSongs.where((song) {
                        if (_searchQuery.isEmpty) return true;
                        return song.title
                                ?.toLowerCase()
                                .contains(_searchQuery) ??
                            false;
                      }).toList();

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
                          final isInList = _addedSongIds.contains(song.id);
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
                                  trailing: Icon(
                                    isInList
                                        ? CupertinoIcons.checkmark_circle_fill
                                        : CupertinoIcons.circle,
                                    color: isInList
                                        ? RSColors.primary
                                        : CupertinoColors.inactiveGray,
                                  ),
                                  onTap: () {
                                    final langCode =
                                        AppLocalizations.of(context)!
                                            .locale
                                            .languageCode;
                                    if (isInList) {
                                      BlocProvider.of<ListsBloc>(context).add(
                                        ListsRemoveSongFromListEvent(
                                          listId: widget.list.id,
                                          songId: song.id!,
                                          languageCode: langCode,
                                        ),
                                      );
                                      setState(() {
                                        _addedSongIds.remove(song.id);
                                      });
                                    } else {
                                      BlocProvider.of<ListsBloc>(context).add(
                                        ListsAddSongToListEvent(
                                          listId: widget.list.id,
                                          songId: song.id!,
                                          languageCode: langCode,
                                        ),
                                      );
                                      setState(() {
                                        _addedSongIds.add(song.id!);
                                      });
                                    }
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
    ),
    );
  }
}
