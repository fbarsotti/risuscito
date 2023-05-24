import 'package:flutter/cupertino.dart';

import 'header_text.dart';

class EmptyPageMessage extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;

  const EmptyPageMessage({
    Key? key,
    this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (icon != null)
          Icon(
            icon,
            size: 80,
          ),
        if (icon != null)
          const SizedBox(
            height: 16,
          ),
        HeaderText(
          text: title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CupertinoColors.inactiveGray,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
