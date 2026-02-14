import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/customization/theme/rs_theme_provider.dart';
import 'package:risuscito/core/presentation/header_text.dart';
import 'package:risuscito/feature/tools/presentation/prepare_word_page.dart';
import 'package:risuscito/feature/tools/presentation/prepare_eucharist_page.dart';

class ToolsSection extends StatelessWidget {
  const ToolsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: HeaderText(
            text: AppLocalizations.of(context)!.translate('tools')!,
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _ToolCard(
                text: AppLocalizations.of(context)!.translate('prepare_word')!,
                icon: CupertinoIcons.book,
                iconColor: CupertinoColors.systemIndigo,
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const PrepareWordPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              _ToolCard(
                text: AppLocalizations.of(context)!
                    .translate('prepare_eucharist')!,
                icon: CupertinoIcons.flame,
                iconColor: CupertinoColors.systemOrange,
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const PrepareEucharistPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToolCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _ToolCard({
    Key? key,
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CupertinoButton(
      pressedOpacity: themeChange.darkTheme ? 0.8 : 0.4,
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: themeChange.darkTheme
              ? RSColors.cardColorDark
              : RSColors.cardColorLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: iconColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: themeChange.darkTheme
                      ? RSColors.darkText
                      : RSColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: CupertinoColors.inactiveGray,
            ),
          ],
        ),
      ),
    );
  }
}
