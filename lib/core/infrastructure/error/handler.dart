import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';

import '../log/logger.dart';

Failure handleError(
  dynamic e, [
  StackTrace? s,
]) {
  if (e is Exception) {
  } else {
    e = Exception(e.toString());
  }

  return _handleError(e, s ?? StackTrace.current);
}

Failure _handleError(
  Exception e, [
  StackTrace? s,
]) {
  // log the errror
  Logger.error(e, s ?? StackTrace.current);

  if (e is DioError) {
    if (e is TimeoutException || e is SocketException || e.response == null) {
      return NetworkFailure(dioError: e);
    } else if (e.response!.data.toString().contains('403')) {
      return UnauthorizedFailure();
    } else if (e.response!.statusCode! >= 500) {
      return ServerFailure(e);
    } else {
      return NetworkFailure(dioError: e);
    }
  } else {
    return GenericFailure(e: e);
  }
}
