import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';

/// Compact single-row bar shown at the bottom of the song page in edit mode:
/// transposition (-1 / value / +1 / reset) and barré (picker / reset).
class SongEditBar extends StatelessWidget {
  final int transposeOffset;
  final void Function(int delta) onTranspose;
  final VoidCallback onTransposeReset;
  final int? barreOffset;
  final void Function(int) onBarreChanged;
  final VoidCallback onBarreReset;
  final double bottomPadding;

  const SongEditBar({
    Key? key,
    required this.transposeOffset,
    required this.onTranspose,
    required this.onTransposeReset,
    required this.barreOffset,
    required this.onBarreChanged,
    required this.onBarreReset,
    this.bottomPadding = 0,
  }) : super(key: key);

  static const _roman = [
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

  String _barreLabel(AppLocalizations l10n) {
    if (barreOffset == null) {
      return l10n.translate('barre_original') ?? 'Barré originale';
    }
    if (barreOffset == 0) {
      return l10n.translate('barre_without') ?? 'Senza barré';
    }
    return (l10n.translate('barre_short') ?? 'Barré %s')
        .replaceAll('%s', _roman[barreOffset!]);
  }

  void _showBarrePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final barreAtFret = l10n.translate('barre_at_fret') ?? 'Barré al %s tasto';
    final barreWithout = l10n.translate('barre_without') ?? 'Senza barré';
    var selected = barreOffset ?? 0;

    showCupertinoModalPopup(
      context: context,
      builder: (popupContext) => Container(
        height: 280,
        color: CupertinoColors.systemBackground.resolveFrom(popupContext),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text(l10n.translate('cancel') ?? 'Annulla'),
                    onPressed: () => Navigator.pop(popupContext),
                  ),
                  CupertinoButton(
                    child: Text(
                      l10n.translate('ok') ?? 'Ok',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(popupContext);
                      if (selected != barreOffset) onBarreChanged(selected);
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 36,
                  scrollController:
                      FixedExtentScrollController(initialItem: selected),
                  onSelectedItemChanged: (index) => selected = index,
                  children: List.generate(
                    _roman.length,
                    (i) => Center(
                      child: Text(
                        i == 0
                            ? barreWithout
                            : barreAtFret.replaceAll('%s', _roman[i]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final separator = CupertinoColors.separator.resolveFrom(context);

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemFill,
        border: Border(top: BorderSide(color: separator, width: 0.5)),
      ),
      padding: EdgeInsets.only(
        left: 4,
        right: 4,
        top: 2,
        bottom: 2 + bottomPadding,
      ),
      // Two equal halves (transposition | barré), each centered
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BarIconButton(
                  icon: CupertinoIcons.minus,
                  onPressed: () => onTranspose(-1),
                ),
                SizedBox(
                  width: 36,
                  child: Text(
                    transposeOffset > 0
                        ? '+$transposeOffset'
                        : '$transposeOffset',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: RSColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _BarIconButton(
                  icon: CupertinoIcons.plus,
                  onPressed: () => onTranspose(1),
                ),
                _BarIconButton(
                  icon: CupertinoIcons.arrow_counterclockwise,
                  onPressed: transposeOffset == 0 ? null : onTransposeReset,
                ),
              ],
            ),
          ),
          Container(width: 0.5, height: 28, color: separator),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    onPressed: () => _showBarrePicker(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            _barreLabel(l10n),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(CupertinoIcons.chevron_down, size: 14),
                      ],
                    ),
                  ),
                ),
                _BarIconButton(
                  icon: CupertinoIcons.arrow_counterclockwise,
                  onPressed: barreOffset == null ? null : onBarreReset,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _BarIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(44, 44),
      onPressed: onPressed,
      child: Icon(icon, size: 22),
    );
  }
}
