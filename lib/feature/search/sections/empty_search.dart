import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:risuscito/core/presentation/header_text.dart';

class EmptySearch extends StatelessWidget {
  const EmptySearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          CupertinoIcons.doc_text_search,
          size: 80,
        ),
        const SizedBox(
          height: 16,
        ),
        HeaderText(
          text: 'Digita 3 caratteri',
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(
            'Comincia la ricerca digitando almeno 3 caratteri',
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
