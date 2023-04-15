import 'package:flutter/services.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class SongDomainModel {
  String? id;
  String? title;
  String? number;
  String? content;
  Color? color;
  WebViewPlus? songWebView;

  SongDomainModel({
    this.id,
    this.title,
    this.number,
    this.content,
    this.color,
    this.songWebView,
  });

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is SongDomainModel &&
  //       other.id == id &&
  //       other.title == title &&
  //       other.number == number;
  // }
}
