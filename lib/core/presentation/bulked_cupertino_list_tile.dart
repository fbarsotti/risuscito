import 'package:flutter/cupertino.dart';

class BulkedCupertinoListTile extends StatelessWidget {
  final String text;
  final Icon icon;
  final Function onTap;

  const BulkedCupertinoListTile({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      title: Container(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      leading: icon,
      trailing: const CupertinoListTileChevron(),
      onTap: () {
        onTap();
      },
    );
  }
}
