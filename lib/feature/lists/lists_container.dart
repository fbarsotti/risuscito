import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:risuscito/feature/lists/data/datasource/lists_local_datasource.dart';
import 'package:risuscito/feature/lists/data/repository/lists_repository_impl.dart';
import 'package:risuscito/feature/lists/domain/repository/lists_repository.dart';
import 'package:risuscito/feature/lists/presentation/bloc/lists_bloc.dart';

final _rs = GetIt.instance;

class ListsContainer {
  static Future<void> init() async {
    _rs.registerLazySingleton<ListsLocalDatasource>(
      () => ListsLocalDatasource(
        sharedPreferences: _rs(),
      ),
    );
    _rs.registerLazySingleton<ListsRepository>(
      () => ListsRepositoryImpl(
        listsLocalDatasource: _rs(),
        songParser: _rs(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<ListsBloc>(create: (context) {
        return ListsBloc(
          listsRepository: _rs(),
        );
      }),
    ];
  }
}
