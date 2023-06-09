import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/header_text.dart';

class EmptySearch extends StatelessWidget {
  const EmptySearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          CupertinoIcons.bin_xmark,
          size: 80,
        ),
        const SizedBox(
          height: 16,
        ),
        HeaderText(
          text: AppLocalizations.of(context)!.translate('no_result')!,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            AppLocalizations.of(context)!.translate('no_result_full')!,
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
