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
    final barreAtFret = l10n.translate('barre_at_fret') ?? 'Barré al %s tasto';
    final barreWithout = l10n.translate('barre_without') ?? 'Senza barré';
    final barreOriginal = l10n.translate('barre_original') ?? 'Barré originale';
    final resetLabel = l10n.translate('reset') ?? 'Reset';
    final cancelLabel = l10n.translate('cancel') ?? 'Annulla';

    final text = barreOffset == null
        ? barreOriginal
        : barreOffset == 0
            ? barreWithout
            : barreAtFret.replaceAll('%s', _toRoman(barreOffset!));

    return Column(
      children: [
        CupertinoButton(
          child: Text(text),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (_) => CupertinoActionSheet(
                actions: List.generate(13, (i) {
                  final label = i == 0
                      ? barreWithout
                      : barreAtFret.replaceAll('%s', _toRoman(i));
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
                  child: Text(cancelLabel),
                ),
              ),
            );
          },
        ),
        CupertinoButton(
          child: Text(resetLabel),
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
