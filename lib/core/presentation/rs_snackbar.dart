import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';

import 'customization/theme/rs_theme_provider.dart';

class RSSnackBar extends StatelessWidget {
  final String content;
  final IconData icon;
  const RSSnackBar({
    Key? key,
    required this.content,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Card(
      // decoration: BoxDecoration(
      //   color: CupertinoColors.white,
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(16),
      //   ),
      // ),
      color: themeChange.darkTheme
          ? RSColors.cardColorDark
          : RSColors.cardColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: CupertinoColors.activeGreen,
              child: Icon(
                icon,
                color: CupertinoColors.white,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              content,
              style: TextStyle(
                color: themeChange.darkTheme
                    ? RSColors.darkText
                    : RSColors.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
