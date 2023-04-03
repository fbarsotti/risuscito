import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/rs_app.dart';
import 'package:risuscito/feature/home/home_page.dart';
import 'core/data/remote/rs_dio_client.dart';
import 'core/infrastructure/localization/app_localizations.dart';
import 'core/infrastructure/localization/bloc/language_bloc.dart';
import 'core/infrastructure/log/bloc_logger.dart';
import 'core/infrastructure/log/logger.dart';

void main() async {
  await RSApp.init();

  Bloc.observer = LoggerBlocDelegate();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runZonedGuarded(() {
    runApp(
      RSApp(
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, languageState) {
            return MaterialApp(
              title: 'Studio Lab',
              navigatorKey: navigatorKey,
              supportedLocales: RSApp.supportedLocales,
              localizationsDelegates: RSApp.localizationsDelegates,
              locale: languageState.locale,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Montserrat',
                scaffoldBackgroundColor: Color(0xffffffff),
                primaryColor: RSColors.primary,
                primarySwatch: Colors.teal,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: HomePage(),
            );
          },
        ),
      ),
    );
  }, Logger.error);
}
