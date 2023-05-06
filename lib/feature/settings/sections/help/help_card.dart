import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/customization/theme/rs_theme_provider.dart';

class HelpCard extends StatelessWidget {
  final String question;
  final String answer;

  const HelpCard({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    // return CupertinoButton(
    //   // pressedOpacity: themeChange.darkTheme ? 0.8 : 0.4,
    //   padding: EdgeInsets.zero,
    //   onPressed: null,
    return Container(
      // height: 70,
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(
                color:
                    themeChange.darkTheme ? RSColors.darkText : RSColors.text,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              answer,
              style: TextStyle(
                color:
                    themeChange.darkTheme ? RSColors.darkText : RSColors.text,
                fontSize: 16,
              ),
            ),
            // Spacer(),
            // Icon(
            //   CupertinoIcons.chevron_right,
            //   color: CupertinoColors.systemGrey,
            //   size: 20,
            // ),
          ],
        ),
      ),
    );
  }
}
