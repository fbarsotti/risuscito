import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:risuscito/core/infrastructure/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/core/infrastructure/songs/presentation/bloc/songs_bloc.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/song/song_tile.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:risuscito/core/utils/rs_utils.dart';
import '../../../../../core/infrastructure/localization/app_localizations.dart';
import '../../../core/presentation/states/rs_failure_view.dart';

class GenericIndexesPage extends StatefulWidget {
  const GenericIndexesPage({Key? key}) : super(key: key);

  @override
  State<GenericIndexesPage> createState() => _GenericIndexesPageState();
}

class _GenericIndexesPageState extends State<GenericIndexesPage> {
  late List<SongDomainModel> songs;
  late bool init;
  Index selected = Index.alphabetical;

  int _alphabeticalComparison(SongDomainModel a, SongDomainModel b) {
    return a.title!.compareTo(b.title!);
  }

  int _numericalComparison(SongDomainModel a, SongDomainModel b) {
    return int.parse(a.number!) < int.parse(b.number!)
        ? -1
        : int.parse(a.number!) > int.parse(b.number!)
            ? 1
            : 0;
  }

  @override
  void initState() {
    init = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.translate('index')!,
        middle:
            Text(AppLocalizations.of(context)!.translate('generic_indexes')!),
      ),
      child: BlocBuilder<SongsBloc, SongsState>(
        builder: (context, state) {
          if (state is SongsFailure)
            return RSFailureView(failure: state.failure);
          if (state is SongsLoaded) {
            songs = state.songs;
            if (init) {
              songs.sort(_alphabeticalComparison); // sort list by index
              init = false;
            }
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: CupertinoSlidingSegmentedControl(
                        groupValue: selected,
                        children: <Index, Widget>{
                          Index.alphabetical: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('alphabetical_index')!,
                              ),
                            ),
                          ),
                          Index.numerical: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('numerical_index')!,
                              ),
                            ),
                          ),
                        },
                        onValueChanged: (Index? value) {
                          if (value != null) {
                            setState(() {
                              selected = value;
                              if (value == Index.alphabetical)
                                songs.sort(_alphabeticalComparison);
                              else
                                songs.sort(_numericalComparison);
                            });
                          }
                        },
                      ),
                    ),
                    CupertinoListSection(
                      children: [
                        ...List.generate(
                          songs.length,
                          (index) => Slidable(
                            endActionPane: ActionPane(
                              motion: DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: null,
                                  backgroundColor: CupertinoColors.systemYellow,
                                  foregroundColor: RSColors.white,
                                  icon: CupertinoIcons.text_badge_star,
                                  label: 'Preferiti',
                                ),
                                SlidableAction(
                                  onPressed: null,
                                  backgroundColor: Color(0xFF0392CF),
                                  foregroundColor: RSColors.white,
                                  icon: CupertinoIcons.folder,
                                  label: 'Save',
                                ),
                              ],
                            ),
                            child: SongTile(
                              song: songs[index],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else
            return RSLoadingView();
        },
      ),
    );
  }
}

// ListView.builder(
//         itemCount: songs.length,
//         itemBuilder: (context, index) {
//           return CupertinoListTile(title: Text(songs[index].title!));
//         },
//       ),