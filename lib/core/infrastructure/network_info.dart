import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'log/logger.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({
    required this.connectivity,
  });

  /// Checks if a user is conntected to the [network]
  @override
  Future<bool> get isConnected async {
    final connection = await connectivity.checkConnectivity();
    Logger.info(connection.toString());
    return !connection.contains(ConnectivityResult.none);
  }
}
