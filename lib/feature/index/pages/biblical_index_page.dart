import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risuscito/core/infrastructure/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/core/infrastructure/songs/presentation/bloc/songs_bloc.dart';
import 'package:risuscito/core/presentation/song/song_tile.dart';
import 'package:risuscito/core/presentation/states/rs_loading_view.dart';
import '../../../../../core/infrastructure/localization/app_localizations.dart';
import '../../../core/presentation/states/rs_failure_view.dart';

class BiblicalIndexPage extends StatefulWidget {
  const BiblicalIndexPage({Key? key}) : super(key: key);

  @override
  State<BiblicalIndexPage> createState() => _BiblicalIndexPageState();
}

class _BiblicalIndexPageState extends State<BiblicalIndexPage> {
  late List<SongDomainModel> songs;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.translate('index')!,
        middle:
            Text(AppLocalizations.of(context)!.translate('biblical_index')!),
      ),
      child: BlocBuilder<SongsBloc, SongsState>(
        builder: (context, state) {
          if (state is SongsFailure)
            return RSFailureView(failure: state.failure);
          if (state is SongsLoaded) {
            songs = state.songs.biblicalOrder!;
            return SafeArea(
              child: SingleChildScrollView(
                child: CupertinoListSection(
                  children: [
                    ...List.generate(
                      songs.length,
                      (index) => SongTile(
                        song: songs[index],
                      ),
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