import 'package:flutter/services.dart';
// import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class SongDomainModel {
  String? id;
  String? title;
  String? biblicalRef;
  String? number;
  String? content;
  String? htmlContent;
  String? url;
  Color? color;
  // WebViewPlus? songWebView;

  SongDomainModel({
    this.id,
    this.title,
    this.biblicalRef,
    this.number,
    this.content,
    this.htmlContent,
    this.url,
    this.color,
    // this.songWebView,
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
