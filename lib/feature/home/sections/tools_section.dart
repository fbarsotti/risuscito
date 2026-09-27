import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/bulked_cupertino_list_tile.dart';
import 'package:risuscito/feature/tools/presentation/prepare_celebration_page.dart';

class ToolsSection extends StatelessWidget {
  const ToolsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: Text(
        AppLocalizations.of(context)!.translate('tools')!,
      ),
      children: [
        BulkedCupertinoListTile(
          text: AppLocalizations.of(context)!.translate('prepare_word')!,
          icon: Icon(
            CupertinoIcons.book_circle,
            size: 30,
          ),
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const PrepareCelebrationPage.word(),
              ),
            );
          },
        ),
        BulkedCupertinoListTile(
          text: AppLocalizations.of(context)!.translate('prepare_eucharist')!,
          icon: Icon(
            CupertinoIcons.group_solid,
            size: 30,
          ),
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const PrepareCelebrationPage.eucharist(),
              ),
            );
          },
        ),
      ],
    );
  }
}
