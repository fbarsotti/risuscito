import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:risuscito/core/infrastructure/songs/data/datasource/songs_datasource.dart';
import 'package:risuscito/core/infrastructure/songs/songs_container.dart';
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
      () => SongsDatasource(
        sharedPreferences: _rs(),
      ),
    );

    final sharedPreferences = await SharedPreferences.getInstance();
    _rs.registerLazySingleton(() => sharedPreferences);

    _rs.registerLazySingleton<Dio>(RSDioClient.createDio);

    await SongsContainer.init();
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      ...SongsContainer.getBlocProviders(),
    ];
  }
}
