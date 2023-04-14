
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/customization/theme/rs_theme_provider.dart';

class SongCard extends StatelessWidget {
  final String title;
  final int number;
  final Color color;

  const SongCard({
    Key? key,
    required this.title,
    required this.number,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CupertinoButton(
      pressedOpacity: themeChange.darkTheme ? 0.8 : 0.4,
      padding: EdgeInsets.zero,
      onPressed: () {},
      child: Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Canto $number',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: CupertinoColors.systemGrey,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                title,
                style: TextStyle(
                  color: themeChange.darkTheme ? Colors.white : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
        // child: Row(
        //   children: [
        //     Container(
        //       width: MediaQuery.of(context).size.width / 4,
        //       decoration: BoxDecoration(
        //         color: Colors.green[300],
        //         borderRadius: const BorderRadius.only(
        //           topLeft: Radius.circular(8.0),
        //           bottomLeft: Radius.circular(8.0),
        //         ),
        //       ),
        //       child: Center(
        //         child: Text(
        //           '98',
        //           style: TextStyle(
        //             color: RSColors.primary,
        //             fontSize: 28,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ),
        //     ),
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text('Cantico dei cantici'),
        //       ],
        //     )
        //   ],
        // ),
      ),
    );
  }
}
