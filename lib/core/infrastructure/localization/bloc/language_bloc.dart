import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../languages.dart';
import '../shared_prefs_service.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(Locale('en', 'US'))) {
    on<LanguageLoadStarted>((event, emit) async {
      final sharedPrefService = await SharedPreferencesService.instance;

      final defaultLanguageCode = sharedPrefService!.languageCode;
      Locale locale;

      if (defaultLanguageCode == null) {
        final parts = Platform.localeName.split('_');

        final languageCode = Platform.localeName.split('_')[0];

        if (parts.length == 2) {
          final countryCode = Platform.localeName.split('_')[1];

          locale = Locale(languageCode, countryCode);
          await sharedPrefService.setLanguage(locale.languageCode);
        } else {
          locale = Locale(languageCode, 'US');
          await sharedPrefService.setLanguage(locale.languageCode);
        }
      } else {
        locale = Locale(defaultLanguageCode);
      }

      emit(LanguageState(locale));
    });

    on<LanguageSelected>((event, emit) async {
      final sharedPrefService = await SharedPreferencesService.instance;

      if (sharedPrefService == null) {
        return;
      }
      final defaultLanguageCode = sharedPrefService.languageCode;

      if (event.languageCode == Language.it && defaultLanguageCode != 'it') {
        final locale = Locale('it', 'IT');
        await sharedPrefService.setLanguage(locale.languageCode);
        emit(LanguageState(locale));
      } else if (event.languageCode == Language.en &&
          defaultLanguageCode != 'en') {
        final locale = Locale('en', 'US');
        await sharedPrefService.setLanguage(locale.languageCode);
        emit(LanguageState(locale));
      } else if (event.languageCode == Language.uk &&
          defaultLanguageCode != 'uk') {
        final locale = Locale('uk', 'UA');
        await sharedPrefService.setLanguage(locale.languageCode);
        emit(LanguageState(locale));
      }
    });
  }
}
