import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:risuscito/core/rs_app.dart';
import 'package:risuscito/feature/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/infrastructure/log/bloc_logger.dart';
import 'core/infrastructure/log/logger.dart';

void main() async {
  runZonedGuarded(
    () async {
      await RSApp.init();
      Bloc.observer = LoggerBlocDelegate();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? onboarding = prefs.getBool('onboarding') ?? true;
      bool whatsNew = prefs.getBool('whats_new_v2') ?? true;
      runApp(
        RSApp(
          onboarding: onboarding,
          whatsNew: whatsNew,
          child: Home(),
        ),
      );
    },
    Logger.error,
  );
}
