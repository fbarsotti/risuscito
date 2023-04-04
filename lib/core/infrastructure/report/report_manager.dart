import 'dart:io';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/rs_utils.dart';
import '../error/types/failures.dart';
import '../rs_preferences.dart';

mixin RSReportManager {
  static void sendEmail(
    BuildContext context, {
    Failure? failure,
  }) async {
    await FLog.exportLogs();
    var path = await _localPath;
    path = '$path/FLogs';

    final random = RSUtils.getRandomNumber();
    final subject = 'Bug report #$random - ${DateTime.now().toString()}';

    String userMessage = '';

    if (failure != null) {
      userMessage += failure.e.toString();
      userMessage += failure.localizedDescription(context)!;
    }

    userMessage += await RSUtils.getDeviceData();
    final Email reportEmail = Email(
      body: userMessage,
      subject: subject,
      recipients: [RSPreferences.email],
      attachmentPaths: ['$path/flog.txt'],
      isHTML: false,
    );
    await FlutterEmailSender.send(reportEmail);
  }

  static Future<String?> get _localPath async {
    var directory;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }

    return directory.path;
  }
}
