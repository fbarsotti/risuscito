import 'package:flutter/cupertino.dart';

/// Shows [child] the MediaQuery it would have without the keyboard: no
/// viewInsets, and padding equal to viewPadding (the keyboard also shrinks
/// padding.bottom while it is open).
///
/// Used around CupertinoTabScaffold: it reads MediaQuery.of(context), so it
/// rebuilt on every frame of the keyboard animation; that recreated the tab
/// Navigators, and Navigator.didUpdateWidget forces every route's page to
/// rebuild (ModalRoute.changedExternalState). With this wrapper the data seen
/// by the tabs stays the same while the keyboard moves. Pages don't resize
/// for the keyboard, so they don't need the insets.
class IgnoreKeyboardInsets extends StatelessWidget {
  final Widget child;

  const IgnoreKeyboardInsets({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return MediaQuery(
      data: data.copyWith(
        viewInsets: EdgeInsets.zero,
        padding: data.viewPadding,
      ),
      child: child,
    );
  }
}
