import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';

class SongTransposer extends StatelessWidget {
  final int transposeOffset;
  final void Function(int delta) onTranspose;

  const SongTransposer({
    Key? key,
    required this.transposeOffset,
    required this.onTranspose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 40),
              CupertinoButton(
                child: const Text("-1"),
                onPressed: () => onTranspose(-1),
              ),
              const Spacer(),
              Text(
                transposeOffset == 0
                    ? AppLocalizations.of(context)!.translate('original_key')!
                    : "${transposeOffset > 0 ? '+' : ''}$transposeOffset",
                style: TextStyle(
                  color: RSColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              CupertinoButton(
                child: const Text("+1"),
                onPressed: () => onTranspose(1),
              ),
              const SizedBox(width: 40),
            ],
          ),
          CupertinoButton(
            child: const Text("Reset"),
            sizeStyle: CupertinoButtonSize.small,
            onPressed: () => onTranspose(-transposeOffset),
          ),
        ],
      ),
    );
  }
}
