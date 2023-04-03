import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core_container.dart';
import 'infrastructure/localization/app_localizations.dart';
import 'infrastructure/localization/bloc/language_bloc.dart';
import 'presentation/customization/rs_colors.dart';

class RSApp extends StatelessWidget {
  final Widget child;

  const RSApp({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ...CoreContainer.getBlocProviders(),
        BlocProvider<LanguageBloc>(
          create: (_) => LanguageBloc()..add(LanguageLoadStarted()),
        ),
      ],
      child: child,
    );
  }

  static List<Locale> get supportedLocales {
    return [
      Locale('en', 'US'),
      Locale('it', 'IT'),
    ];
  }

  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates {
    return [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate
    ];
  }

  static ThemeData get defaultTheme {
    return ThemeData(
      fontFamily: 'Quicksand',
      scaffoldBackgroundColor: Colors.white,
      primaryColor: RSColors.primary,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primarySwatch: RSColors.generateMaterialColor(RSColors.primary),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          textStyle:
              TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  static TextStyle get defaultTextThemeData {
    return TextStyle(
      color: CupertinoDynamicColor.withBrightness(
        color: RSColors.text,
        darkColor: RSColors.darkText,
      ),
    );
  }

  static Future<void> init() async {
    // E' necessario aggiungerlo prima della dependency injection
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    await CoreContainer.init();

    // Bloc.observer = LoggerBlocDelegate();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ));
  }
}
