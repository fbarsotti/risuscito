import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _rs = GetIt.instance;

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = _rs();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = _rs();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}
