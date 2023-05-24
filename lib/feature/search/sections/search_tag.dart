import 'package:enough_platform_widgets/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/customization/theme/rs_theme_provider.dart';

class SearchTag extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onTap;
  final bool selected;
  const SearchTag({
    Key? key,
    required this.onTap,
    required this.text,
    required this.icon,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CupertinoInkWell(
      child: Center(
        child: AnimatedContainer(
          decoration: BoxDecoration(
            color: selected
                ? RSColors.primary
                : themeChange.darkTheme
                    ? RSColors.bgDarkColor
                    : RSColors.bgColor,
            border: Border.all(
              color: selected ? RSColors.primary : CupertinoColors.systemGrey,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color:
                    selected ? RSColors.darkText : CupertinoColors.systemGrey,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                text,
                style: TextStyle(
                  color:
                      selected ? RSColors.darkText : CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            top: 6.0,
            bottom: 6.0,
            left: 10,
            right: 10,
          ),
          duration: Duration(milliseconds: 300),
        ),
      ),
      onTap: onTap,
      // deleteIcon: Icon(CupertinoIcons.add),
      // onDeleted: () => ,
    );
  }
}
