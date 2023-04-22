import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/customization/theme/rs_theme_provider.dart';

class EmptyCard extends StatelessWidget {
  const EmptyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: themeChange.darkTheme
            ? RSColors.cardColorDark
            : RSColors.cardColorLight,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                '😕',
                style: TextStyle(fontSize: 40),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.translate('all_empty')!,
              style: TextStyle(
                color: themeChange.darkTheme
                    ? CupertinoColors.white
                    : CupertinoColors.black,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              AppLocalizations.of(context)!.translate('check_out_songs')!,
              style: TextStyle(
                color: CupertinoColors.inactiveGray,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
