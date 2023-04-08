import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risuscito/core/rs_app.dart';
import 'package:risuscito/feature/home/home.dart';
import 'core/infrastructure/log/bloc_logger.dart';
import 'core/infrastructure/log/logger.dart';

void main() async {
  await RSApp.init();

  Bloc.observer = LoggerBlocDelegate();

  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  //   statusBarIconBrightness: Brightness.dark,
  // ));

  runZonedGuarded(() {
    runApp(
      RSApp(child: Home()),
    );
  }, Logger.error);
}
