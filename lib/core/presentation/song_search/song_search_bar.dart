import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/infrastructure/localization/app_localizations.dart';
import 'package:risuscito/feature/search/sections/search_tag.dart';

class SongSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final int selectedTag;
  final ValueChanged<int> onTagChanged;
  final FocusNode? focusNode;

  const SongSearchBar({
    Key? key,
    required this.controller,
    required this.selectedTag,
    required this.onTagChanged,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: CupertinoSearchTextField(
            padding: EdgeInsets.all(12),
            controller: controller,
            focusNode: focusNode,
            placeholder:
                AppLocalizations.of(context)!.translate('search_a_song'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
          child: Text(
            AppLocalizations.of(context)!.translate('search_in')!,
            style: TextStyle(
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 16),
              SearchTag(
                onTap: () => onTagChanged(0),
                text: AppLocalizations.of(context)!.translate('title')!,
                icon: CupertinoIcons.textbox,
                selected: selectedTag == 0,
              ),
              const SizedBox(width: 8),
              SearchTag(
                onTap: () => onTagChanged(1),
                text: AppLocalizations.of(context)!.translate('lyrics')!,
                icon: CupertinoIcons.doc_plaintext,
                selected: selectedTag == 1,
              ),
              const SizedBox(width: 8),
              SearchTag(
                onTap: () => onTagChanged(2),
                text: AppLocalizations.of(context)!
                    .translate('biblical_reference')!,
                icon: CupertinoIcons.book,
                selected: selectedTag == 2,
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
