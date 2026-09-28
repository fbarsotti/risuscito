import 'package:flutter/cupertino.dart';

/// Hides the keyboard insets (MediaQuery.viewInsets) from [child].
///
/// Some widgets (e.g. SwipeActionCell) depend on the whole MediaQuery, so they
/// rebuild on every frame of the keyboard animation. Pages don't resize for
/// the keyboard, so lists don't need the insets: with them removed the
/// MediaQuery data seen by [child] stays the same while the keyboard moves and
/// its rows are not rebuilt. Works with both box and sliver children.
class IgnoreKeyboardInsets extends StatelessWidget {
  final Widget child;

  const IgnoreKeyboardInsets({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: child,
    );
  }
}
