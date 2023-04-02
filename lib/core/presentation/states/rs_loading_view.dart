import 'package:flutter/material.dart';

class RSLoadingView extends StatelessWidget {
  const RSLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
