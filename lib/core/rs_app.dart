import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/presentation/customization/theme/rs_theme_provider.dart';
import '../feature/home/home_page.dart';
import 'core_container.dart';
import 'data/remote/rs_dio_client.dart';
import 'infrastructure/localization/app_localizations.dart';
import 'infrastructure/localization/bloc/language_bloc.dart';
import 'presentation/customization/rs_colors.dart';

class RSApp extends StatefulWidget {
  final Widget child;

  const RSApp({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<RSApp> createState() => _RSAppState();

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

  static TextStyle headerTextStyle(bool darkTheme) {
    return TextStyle(
      color: darkTheme ? RSColors.darkText : RSColors.text,
      fontSize: 24,
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

class _RSAppState extends State<RSApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ...CoreContainer.getBlocProviders(),
        BlocProvider<LanguageBloc>(
          create: (_) => LanguageBloc()..add(LanguageLoadStarted()),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => themeChangeProvider,
        child: Consumer<DarkThemeProvider>(
          builder: (context, value, child) {
            return BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, languageState) {
                return CupertinoApp(
                  title: 'Risuscitò',
                  navigatorKey: navigatorKey,
                  supportedLocales: RSApp.supportedLocales,
                  localizationsDelegates: RSApp.localizationsDelegates,
                  locale: languageState.locale,
                  debugShowCheckedModeBanner: false,
                  theme: CupertinoThemeData(
                    scaffoldBackgroundColor: RSColors.bgColor,
                    brightness:
                        value.darkTheme ? Brightness.dark : Brightness.light,
                    // barBackgroundColor: RSColors.bgColor,
                    // scaffoldBackgroundColor: RSColors.bgColor,
                    primaryColor: RSColors.primary,
                    textTheme: CupertinoTextThemeData(
                      textStyle: RSApp.defaultTextThemeData,
                    ),
                  ),
                  home: widget.child,
                );
                // return MaterialApp(
                //   title: 'Studio Lab',
                //   navigatorKey: navigatorKey,
                //   supportedLocales: RSApp.supportedLocales,
                //   localizationsDelegates: RSApp.localizationsDelegates,
                //   locale: languageState.locale,
                //   debugShowCheckedModeBanner: false,
                //   theme: ThemeData(
                //     fontFamily: 'Montserrat',
                //     scaffoldBackgroundColor: Color(0xffffffff),
                //     primaryColor: RSColors.primary,
                //     primarySwatch: Colors.teal,
                //     visualDensity: VisualDensity.adaptivePlatformDensity,
                //   ),
                //   home: HomePage(),
                // );
              },
            );
          },
        ),
      ),
    );
  }
}
