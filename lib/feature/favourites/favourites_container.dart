import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:risuscito/feature/favourites/data/datasource/favourites_local_datasource.dart';
import 'package:risuscito/feature/favourites/data/repository/favourites_repository_impl.dart';
import 'package:risuscito/feature/favourites/domain/repository/favourites_repository.dart';
import 'package:risuscito/feature/favourites/presentation/bloc/favourites_bloc.dart';

final _rs = GetIt.instance;

class FavouritesContainer {
  static Future<void> init() async {
    _rs.registerLazySingleton<FavouritesLocalDatasource>(
      () => FavouritesLocalDatasource(
        sharedPreferences: _rs(),
      ),
    );
    _rs.registerLazySingleton<FavouritesRepository>(
      () => FavouritesRepositoryImpl(
        localDatasource: _rs(),
        favouritesLocalDatasource: _rs(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<FavouritesBloc>(create: (context) {
        return FavouritesBloc(
          favouritesRepository: _rs(),
        );
      }),
    ];
  }
}
