import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';

import 'customization/theme/rs_theme_provider.dart';

class QuickActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;

  const QuickActionButton({
    required this.text,
    required this.icon,
    required this.iconColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 40,
        top: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          //color: bgColor,
          color: themeChange.darkTheme
              ? RSColors.cardColorDark
              : RSColors.cardColorLight,
          boxShadow: [
            // !themeChange.darkTheme
            // CupertinoColors.inactiveGray
            BoxShadow(
              color: themeChange.darkTheme
                  ? CupertinoColors.darkBackgroundGray.withOpacity(0.8)
                  : CupertinoColors.inactiveGray.withOpacity(0.4),
              blurRadius: 20,
              offset: Offset(8, 20), // Shadow position
            )
            // : BoxShadow(),
          ],
        ),
        width: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Icon(
                icon,
                size: 64,
                color: iconColor,
              ),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    themeChange.darkTheme ? RSColors.darkText : RSColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
