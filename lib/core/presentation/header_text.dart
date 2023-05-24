import 'package:flutter/cupertino.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const HeaderText({
    required this.text,
    required this.textAlign,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
