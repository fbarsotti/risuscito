import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:risuscito/feature/index/alphabetical/data/repository/alphabetical_index_repository_impl.dart';
import 'package:risuscito/feature/index/alphabetical/domain/repository/alphabetical_index_repository.dart';
import 'package:risuscito/feature/index/alphabetical/presentation/bloc/alphabetical_index_bloc.dart';

final _rs = GetIt.instance;

class AlphabeticalIndexContainer {
  static Future<void> init() async {
    _rs.registerLazySingleton<AlphabeticalIndexRepository>(
      () => AlphabeticalIndexRepositoryImpl(
        localDatasource: _rs(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<AlphabeticalIndexBloc>(
        create: (context) => AlphabeticalIndexBloc(
          alphabeticalIndexRepository: _rs(),
        ),
      ),
    ];
  }
}
