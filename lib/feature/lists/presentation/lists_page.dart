import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/empty_page_message.dart';

class ListsPage extends StatelessWidget {
  const ListsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
            AppLocalizations.of(context)!.translate('personalized_lists')!),
        previousPageTitle: AppLocalizations.of(context)!.translate('home'),
        trailing: CupertinoButton(
          // color: Colors.red,
          padding: EdgeInsets.all(1.0),
          onPressed: () {},
          child: Icon(
            CupertinoIcons.plus,
          ),
        ),
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                child: EmptyPageMessage(
                  icon: CupertinoIcons.rectangle_stack_badge_person_crop,
                  title:
                      AppLocalizations.of(context)!.translate('lists_empty')!,
                  subtitle: AppLocalizations.of(context)!
                      .translate('lists_empty_full')!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
