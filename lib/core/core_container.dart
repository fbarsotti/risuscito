import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:risuscito/core/data/local/base_local_datasource.dart';
import 'package:risuscito/feature/index/alphabetical/alphabetical_index_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/remote/rs_dio_client.dart';
import 'infrastructure/network_info.dart';

final _rs = GetIt.instance;

class CoreContainer {
  static Future<void> init() async {
    // wait for all modules

    _rs.registerLazySingleton<Connectivity>(
      () => Connectivity(),
    );

    _rs.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivity: _rs()),
    );

    _rs.registerLazySingleton(
      () => BaseLocalDatasource(
        sharedPreferences: _rs(),
      ),
    );

    final sharedPreferences = await SharedPreferences.getInstance();
    _rs.registerLazySingleton(() => sharedPreferences);

    _rs.registerLazySingleton<Dio>(RSDioClient.createDio);

    await AlphabeticalIndexContainer.init();
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      ...AlphabeticalIndexContainer.getBlocProviders(),
    ];
  }
}
