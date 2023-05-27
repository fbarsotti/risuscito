import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/header_text.dart';

class NotSearching extends StatelessWidget {
  final int selectedTag;
  const NotSearching({
    Key? key,
    required this.selectedTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon(
        //   CupertinoIcons.doc_text_search,
        //   size: 80,
        // ),
        // const SizedBox(
        //   height: 16,
        // ),
        HeaderText(
          text: selectedTag != 2
              ? AppLocalizations.of(context)!.translate('type')!
              : AppLocalizations.of(context)!.translate('type_1')!,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            selectedTag != 2
                ? AppLocalizations.of(context)!.translate('type_full')!
                : AppLocalizations.of(context)!.translate('type_1_full')!,
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
