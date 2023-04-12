import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatasource {
  final SharedPreferences? sharedPreferences;

  LocalDatasource({
    required this.sharedPreferences,
  });

  Future<String> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
