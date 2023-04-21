import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:risuscito/core/infrastructure/songs/data/repository/songs_repository_impl.dart';
import 'package:risuscito/core/infrastructure/songs/domain/repository/songs_repository.dart';
import 'package:risuscito/core/infrastructure/songs/presentation/bloc/songs_bloc.dart';
import 'package:risuscito/core/infrastructure/songs/presentation/songs_biblical/bloc/songs_biblical_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _rs = GetIt.instance;

class SongsContainer {
  static Future<void> init() async {
    _rs.registerLazySingleton<SongsRepository>(
      () => SongsRepositoryImpl(
        localDatasource: _rs(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<SongsBloc>(create: (context) {
        SharedPreferences prefs = _rs();
        return SongsBloc(
          songsRepository: _rs(),
        )..add(
            GetLocalizedSongs(
              languageCode: prefs.getString('languageCode') ?? 'en',
            ),
          );
      }),
      BlocProvider<SongsBiblicalBloc>(create: (context) {
        SharedPreferences prefs = _rs();
        return SongsBiblicalBloc(
          songsRepository: _rs(),
        )..add(
            GetLocalizedSongsBiblical(
              languageCode: prefs.getString('languageCode') ?? 'en',
            ),
          );
      }),
    ];
  }
}
