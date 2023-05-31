import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasource/history_local_datasource.dart';
import 'data/repository/history_repository_impl.dart';
import 'domain/repository/history_repository.dart';
import 'presentation/bloc/history_bloc.dart';

final _rs = GetIt.instance;

class HistoryContainer {
  static Future<void> init() async {
    _rs.registerLazySingleton<HistoryLocalDatasource>(
      () => HistoryLocalDatasource(
        sharedPreferences: _rs(),
      ),
    );
    _rs.registerLazySingleton<HistoryRepository>(
      () => HistoryRepositoryImpl(
        localDatasource: _rs(),
        historyLocalDatasource: _rs(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<HistoryBloc>(create: (context) {
        SharedPreferences prefs = _rs();
        return HistoryBloc(
          historyRepository: _rs(),
        )..add(
            GetLocalizedHistory(
              languageCode: prefs.getString('languageCode') ?? 'en',
            ),
          );
      }),
    ];
  }
}
