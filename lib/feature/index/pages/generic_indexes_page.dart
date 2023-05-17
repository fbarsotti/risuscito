import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/feature/songs/presentation/sections/song_tile.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import 'package:risuscito/core/utils/rs_utils.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/feature/songs/presentation/bloc/songs_bloc.dart';
import '../../../../../core/infrastructure/localization/app_localizations.dart';
import '../../../core/presentation/states/rs_failure_view.dart';

class GenericIndexesPage extends StatefulWidget {
  const GenericIndexesPage({Key? key}) : super(key: key);

  @override
  State<GenericIndexesPage> createState() => _GenericIndexesPageState();
}

class _GenericIndexesPageState extends State<GenericIndexesPage> {
  late List<SongDomainModel> songs;
  bool init = true;
  Index selected = Index.alphabetical;

  @override
  void initState() {
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
            if (init) {
              songs = state.songs.alphabeticalOrder!;
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
                                songs = state.songs.alphabeticalOrder!;
                              else
                                songs = state.songs.numericalOrder!;
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
                              forceRef: false,
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