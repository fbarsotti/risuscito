import 'package:flutter/cupertino.dart';

import '../infrastructure/localization/app_localizations.dart';

class RSDatesUtils {
  static String? localizedTimeMessage(BuildContext context) {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return AppLocalizations.of(context)!.translate('welcome_morning');
    }
    if (hour < 17) {
      return AppLocalizations.of(context)!.translate('welcome_afternoon');
    }

    return AppLocalizations.of(context)!.translate('welcome_evening');
  }

  static bool areSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
