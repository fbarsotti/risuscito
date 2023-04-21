import 'package:enough_platform_widgets/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';

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
    return CupertinoInkWell(
      child: Center(
        child: AnimatedContainer(
          decoration: BoxDecoration(
            color: selected ? RSColors.tagBg : Colors.transparent,
            border: Border.all(color: CupertinoColors.systemGrey),
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: RSColors.tagInactive,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                text,
                style: TextStyle(
                  color: RSColors.tagInactive,
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
