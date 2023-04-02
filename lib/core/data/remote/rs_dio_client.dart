import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:risuscito/core/data/remote/rs_api_config.dart';
import '../../infrastructure/log/logger.dart';

// navigator for alice http inspector
final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class RSDioClient {
  static Dio createDio() {
    final options = BaseOptions(
      baseUrl: RSApiConfig.apiUrl,
      contentType: ContentType.json.value,
      responseType: ResponseType.json,
    );

    final dio = Dio(options);

    // certificate to solve problems with android simulator
    if (kDebugMode && Platform.isAndroid) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          Logger.info(
            '🌐 [DioREQUEST] -> ${options.path}',
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          Logger.info(
            // ignore: lines_longer_than_80_chars
            '🌐 [DioEND] -> Response -> ${response.statusCode}[${response.requestOptions.path}] ${response.requestOptions.method}  ${response.requestOptions.responseType}',
          );

          // continue with the chain
          return handler.next(response);
        },
        onError: (error, handler) async {
          if (error.response != null) {
            Logger.networkError(
              '🤮 [DioERROR] ${error.type}',
              Exception(
                // ignore: lines_longer_than_80_chars
                'Url: [${error.requestOptions.baseUrl}] status:${error.response!.statusCode} type:${error.type} Data: ${error.response!.data} message: ${error.message}',
              ),
            );
          } else {
            print(error);
          }

          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
