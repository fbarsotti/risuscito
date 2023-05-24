import 'package:flutter/cupertino.dart';
import '../../../core/presentation/customization/rs_colors.dart';

class LogoCard extends StatelessWidget {
  const LogoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: RSColors.cardColorDark,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/risuscito_logo_white.png',
              // scale: 7,
            ),
            Text(
              'Canti del Cammino Neocatecumenale',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: RSColors.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
