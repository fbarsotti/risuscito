import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/feature/settings/sections/help/help_card.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.translate('settings'),
        middle: Text(AppLocalizations.of(context)!.translate('help')!),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 16,
            ),
            HelpCard(
              question:
                  AppLocalizations.of(context)!.translate('help_question_one')!,
              answer:
                  AppLocalizations.of(context)!.translate('help_answer_one')!,
            ),
            const SizedBox(
              height: 16,
            ),
            HelpCard(
              question:
                  AppLocalizations.of(context)!.translate('help_question_two')!,
              answer:
                  AppLocalizations.of(context)!.translate('help_answer_two')!,
            ),
          ],
        ),
      ),
    );
  }
}
