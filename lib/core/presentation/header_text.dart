import 'package:flutter/cupertino.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final double fontSize;

  /// Font size of CupertinoListSection.insetGrouped headers, for home sections
  /// shown next to them (e.g. "Strumenti").
  static const double sectionFontSize = 20;

  const HeaderText({
    required this.text,
    required this.textAlign,
    this.fontSize = 22,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
