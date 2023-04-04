import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:risuscito/core/data/remote/rs_dio_client.dart';

import 'infrastructure/network_info.dart';

final rs = GetIt.instance;

class CoreContainer {
  static Future<void> init() async {
    // wait for all modules

    rs.registerLazySingleton<Connectivity>(
      () => Connectivity(),
    );

    rs.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivity: rs()),
    );

    final sharedPreferences = await SharedPreferences.getInstance();
    rs.registerLazySingleton(() => sharedPreferences);

    rs.registerLazySingleton<Dio>(RSDioClient.createDio);
  }

  static List<BlocProvider> getBlocProviders() {
    // get all modules providers
    return [];
  }
}
