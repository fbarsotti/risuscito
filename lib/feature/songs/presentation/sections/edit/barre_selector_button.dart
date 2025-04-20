import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';

class BarreSelectorButton extends StatelessWidget {
  final int? barreOffset;
  final void Function(int) onChanged;
  final VoidCallback onReset;

  const BarreSelectorButton({
    Key? key,
    required this.barreOffset,
    required this.onChanged,
    required this.onReset,
  }) : super(key: key);

  String _toRoman(int value) {
    const roman = [
      '',
      'I',
      'II',
      'III',
      'IV',
      'V',
      'VI',
      'VII',
      'VIII',
      'IX',
      'X',
      'XI',
      'XII'
    ];
    return roman[value];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = l10n.translate('barre') ?? 'Barré';

    final text = barreOffset == null
        ? '$title originale' // nessuna preferenza salvata
        : barreOffset == 0
            ? 'Senza barré'
            : '$title al ${_toRoman(barreOffset!)} tasto';

    return Column(
      children: [
        CupertinoButton(
          child: Text(text),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (_) => CupertinoActionSheet(
                title: Text(title),
                actions: List.generate(13, (i) {
                  final label =
                      i == 0 ? 'Senza barré' : '$title al ${_toRoman(i)} tasto';
                  return CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      onChanged(i);
                    },
                    child: Text(label),
                  );
                }),
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  isDefaultAction: true,
                  child: const Text('Annulla'),
                ),
              ),
            );
          },
        ),
        CupertinoButton(
          child: const Text('Reset'),
          sizeStyle: CupertinoButtonSize.small,
          onPressed: onReset,
        ),
        const SizedBox(height: 8),
        Divider(
          height: 1,
          color: RSColors.lightText,
        ),
      ],
    );
  }
}
